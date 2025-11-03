// search_screen.dart
import 'package:flutter/material.dart';
import 'package:movie_catalog_app/services/movie_service.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  final Set<String> favoriteMovies;
  final Function(String) onFavoriteToggle;

  const SearchScreen({
    super.key,
    required this.favoriteMovies,
    required this.onFavoriteToggle,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MovieService _movieService = MovieService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Movie> _searchResults = [];
  List<Movie> _allMovies = [];
  bool _isSearching = false;
  String _currentQuery = '';
  String _selectedGenre = 'All';
  final List<String> _allGenres = ['All'];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
    _initializeData();
  }

  void _initializeData() {
    _allMovies = _movieService.getAllMovies();
    
    final genreSet = <String>{};
    for (var movie in _allMovies) {
      genreSet.addAll(movie.genres);
    }
    
    setState(() {
      _allGenres.addAll(genreSet.toList()..sort());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _currentQuery = query;
      _isSearching = query.isNotEmpty || _selectedGenre != 'All';
      _searchResults = _getFilteredMovies();
    });
  }

  void _onGenreSelected(String genre) {
    setState(() {
      _selectedGenre = genre;
      _isSearching = _currentQuery.isNotEmpty || _selectedGenre != 'All';
      _searchResults = _getFilteredMovies();
    });
  }

  List<Movie> _getFilteredMovies() {
    List<Movie> results = _allMovies;

    if (_currentQuery.isNotEmpty) {
      results = results.where((movie) =>
        movie.title.toLowerCase().contains(_currentQuery.toLowerCase()) ||
        movie.genres.any((genre) => genre.toLowerCase().contains(_currentQuery.toLowerCase()))
      ).toList();
    }

    if (_selectedGenre != 'All') {
      results = results.where((movie) =>
        movie.genres.contains(_selectedGenre)
      ).toList();
    }

    return results;
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentQuery = '';
      _selectedGenre = 'All';
      _isSearching = false;
      _searchResults = [];
    });
    _searchFocusNode.requestFocus();
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_rounded, size: 18, color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            'Search',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.5), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _performSearch,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Search movies...',
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              cursorColor: Colors.white,
            ),
          ),
          if (_currentQuery.isNotEmpty)
            GestureDetector(
              onTap: _clearSearch,
              child: Icon(Icons.clear_rounded, color: Colors.white.withOpacity(0.5), size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildGenreChips() {
    if (!_isSearching) return const SizedBox();

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _allGenres.length,
        itemBuilder: (context, index) {
          final genre = _allGenres[index];
          final isSelected = _selectedGenre == genre;
          
          return Container(
            margin: EdgeInsets.only(right: 8, left: index == 0 ? 0 : 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _onGenreSelected(genre),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    genre,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveFilters() {
    if ((_currentQuery.isEmpty && _selectedGenre == 'All') || !_isSearching) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          if (_currentQuery.isNotEmpty)
            _buildFilterTag('"$_currentQuery"'),
          if (_selectedGenre != 'All')
            _buildFilterTag(_selectedGenre),
          const Spacer(),
          if (_currentQuery.isNotEmpty || _selectedGenre != 'All')
            GestureDetector(
              onTap: _clearSearch,
              child: Text(
                'Clear',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterTag(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Find Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Search for your favorite movies by title or genre',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: Colors.white.withOpacity(0.4),
          ),
          const SizedBox(height: 20),
          Text(
            'No results found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getNoResultsMessage(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: _clearSearch,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withOpacity(0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Clear Search'),
          ),
        ],
      ),
    );
  }

 String _getNoResultsMessage() {
  if (_currentQuery.isNotEmpty && _selectedGenre != 'All') {
    return 'No movies found for "$_currentQuery" in $_selectedGenre'; // ✅ FIXED: $_selectedGenre
  } else if (_currentQuery.isNotEmpty) {
    return 'No movies found for "$_currentQuery"';
  } else if (_selectedGenre != 'All') {
    return 'No movies found in $_selectedGenre'; // ✅ FIXED: $_selectedGenre
  }
  return 'Try different keywords';
}

  Widget _buildSearchResults() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final crossAxisCount = isTablet ? 3 : 2;
    final childAspectRatio = isTablet ? 0.72 : 0.68;

    return Column(
      children: [
        // Results Header - Minimal
        if (_searchResults.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${_searchResults.length} ${_searchResults.length == 1 ? 'result' : 'results'}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

        // Results Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _searchResults.isEmpty
                ? _buildNoResultsState()
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = _searchResults[index];
                      return MovieCard(
                        movie: movie,
                        isFavorite: widget.favoriteMovies.contains(movie.id),
                        onFavoriteToggle: (isFavorite) {
                          widget.onFavoriteToggle(movie.id);
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularSearches() {
    if (_isSearching) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPopularChip('Action'),
              _buildPopularChip('Fantasy'),
              _buildPopularChip('Adventure'),
              _buildPopularChip('2022'),
              _buildPopularChip('Marvel'),
              _buildPopularChip('DC'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularChip(String term) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _searchController.text = term;
          _performSearch(term);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Text(
            term,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: Column(
        children: [
          _buildAppBar(),
          _buildSearchField(),
          _buildGenreChips(),
          _buildActiveFilters(),
          _buildPopularSearches(),
          const SizedBox(height: 16),
          Expanded(
            child: _isSearching
                ? _buildSearchResults()
                : _buildEmptyState(),
          ),
        ],
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _performSearch,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Search movies...',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.white54),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
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
          
          final crossAxisCount = isLargeDesktop ? 5 : 
                               isDesktop ? 4 : 
                               isTablet ? 3 : 2;
          final childAspectRatio = isDesktop ? 0.7 : 0.65;
          final padding = isDesktop ? 32.0 : 16.0;

          return _isSearching
              ? _searchResults.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No movies found',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try different keywords',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
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
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Search for movies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Type in the search bar to find your favorite movies',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}