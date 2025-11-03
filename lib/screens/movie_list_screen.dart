import 'package:flutter/material.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/widgets/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  final String title;
  final List<Movie> movies;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const MovieListScreen({
    super.key,
    required this.title,
    required this.movies,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final Set<String> _favoriteMovies = {};

  void _toggleFavorite(String movieId) {
    setState(() {
      if (_favoriteMovies.contains(movieId)) {
        _favoriteMovies.remove(movieId);
      } else {
        _favoriteMovies.add(movieId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isTablet = screenWidth >= 600;
          final isDesktop = screenWidth >= 900;
          final isLargeDesktop = screenWidth >= 1200;
          
          final crossAxisCount = isLargeDesktop ? 5 : 
                               isDesktop ? 4 : 
                               isTablet ? 3 : 2;
          final childAspectRatio = isDesktop ? 0.7 : 0.65;
          final padding = isDesktop ? 32.0 : 16.0;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: widget.movies.length,
              itemBuilder: (context, index) {
                final movie = widget.movies[index];
                return MovieCard(
                  movie: movie,
                  isFavorite: _favoriteMovies.contains(movie.id),
                  onFavoriteToggle: (isFavorite) {
                    _toggleFavorite(movie.id);
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