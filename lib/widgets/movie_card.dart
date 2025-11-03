import 'package:flutter/material.dart';
import 'package:movie_catalog_app/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;
  final Function(bool) onFavoriteToggle;

  const MovieCard({
    super.key,
    required this.movie,
    this.isFavorite = false,
    required this.onFavoriteToggle,
  });

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
            color: Colors.grey[800],
            child: const Center(
              child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder(height: height, width: width);
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder(height: height, width: width);
        },
      );
    }
  }

  Widget _buildErrorPlaceholder({double? height, double? width}) {
    return Container(
      height: height,
      width: width,
      color: Colors.grey[800],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie, color: Colors.white54, size: 32),
          SizedBox(height: 4),
          Text('No Image', style: TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth >= 600;
        final isDesktop = screenWidth >= 900;
        final isLargeDesktop = screenWidth >= 1200;

        final imageHeight = isLargeDesktop
            ? 220.0
            : isDesktop
                ? 210.0
                : isTablet
                    ? 200.0
                    : 190.0;
        final cardWidth = isLargeDesktop
            ? 220.0
            : isDesktop
                ? 200.0
                : isTablet
                    ? 180.0
                    : 160.0;
        final titleFontSize = isLargeDesktop
            ? 16.0
            : isDesktop
                ? 15.0
                : isTablet
                    ? 14.0
                    : 13.0;
        final genreFontSize = isLargeDesktop
            ? 11.0
            : isDesktop
                ? 10.0
                : isTablet
                    ? 9.0
                    : 8.0;
        final iconSize = isLargeDesktop
            ? 22.0
            : isDesktop
                ? 20.0
                : isTablet
                    ? 18.0
                    : 16.0;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: movie);
            },
            child: Container(
              width: cardWidth,
              height: 320.0,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🎬 Poster
                  SizedBox(
                    height: imageHeight,
                    width: cardWidth,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildImage(
                            movie.posterUrl.isNotEmpty
                                ? movie.posterUrl
                                : movie.backdropUrl,
                            height: imageHeight,
                            width: cardWidth,
                          ),
                        ),
                        // ❤️ Favorite icon
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              onFavoriteToggle(!isFavorite);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(128),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.white,
                                size: iconSize,
                              ),
                            ),
                          ),
                        ),
                        // ⭐ Rating badge
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(178),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 12),
                                const SizedBox(width: 2),
                                Text(
                                  movie.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 🏷️ Title
                  SizedBox(
                    height: 40,
                    child: Text(
                      movie.title,
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color ?? Colors.white,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 🎭 Genres
                  SizedBox(
                    height: 32,
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: movie.genres.take(2).map((genre) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            genre.length > 8
                                ? '${genre.substring(0, 8)}...'
                                : genre,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: genreFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
