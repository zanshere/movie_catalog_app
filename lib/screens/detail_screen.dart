import 'package:flutter/material.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/screens/video_player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_catalog_app/data/movie_data.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;

  // Mapping video yang berbeda untuk movie dan trailer
  final Map<String, Map<String, String>> _movieVideos = {
    'The Matrix Resurrections': {
      'movie': 'assets/videos/The Matrix Resurrections.mp4',
      'trailer': 'assets/videos/The Matrix Resurrections.mp4',
    },
    'Spider-Man: No Way Home': {
      'movie': 'assets/videos/SPIDER-MAN_ NO WAY HOME.mp4',
      'trailer': 'assets/videos/SPIDER-MAN_ NO WAY HOME.mp4',
    },
    'Dune': {
      'movie': 'assets/videos/Dune Official Trailer.mp4',
      'trailer': 'assets/videos/Dune Official Trailer.mp4',
    },
    'The Batman': {
      'movie': 'assets/videos/THE BATMAN.mp4',
      'trailer': 'assets/videos/THE BATMAN.mp4',
    },
    'Avatar: The Way of Water': {
      'movie': 'assets/videos/Avatar_ The Way of Water _ Official Trailer.mp4',
      'trailer': 'assets/videos/Avatar_ The Way of Water _ Official Trailer.mp4',
    },
    'Black Panther: Wakanda Forever': {
      'movie': 'assets/videos/Marvel Studios’ Black Panther_ Wakanda Forever _ Official Trailer.mp4',
      'trailer': 'assets/videos/Marvel Studios’ Black Panther_ Wakanda Forever _ Official Trailer.mp4',
    },
    'Top Gun: Maverick': {
      'movie': 'assets/videos/Top Gun_ Maverick - Official Trailer (2022).mp4',
      'trailer': 'assets/videos/Top Gun_ Maverick - Official Trailer (2022).mp4',
    },
    'John Wick: Chapter 4': {
      'movie': 'assets/videos/John Wick_ Chapter 4 (2023 Movie) Official Trailer – Keanu Reeves, Donnie Yen, Bill Skarsgård.mp4',
      'trailer': 'assets/videos/John Wick_ Chapter 4 (2023 Movie) Official Trailer – Keanu Reeves, Donnie Yen, Bill Skarsgård.mp4',
    },
    '1 Kakak 7 Ponakan': {
      'movie': 'assets/videos/1 Kakak 7 Ponakan - Official Trailer.mp4',
      'trailer': 'assets/videos/1 Kakak 7 Ponakan - Official Trailer.mp4',
    },
    'Agak Laen': {
      'movie': 'assets/videos/AGAK LAEN Official Trailer.mp4',
      'trailer': 'assets/videos/AGAK LAEN Official Trailer.mp4',
    },
    'Cek Toko Sebelah': {
      'movie': 'assets/videos/cektoko_movie.mp4',
      'trailer': 'assets/videos/cektoko_trailer.mp4',
    },
    'Cek Toko Sebelah 2': {
      'movie': 'assets/videos/CEK TOKO SEBELAH Official Trailer.mp4',
      'trailer': 'assets/videos/CEK TOKO SEBELAH Official Trailer.mp4',
    },
    'Deadpool & Wolverine': {
      'movie': 'assets/videos/Deadpool & Wolverine _ Official Trailer _ In Theaters July 26.mp4',
      'trailer': 'assets/videos/Deadpool & Wolverine _ Official Trailer _ In Theaters July 26.mp4',
    },
    'Freses': {
      'movie': 'assets/videos/FRÈRES Bande Annonce (2024).mp4',
      'trailer': 'assets/videos/FRÈRES Bande Annonce (2024).mp4',
    },
    'Guru Guru Gokil': {
      'movie': 'assets/videos/Guru-Guru Gokil _ Trailer Resmi _ Netflix.mp4',
      'trailer': 'assets/videos/Guru-Guru Gokil _ Trailer Resmi _ Netflix.mp4',
    },
    'Jatuh Cinta Seperti Di Film-Film': {
      'movie': 'assets/videos/Jatuh Cinta Seperti Di Film-FIlm.mp4',
      'trailer': 'assets/videos/Jatuh Cinta Seperti Di Film-FIlm.mp4',
    },
    'Minecraft: The Movie': {
      'movie': 'assets/videos/A Minecraft Movie  Final Trailer.mp4',
      'trailer': 'assets/videos/A Minecraft Movie  Final Trailer.mp4',
    },
    'Pasutri Gaje': {
      'movie': 'assets/videos/Official Trailer Pasutri Gaje  7 Februari 2024 di Bioskop.mp4',
      'trailer': 'assets/videos/pasutri_trailer.mp4',
    },
    'Perayaan Mati Rasa': {
      'movie': 'assets/videos/Perayaan Mati Rasa  Official Trailer ).mp4',
      'trailer': 'assets/videos/Perayaan Mati Rasa  Official Trailer ).mp4',
    },
    'Sekawan Limo': {
      'movie': 'assets/videos/SEKAWAN LIMO - Official Trailer 4K - StarvisionPlus (720p, h264).mp4',
      'trailer': 'assets/videos/SEKAWAN LIMO - Official Trailer 4K - StarvisionPlus (720p, h264).mp4',
    },
    'Smile': {
      'movie': 'assets/videos/Smile  Official Trailer (2022 Movie) - Paramount Pictures (720p, h264).mp4',
      'trailer': 'assets/videos/Smile  Official Trailer (2022 Movie) - Paramount Pictures (720p, h264).mp4',
    },
    'Sore': {
      'movie': 'assets/videos/TRAILER - FILM SORE KARYA YANDY LAURENS  TAYANG 10 JULI 2025 DI BIOSKOP - Cerita Films (1080p, h264).mp4',
      'trailer': 'assets/videos/TRAILER - FILM SORE KARYA YANDY LAURENS  TAYANG 10 JULI 2025 DI BIOSKOP - Cerita Films (1080p, h264).mp4',
    },
    'Waktu Maghrib': {
      'movie': 'assets/videos/Official Trailer WAKTU MAGHRIB  Tayang di XXI mulai 9 Februari 2023 - CINEMA 21 (720p, h264).mp4',
      'trailer': 'assets/videos/Official Trailer WAKTU MAGHRIB  Tayang di XXI mulai 9 Februari 2023 - CINEMA 21 (720p, h264).mp4',
    },
  };

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  String _getMoviePath() {
    return _movieVideos[widget.movie.title]?['movie'] ?? 'assets/videos/sample_movie.mp4';
  }

  String _getTrailerPath() {
    return _movieVideos[widget.movie.title]?['trailer'] ?? 'assets/videos/sample_trailer.mp4';
  }

  bool get hasVideo {
    return _movieVideos.containsKey(widget.movie.title);
  }

  void _watchMovie() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoUrl: _getMoviePath(),
          movieTitle: widget.movie.title,
        ),
      ),
    );
  }

  void _watchTrailer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoUrl: _getTrailerPath(),
          movieTitle: '${widget.movie.title} - Trailer',
        ),
      ),
    );
  }

  List<Movie> _getSimilarMovies() {
    final currentMovie = widget.movie;
    final similarMovies = dummyMovies.where((movie) {
      if (movie.id == currentMovie.id) return false;
      final commonGenres = movie.genres.where((genre) => currentMovie.genres.contains(genre));
      return commonGenres.isNotEmpty;
    }).toList();

    return similarMovies.isNotEmpty ? similarMovies.take(5).toList() : dummyMovies.where((movie) => movie.id != currentMovie.id).take(5).toList();
  }

  Widget _buildImage(String imageUrl, {double? height, double? width, BoxFit? fit}) {
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => Container(
          height: height,
          width: width,
          color: Colors.grey[800],
          child: const Center(
            child: CircularProgressIndicator(color: Colors.red),
          ),
        ),
        errorWidget: (context, url, error) => _buildPlaceholderPoster(height: height, width: width),
      );
    } else {
      return Image.asset(
        imageUrl,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildPlaceholderPoster(height: height, width: width),
      );
    }
  }

  Widget _buildPlaceholderPoster({double? height, double? width}) {
    return Container(
      height: height,
      width: width,
      color: Colors.grey[800],
      child: const Center(
        child: Icon(Icons.movie, size: 40, color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final similarMovies = _getSimilarMovies();

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(
                    widget.movie.backdropUrl.isNotEmpty ? widget.movie.backdropUrl : widget.movie.posterUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.movie.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${widget.movie.releaseYear}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.movie.duration,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ACTION BUTTONS - IMPROVED DESIGN
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Play Button - Enhanced
                        _buildActionButton(
                          icon: Icons.play_arrow_rounded,
                          label: "Play Movie",
                          color: const Color(0xFFE50914),
                          onPressed: _watchMovie,
                          isPrimary: true,
                        ),

                        // Download Button - Enhanced
                        _buildActionButton(
                          icon: Icons.download_rounded,
                          label: "Download",
                          color: Colors.transparent,
                          onPressed: () {
                            // Add download functionality here
                          },
                        ),

                        // Trailer Button - Enhanced
                        _buildActionButton(
                          icon: Icons.play_circle_fill_rounded,
                          label: "Trailer",
                          color: Colors.transparent,
                          onPressed: _watchTrailer,
                        ),

                        // Favorite Button - Enhanced
                        _buildActionButton(
                          icon: _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          label: _isFavorite ? "Liked" : "Like",
                          color: Colors.transparent,
                          onPressed: _toggleFavorite,
                          isFavorite: _isFavorite,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // GENRES
                  Wrap(
                    spacing: 8,
                    children: widget.movie.genres.map((genre) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.shade600,
                              Colors.orange.shade600,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          genre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // OVERVIEW
                  const Text(
                    "Overview",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // CAST
                  const Text(
                    "Cast",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.movie.cast.length,
                      itemBuilder: (context, index) {
                        final actor = widget.movie.cast[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.shade400,
                                      Colors.orange.shade400,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  actor,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // MORE LIKE THIS SECTION
                  const Text(
                    "More Like This",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  if (similarMovies.isNotEmpty) ...[
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: similarMovies.length,
                        itemBuilder: (context, index) {
                          final similarMovie = similarMovies[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate to similar movie detail
                            },
                            child: Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: _buildImage(
                                        similarMovie.posterUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    similarMovie.title,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "No similar movies found",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk membuat action button yang konsisten
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isPrimary = false,
    bool isFavorite = false,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            gradient: isPrimary
                ? LinearGradient(
                    colors: [
                      const Color(0xFFE50914),
                      Colors.red.shade600,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : isFavorite && _isFavorite
                    ? LinearGradient(
                        colors: [
                          Colors.red.shade400,
                          Colors.pink.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
            borderRadius: BorderRadius.circular(25),
            border: isPrimary
                ? null
                : Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFFE50914).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: Colors.white,
              size: isPrimary ? 24 : 20,
            ),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}