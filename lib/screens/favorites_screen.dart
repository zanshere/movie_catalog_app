import 'package:flutter/material.dart';
import 'package:movie_catalog_app/data/movie_data.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/widgets/movie_card.dart';

class FavoritesScreen extends StatefulWidget {
  final Set<String> favoriteMovies;
  final Function(String) onFavoriteToggle;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const FavoritesScreen({
    super.key,
    required this.favoriteMovies,
    required this.onFavoriteToggle,
    required this.isDarkMode,
    required this.onThemeToggle,
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Favorites',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (favoriteMovies.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${favoriteMovies.length}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1)),
              ),
              child: Icon(
                Icons.movie_creation_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Favorites Yet',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Movies you add to favorites will appear here',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                fontSize: 15,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: const Text(
                'Browse Movies',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
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
    final childAspectRatio = isDesktop ? 0.7 : 0.68;
    final padding = isDesktop ? 32.0 : 16.0;

    return Padding(
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
            isFavorite: true,
            onFavoriteToggle: (isFavorite) {
              widget.onFavoriteToggle(movie.id);
              setState(() {});
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 8),
            Expanded(
              child: favoriteMovies.isEmpty
                  ? _buildEmptyState()
                  : _buildFavoritesGrid(),
            ),
          ],
        ),
      ),
    );
  }
}