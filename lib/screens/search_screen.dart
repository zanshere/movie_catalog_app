import 'package:flutter/material.dart';
import 'package:movie_catalog_app/services/movie_service.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MovieService _movieService = MovieService();
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favoriteMovies = {};
  List<Movie> _searchResults = [];
  bool _isSearching = false;

  void _toggleFavorite(String movieId) {
    setState(() {
      if (_favoriteMovies.contains(movieId)) {
        _favoriteMovies.remove(movieId);
      } else {
        _favoriteMovies.add(movieId);
      }
    });
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _movieService.searchMovies(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final crossAxisCount = isTablet ? 3 : 2;
    final childAspectRatio = isTablet ? 0.7 : 0.65;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark 
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _performSearch,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            decoration: InputDecoration(
              hintText: 'Search movies...',
              hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: theme.textTheme.bodyMedium?.color),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.appBarTheme.foregroundColor ?? Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isSearching
          ? _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: theme.textTheme.bodyMedium?.color ?? Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No movies found',
                        style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try different keywords',
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = _searchResults[index];
                      return MovieCard(
                        movie: movie,
                        isFavorite: _favoriteMovies.contains(movie.id),
                        onFavoriteToggle: (isFavorite) {
                          _toggleFavorite(movie.id);
                        },
                      );
                    },
                  ),
                )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 64,
                    color: theme.textTheme.bodyMedium?.color ?? Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Search for movies',
                    style: TextStyle(
                      color: theme.textTheme.bodyLarge?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Type in the search bar to find your favorite movies',
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}