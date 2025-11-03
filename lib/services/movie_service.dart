import 'package:movie_catalog_app/data/movie_data.dart';
import 'package:movie_catalog_app/models/movie.dart';

class MovieService {
  
  // Get all movies
  List<Movie> getAllMovies() {
    return dummyMovies;
  }

  // Get featured movies for carousel
  List<Movie> getFeaturedMovies() {
    return dummyMovies.take(3).toList();
  }

  // Get new movies
  List<Movie> getNewMovies() {
    return dummyMovies;
  }

  // Get popular movies (sorted by rating)
  List<Movie> getPopularMovies() {
    return List.from(dummyMovies)..sort((a, b) => b.rating.compareTo(a.rating));
  }

  // Search movies - ENHANCED!
  List<Movie> searchMovies(String query) {
    return dummyMovies.where((movie) => 
      movie.title.toLowerCase().contains(query.toLowerCase()) ||
      movie.genres.any((genre) => genre.toLowerCase().contains(query.toLowerCase()))
    ).toList();
  }

  // Get movies by genre
  List<Movie> getMoviesByGenre(String genre) {
    if (genre == 'All') return dummyMovies;
    return dummyMovies.where((movie) => movie.genres.contains(genre)).toList();
  }

  // Get all available genres
  List<String> getAllGenres() {
    final genreSet = <String>{};
    for (var movie in dummyMovies) {
      genreSet.addAll(movie.genres);
    }
    return genreSet.toList()..sort();
  }

  // Get movie by ID
  Movie? getMovieById(String id) {
    try {
      return dummyMovies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get favorites
  List<Movie> getFavoriteMovies(Set<String> favoriteIds) {
    return dummyMovies.where((movie) => favoriteIds.contains(movie.id)).toList();
  }

  // Combined search with genre filter
  List<Movie> searchMoviesWithFilters(String query, String genre) {
    List<Movie> results = dummyMovies;

    // Filter by search query
    if (query.isNotEmpty) {
      results = results.where((movie) => 
        movie.title.toLowerCase().contains(query.toLowerCase()) ||
        movie.genres.any((g) => g.toLowerCase().contains(query.toLowerCase()))
      ).toList();
    }

    // Filter by genre
    if (genre != 'All') {
      results = results.where((movie) => movie.genres.contains(genre)).toList();
    }

    return results;
  }
}