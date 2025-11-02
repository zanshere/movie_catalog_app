// favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:movie_catalog_app/data/movie_data.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/widgets/movie_card.dart';

class FavoritesScreen extends StatefulWidget {
  final Set<String> favoriteMovies;
  final Function(String) onFavoriteToggle;

  const FavoritesScreen({
    super.key,
    required this.favoriteMovies,
    required this.onFavoriteToggle,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Movie> get favoriteMovies {
    return dummyMovies
        .where((movie) => widget.favoriteMovies.contains(movie.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isTablet = screenWidth >= 600;
          final isDesktop = screenWidth >= 900;
          final isLargeDesktop = screenWidth >= 1200;

          final crossAxisCount = isLargeDesktop
              ? 5
              : isDesktop
                  ? 4
                  : isTablet
                      ? 3
                      : 2;
          final childAspectRatio = isDesktop ? 0.7 : 0.65;
          final padding = isDesktop ? 32.0 : 16.0;

          return favoriteMovies.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap the heart icon to add movies to favorites',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(padding),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: favoriteMovies.length,
                    itemBuilder: (context, index) {
                      final movie = favoriteMovies[index];
                      return MovieCard(
                        movie: movie,
                        isFavorite: widget.favoriteMovies.contains(movie.id),
                        onFavoriteToggle: (isFavorite) {
                          widget.onFavoriteToggle(movie.id);
                        },
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
