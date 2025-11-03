import 'package:flutter/material.dart';
import 'package:movie_catalog_app/screens/home_screen.dart';
import 'package:movie_catalog_app/screens/detail_screen.dart';
import 'package:movie_catalog_app/screens/search_screen.dart';
import 'package:movie_catalog_app/screens/favorites_screen.dart';
import 'package:movie_catalog_app/screens/profile_screen.dart';
import 'package:movie_catalog_app/screens/movie_list_screen.dart';
import 'package:movie_catalog_app/models/movie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Streaming App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0F0F1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0F1E),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/detail': (context) {
          final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
          return DetailScreen(movie: movie);
        },
        '/search': (context) => const SearchScreen(),
        '/favorites': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return FavoritesScreen(
            favoriteMovies: args?['favoriteMovies'] ?? <String>{},
            onFavoriteToggle: args?['onFavoriteToggle'] ?? (String id) {},
          );
        },
        '/profile': (context) => const ProfileScreen(),
        '/movie_list': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return MovieListScreen(
            title: args['title'],
            movies: args['movies'],
          );
        },
      },
    );
  }
}