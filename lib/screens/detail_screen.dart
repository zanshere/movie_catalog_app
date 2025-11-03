import 'package:flutter/material.dart';
import 'package:movie_catalog_app/models/movie.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Widget _buildImage(String imageUrl, {double? height, double? width, BoxFit? fit}) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            width: width,
            color: Colors.grey.withAlpha(25),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            _placeholderPoster(height: height, width: width),
      );
    } else {
      return Image.asset(
        imageUrl,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _placeholderPoster(height: height, width: width),
      );
    }
  }

  Widget _placeholderPoster({double? height, double? width}) {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.withAlpha(51),
      child: const Center(
        child: Icon(Icons.movie, size: 64, color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          widget.movie.title,
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : theme.colorScheme.onBackground,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
        centerTitle: true,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(
                widget.movie.backdropUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Judul dan rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.movie.title,
                  style: TextStyle(
                    color: theme.colorScheme.onBackground,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      widget.movie.rating.toStringAsFixed(1),
                      style: TextStyle(color: theme.colorScheme.onBackground),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            Text(
              '${widget.movie.releaseYear}',
              style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.7)),
            ),

            const SizedBox(height: 20),
            Text(
              "Overview",
              style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.movie.description,
              style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.7), height: 1.5),
            ),

            const SizedBox(height: 20),
            Text(
              "Genres",
              style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.movie.genres.map((genre) {
                return Chip(
                  label: Text(genre),
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  labelStyle: const TextStyle(color: Colors.blue),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            Text(
              "Cast",
              style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.movie.cast.length,
                itemBuilder: (context, index) {
                  final actor = widget.movie.cast[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: theme.colorScheme.onBackground.withOpacity(0.1),
                          child: Icon(Icons.person, color: theme.colorScheme.onBackground.withOpacity(0.5)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          actor,
                          style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: theme.dialogBackgroundColor,
                      title: Text('Watch Movie', style: TextStyle(color: theme.colorScheme.onBackground)),
                      content: Text(
                        'Enjoy watching "${widget.movie.title}"!',
                        style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.7)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Close', style: TextStyle(color: theme.colorScheme.primary)),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Watch Now",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}