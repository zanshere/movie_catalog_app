import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String movieTitle;
  final bool isLocal;

  const VideoPlayerScreen({
    Key? key,
    required this.videoUrl,
    required this.movieTitle,
    this.isLocal = false,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _hasError = false;
  bool _showControls = true;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  String _errorMessage = '';
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      print('Initializing video: ${widget.videoUrl}');
      print('Is local: ${widget.isLocal}');

      if (widget.isLocal) {
        _controller = VideoPlayerController.asset(widget.videoUrl);
      } else {
        _controller = VideoPlayerController.network(widget.videoUrl);
      }
      
      await _controller.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Video initialization timeout');
        },
      );
      
      // Tunggu sampai durasi video benar-benar tersedia
      Duration duration = _controller.value.duration;
      int attempts = 0;
      while ((duration == Duration.zero || duration.inSeconds < 1) && attempts < 20) {
        await Future.delayed(const Duration(milliseconds: 500));
        duration = _controller.value.duration;
        attempts++;
        print('Waiting for duration... Attempt $attempts: $duration');
      }
      
      _controller.addListener(_videoListener);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _totalDuration = duration;
          _currentPosition = _controller.value.position;
        });
      }

      print('Video initialized successfully');
      print('Final Duration: $duration');
      print('Aspect ratio: ${_controller.value.aspectRatio}');

      _controller.play();
      _autoHideControls();

    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _videoListener() {
    if (!mounted || _isDragging) return;
    
    final currentPosition = _controller.value.position;
    final duration = _controller.value.duration;
    final isPlaying = _controller.value.isPlaying;

    // Update state setiap perubahan
    setState(() {
      _currentPosition = currentPosition;
      _totalDuration = duration;
      _isPlaying = isPlaying;
    });
  }

  void _autoHideControls() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isPlaying && !_isDragging) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
        _autoHideControls();
      }
    });
  }

  void _seekForward() {
    final newPosition = _currentPosition + const Duration(minutes: 1);
    if (newPosition < _totalDuration) {
      _controller.seekTo(newPosition);
    } else {
      _controller.seekTo(_totalDuration);
    }
  }

  void _seekBackward() {
    final newPosition = _currentPosition - const Duration(minutes: 1);
    if (newPosition > Duration.zero) {
      _controller.seekTo(newPosition);
    } else {
      _controller.seekTo(Duration.zero);
    }
  }

  String _formatDuration(Duration duration) {
    final totalMinutes = duration.inMinutes;
    final hours = duration.inHours;
    
    if (hours > 0) {
      final remainingMinutes = totalMinutes - (hours * 60);
      return '${hours}j ${remainingMinutes}m';
    } else {
      return '${totalMinutes}m';
    }
  }

  String _formatProgressTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  double _getProgressValue() {
    if (_totalDuration.inMilliseconds == 0) return 0.0;
    final progress = _currentPosition.inMilliseconds / _totalDuration.inMilliseconds;
    return progress.clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.movieTitle,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 20),
              const Text(
                'Video tidak dapat dimuat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                _getErrorMessage(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Path: ${widget.videoUrl}',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Kembali'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _hasError = false;
                      });
                      _initializeVideo();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getErrorMessage() {
    if (_errorMessage.contains('Format error') || 
        _errorMessage.contains('MEDIA_ERR_SRC_NOT_SUPPORTED')) {
      return 'Format video tidak didukung. Pastikan video berformat MP4 dengan codec H.264.';
    } else if (_errorMessage.contains('File not found')) {
      return 'File video tidak ditemukan. Pastikan file ada di folder assets/videos/.';
    } else if (_errorMessage.contains('timeout')) {
      return 'Video terlalu lama dimuat. Coba dengan video yang lebih kecil.';
    } else {
      return 'Terjadi kesalahan saat memuat video. $_errorMessage';
    }
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.red,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Memuat "${widget.movieTitle}"...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            if (widget.isLocal) ...[
              const SizedBox(height: 8),
              const Text(
                '(Video Offline)',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),

        // Transparent tap detector covering entire screen
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              print('TAP DETECTED!');
              setState(() {
                _showControls = !_showControls;
                print('showControls is now: $_showControls');
              });
              if (_showControls && _isPlaying) {
                _autoHideControls();
              }
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),

        if (_showControls) ...[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.movieTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Durasi: ${_formatDuration(_totalDuration)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _controller.value.volume == 0 ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_controller.value.volume == 0) {
                          _controller.setVolume(1.0);
                        } else {
                          _controller.setVolume(0.0);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          Positioned.fill(
            child: Center(
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.replay,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(height: 2),
                            Text(
                              '1m',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: _seekBackward,
                    ),

                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      onPressed: _togglePlayPause,
                    ),

                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.forward,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(height: 2),
                            Text(
                              '1m',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: _seekForward,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        _formatProgressTime(_currentPosition),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                            activeTrackColor: Colors.red,
                            inactiveTrackColor: Colors.white24,
                            thumbColor: Colors.red,
                          ),
                          child: Slider(
                            value: _getProgressValue(),
                            onChangeStart: (value) {
                              setState(() {
                                _isDragging = true;
                              });
                            },
                            onChanged: (value) {
                              if (_totalDuration.inMilliseconds > 0) {
                                final newPosition = Duration(
                                  milliseconds: (value * _totalDuration.inMilliseconds).toInt(),
                                );
                                setState(() {
                                  _currentPosition = newPosition;
                                });
                              }
                            },
                            onChangeEnd: (value) {
                              if (_totalDuration.inMilliseconds > 0) {
                                final newPosition = Duration(
                                  milliseconds: (value * _totalDuration.inMilliseconds).toInt(),
                                );
                                _controller.seekTo(newPosition);
                              }
                              setState(() {
                                _isDragging = false;
                              });
                              _autoHideControls();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatProgressTime(_totalDuration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupMenuButton<double>(
                        icon: const Icon(Icons.speed, color: Colors.white, size: 22),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 0.5, child: Text('0.5x')),
                          const PopupMenuItem(value: 0.75, child: Text('0.75x')),
                          const PopupMenuItem(value: 1.0, child: Text('Normal')),
                          const PopupMenuItem(value: 1.25, child: Text('1.25x')),
                          const PopupMenuItem(value: 1.5, child: Text('1.5x')),
                          const PopupMenuItem(value: 2.0, child: Text('2.0x')),
                        ],
                        onSelected: (speed) {
                          _controller.setPlaybackSpeed(speed);
                        },
                        color: Colors.grey[900],
                      ),
                      Text(
                        '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.fullscreen, color: Colors.white, size: 22),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorScreen();
    }

    if (_isLoading) {
      return _buildLoadingScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _buildVideoPlayer(),
      ),
    );
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
}