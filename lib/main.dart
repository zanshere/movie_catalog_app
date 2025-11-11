import 'package:flutter/material.dart';
import 'package:movie_catalog_app/screens/home_screen.dart';
import 'package:movie_catalog_app/screens/detail_screen.dart';
import 'package:movie_catalog_app/screens/movie_list_screen.dart';
import 'package:movie_catalog_app/screens/video_player_screen.dart';
import 'package:movie_catalog_app/models/movie.dart'; // Import Movie model



void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Catalog App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(
          isDarkMode: _themeMode == ThemeMode.dark,
          onThemeToggle: _toggleTheme,
        ),
        '/detail': (context) {
          final movie = ModalRoute.of(context)!.settings.arguments as Movie;
          return DetailScreen(movie: movie);
        },
        '/movie_list': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return MovieListScreen(
            title: args['title'],
            movies: args['movies'],
            isDarkMode: _themeMode == ThemeMode.dark,
            onThemeToggle: _toggleTheme,
          );
        },
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/video') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              videoUrl: args['videoUrl'],
              movieTitle: args['movieTitle'],
            ),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}