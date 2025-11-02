import 'package:flutter/material.dart';
import 'package:movie_catalog_app/screens/home_screen.dart';
import 'package:movie_catalog_app/screens/detail_screen.dart';
import 'package:movie_catalog_app/screens/search_screen.dart';
import 'package:movie_catalog_app/screens/favorites_screen.dart';
import 'package:movie_catalog_app/screens/profile_screen.dart';
import 'package:movie_catalog_app/models/movie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Streaming App',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
      routes: {
        '/detail': (context) {
          final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
          return DetailScreen(movie: movie);
        },
        '/search': (context) => const SearchScreen(),
        '/favorites': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return FavoritesScreen(
            favoriteMovies: args['favoriteMovies'],
            onFavoriteToggle: args['onFavoriteToggle'],
          );
        },
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }

  final ThemeData _darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F0F1E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F0F1E),
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1A1A2E),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),
  );

  final ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),
  );
}