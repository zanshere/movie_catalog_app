import 'package:flutter/material.dart';
import 'package:movie_catalog_app/data/movie_data.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/widgets/movie_card.dart';
import 'package:movie_catalog_app/widgets/movie_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Set<String> _favoriteMovies = {};

  void _toggleFavorite(String movieId) {
    setState(() {
      if (_favoriteMovies.contains(movieId)) {
        _favoriteMovies.remove(movieId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Removed from favorites'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        _favoriteMovies.add(movieId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Added to favorites'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  List<Movie> get featuredMovies => dummyMovies.take(3).toList();
  List<Movie> get newMovies => dummyMovies;
  List<Movie> get popularMovies => List.from(dummyMovies)..sort((a, b) => b.rating.compareTo(a.rating));

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'MovieStream',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          final horizontalPadding = isWide ? (constraints.maxWidth * 0.1) : 16.0;
          
          return _buildBody(theme, horizontalPadding);
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody(ThemeData theme, double horizontalPadding) {
    if (_currentIndex != 0) {
      return _buildPlaceholderScreen();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildFeaturedSection(theme),
            const SizedBox(height: 30),
            _buildMovieSection('New Movies', newMovies, theme),
            const SizedBox(height: 30),
            _buildMovieSection('Popular Movies', popularMovies, theme),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured Movies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        MovieCarousel(
          movies: featuredMovies,
          onFavoriteToggle: _toggleFavorite,
          favoriteMovies: _favoriteMovies,
        ),
      ],
    );
  }

  Widget _buildMovieSection(String title, List<Movie> movies, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/movie_list',
                  arguments: {
                    'title': title,
                    'movies': movies,
                  },
                );
              },
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 320, // Fixed height untuk konsistensi dengan MovieCard
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                isFavorite: _favoriteMovies.contains(movie.id),
                onFavoriteToggle: (isFavorite) {
                  _toggleFavorite(movie.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getPlaceholderIcon(),
            size: 64,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          Text(
            _getPlaceholderText(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getPlaceholderSubtext(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentIndex = 0;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  IconData _getPlaceholderIcon() {
    switch (_currentIndex) {
      case 1: return Icons.search;
      case 2: return Icons.favorite;
      case 3: return Icons.person;
      default: return Icons.home;
    }
  }

  String _getPlaceholderText() {
    switch (_currentIndex) {
      case 1: return 'Search';
      case 2: return 'Favorites';
      case 3: return 'Profile';
      default: return 'Home';
    }
  }

  String _getPlaceholderSubtext() {
    switch (_currentIndex) {
      case 1: return 'Search for your favorite movies';
      case 2: return '${_favoriteMovies.length} movies in favorites';
      case 3: return 'Manage your profile and settings';
      default: return 'Browse featured movies';
    }
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      backgroundColor: const Color(0xFF1A1A2E),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}