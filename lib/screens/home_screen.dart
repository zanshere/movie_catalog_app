import 'package:flutter/material.dart';
import 'package:movie_catalog_app/data/movie_data.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/screens/detail_screen.dart';
import 'package:movie_catalog_app/screens/search_screen.dart';
import 'package:movie_catalog_app/screens/favorites_screen.dart';
import 'package:movie_catalog_app/screens/profile_screen.dart';
import 'package:movie_catalog_app/widgets/movie_card.dart';
import 'package:movie_catalog_app/widgets/movie_carousel.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Set<String> _favoriteMovies = {};

  // ---- FUNGSI FAVORIT ----
  void _toggleFavorite(String movieId) {
    setState(() {
      if (_favoriteMovies.contains(movieId)) {
        _favoriteMovies.remove(movieId);
        _showSnackBar('Removed from favorites', Icons.favorite_border);
      } else {
        _favoriteMovies.add(movieId);
        _showSnackBar('Added to favorites', Icons.favorite);
      }
    });
  }

  void _showSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ---- NAVIGASI BAWAH ----
  void _onItemTapped(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return SearchScreen(
          favoriteMovies: _favoriteMovies,
          onFavoriteToggle: _toggleFavorite,
          isDarkMode: widget.isDarkMode,
          onThemeToggle: widget.onThemeToggle,
        );
      case 2:
        return FavoritesScreen(
          favoriteMovies: _favoriteMovies,
          onFavoriteToggle: _toggleFavorite,
          isDarkMode: widget.isDarkMode,
          onThemeToggle: widget.onThemeToggle,
        );
      case 3:
        return ProfileScreen(
          isDarkMode: widget.isDarkMode,
          onThemeToggle: widget.onThemeToggle,
        );
      default:
        return _buildHomeContent();
    }
  }

  // ---- HALAMAN HOME ----
  Widget _buildHomeContent() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Discover Movies',
                  style: TextStyle(
                    color: theme.colorScheme.onBackground,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: theme.colorScheme.onBackground,
                  ),
                  onPressed: widget.onThemeToggle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Tambahkan MovieCarousel di sini
          MovieCarousel(
            movies: dummyMovies.take(5).toList(),
            onFavoriteToggle: _toggleFavorite,
            favoriteMovies: _favoriteMovies,
          ),
          const SizedBox(height: 20),
          
          _buildMovieSection("Popular Movies", dummyMovies.take(6).toList()),
          _buildMovieSection("New Releases", dummyMovies.reversed.take(6).toList()),
        ],
      ),
    );
  }

  // ---- GRID / LIST MOVIE ----
  Widget _buildMovieSection(String title, List<Movie> movies) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/movie_list',
                    arguments: {
                      'title': title, 
                      'movies': movies,
                    },
                  );
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
         SizedBox(
  height: 350,
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    itemCount: movies.length,
    separatorBuilder: (_, __) => const SizedBox(width: 12),
    itemBuilder: (context, index) {
      final movie = movies[index];
      return MovieCard(
        movie: movie,
        isFavorite: false,
        onFavoriteToggle: (_) {},
      );
    },
  ),
),
const SizedBox(height: 20), // 👉 tambahkan ini di bawah section

        ],
      ),
    );
  }

  // ---- NAVBAR ----
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  // ---- BUILD UTAMA ----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}