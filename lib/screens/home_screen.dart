import 'package:flutter/material.dart';
import 'package:movie_catalog_app/data/movie_data.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/widgets/movie_card.dart';
import 'package:movie_catalog_app/screens/search_screen.dart';
import 'package:movie_catalog_app/screens/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Set<String> _favoriteMovies = {};
  int _currentCarouselIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

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
          ),
        );
      }
    });
  }

  List<Movie> get featuredMovies => dummyMovies.take(3).toList();
  List<Movie> get newMovies => dummyMovies;
  List<Movie> get popularMovies => List.from(dummyMovies)..sort((a, b) => b.rating.compareTo(a.rating));

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_pageController.hasClients && mounted) {
        final nextPage = (_currentCarouselIndex + 1) % featuredMovies.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startAutoPlay();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildNetworkImage(String imageUrl, {double? height, double? width, BoxFit? fit}) {
    return Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[800],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
              color: Colors.blue,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[800],
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.movie,
                color: Colors.white54,
                size: 40,
              ),
              SizedBox(height: 8),
              Text(
                'No Image',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Handle navigation for different tabs
    if (index == 1) {
      // Search Screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      );
    } else if (index == 2) {
      // Favorites Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoritesScreen(
            favoriteMovies: _favoriteMovies,
            onFavoriteToggle: _toggleFavorite,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'MovieStream',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.appBarTheme.foregroundColor ?? Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Theme Toggle Button
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: theme.appBarTheme.foregroundColor ?? Colors.white,
              size: 24,
            ),
            onPressed: widget.onThemeToggle,
          ),
          // Search Button
          IconButton(
            icon: Icon(
              Icons.search,
              color: theme.appBarTheme.foregroundColor ?? Colors.white,
              size: 28,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(theme),
      bottomNavigationBar: _buildBottomNavigationBar(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    // If not on home tab, show placeholder
    if (_currentIndex != 0) {
      return _buildPlaceholderScreen(theme);
    }

    // Home screen content
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 🎞️ Featured Movies Carousel
            _buildFeaturedSection(theme),

            const SizedBox(height: 30),

            // 🆕 New Movies Section
            _buildMovieSection('New Movies', newMovies, theme),

            const SizedBox(height: 30),

            // 🔥 Popular Movies Section
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
        Text(
          'Featured Movies',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.textTheme.bodyLarge?.color ?? Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
            itemCount: featuredMovies.length,
            itemBuilder: (context, index) {
              final movie = featuredMovies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: movie,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        _buildNetworkImage(
                          movie.backdropUrl,
                          height: 200,
                          width: double.infinity,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              _toggleFavorite(movie.id);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _favoriteMovies.contains(movie.id) 
                                    ? Icons.favorite 
                                    : Icons.favorite_border,
                                color: _favoriteMovies.contains(movie.id) 
                                    ? Colors.red 
                                    : Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    movie.rating.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${movie.releaseYear}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: featuredMovies.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  entry.key,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentCarouselIndex == entry.key
                      ? Colors.blue
                      : Colors.white.withOpacity(0.4),
                ),
              ),
            );
          }).toList(),
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
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.bodyLarge?.color ?? Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showSeeAllDialog(title, movies, theme);
              },
              child: Text(
                'See all',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 320,
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

  Widget _buildPlaceholderScreen(ThemeData theme) {
    String title = 'Home';
    String subtitle = 'Browse featured movies';
    IconData icon = Icons.home;

    switch (_currentIndex) {
      case 1:
        title = 'Search';
        subtitle = 'Search functionality available';
        icon = Icons.search;
        break;
      case 2:
        title = 'Favorites';
        subtitle = '${_favoriteMovies.length} movies in favorites';
        icon = Icons.favorite;
        break;
      case 3:
        title = 'Profile';
        subtitle = 'Profile screen coming soon';
        icon = Icons.person;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
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
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  void _showSeeAllDialog(String title, List<Movie> movies, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor ?? const Color(0xFF1A1A2E),
        title: Text(
          title,
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color ?? Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.posterUrl,
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 70,
                        color: Colors.grey[800],
                        child: Icon(Icons.movie, color: Colors.white54),
                      );
                    },
                  ),
                ),
                title: Text(
                  movie.title,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color ?? Colors.white),
                ),
                subtitle: Text(
                  '⭐ ${movie.rating} • ${movie.releaseYear}',
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color ?? Colors.white70),
                ),
                trailing: IconButton(
                  icon: Icon(
                    _favoriteMovies.contains(movie.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _favoriteMovies.contains(movie.id)
                        ? Colors.red
                        : theme.textTheme.bodyLarge?.color ?? Colors.white,
                  ),
                  onPressed: () {
                    _toggleFavorite(movie.id);
                  },
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: movie,
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(ThemeData theme) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}