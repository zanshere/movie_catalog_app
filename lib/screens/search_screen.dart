import 'package:flutter/material.dart';
import 'package:movie_catalog_app/data/movie_data.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  final Set<String> favoriteMovies;
  final Function(String) onFavoriteToggle;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const SearchScreen({
    super.key,
    required this.favoriteMovies,
    required this.onFavoriteToggle,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Movie> _searchResults = [];
  String _query = '';
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _query = query.trim();
      _isSearching = _query.isNotEmpty;
      _searchResults = _query.isEmpty
          ? []
          : dummyMovies.where((movie) {
              final q = _query.toLowerCase();
              return movie.title.toLowerCase().contains(q) ||
                  movie.description.toLowerCase().contains(q) ||
                  movie.genres.any((g) => g.toLowerCase().contains(q));
            }).toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _query = '';
      _isSearching = false;
      _searchResults.clear();
    });
    _searchFocusNode.requestFocus();
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text(
            'Search',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _performSearch,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search movies...',
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                border: InputBorder.none,
              ),
              cursorColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (_query.isNotEmpty)
            GestureDetector(
              onTap: _clearSearch,
              child: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'Find Movies',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Search for your favorite movies by title or genre',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different keyword.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    final crossAxisCount = isTablet ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final movie = _searchResults[index];
        return MovieCard(
          movie: movie,
          isFavorite: widget.favoriteMovies.contains(movie.id),
          onFavoriteToggle: (isFav) => widget.onFavoriteToggle(movie.id),
        );
      },
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
            _buildSearchField(),
            const SizedBox(height: 8),
            Expanded(
              child: !_isSearching
                  ? _buildEmptyState()
                  : _searchResults.isEmpty
                      ? _buildNoResults()
                      : _buildResults(),
            ),
          ],
        ),
      ),
    );
  }
}