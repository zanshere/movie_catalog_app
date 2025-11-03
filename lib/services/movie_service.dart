import 'package:movie_catalog_app/data/movie_data.dart';
import 'package:movie_catalog_app/models/movie.dart';

class MovieService {
  // Cari film berdasarkan query
  List<Movie> searchMovies(String query) {
    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();
    return dummyMovies.where((movie) {
      return movie.title.toLowerCase().contains(lowercaseQuery) ||
          movie.genres.any((genre) => genre.toLowerCase().contains(lowercaseQuery)) ||
          movie.cast.any((actor) => actor.toLowerCase().contains(lowercaseQuery)) ||
          movie.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Ambil film berdasarkan genre
  List<Movie> getMoviesByGenre(String genre) {
    if (genre == 'All') return dummyMovies;
    return dummyMovies.where((movie) => movie.genres.contains(genre)).toList();
  }

  // Ambil semua genre unik
  List<String> getAllGenres() {
    final genreSet = <String>{};
    for (var movie in dummyMovies) {
      genreSet.addAll(movie.genres);
    }
    return genreSet.toList()..sort();
  }

  // Ambil film populer (berdasarkan rating)
  List<Movie> getPopularMovies() {
    return List.from(dummyMovies)..sort((a, b) => b.rating.compareTo(a.rating));
  }

  // Ambil film baru (berdasarkan tahun rilis)
  List<Movie> getNewMovies() {
    return List.from(dummyMovies)..sort((a, b) => b.releaseYear.compareTo(a.releaseYear));
  }

  // Ambil film favorit berdasarkan ID
  List<Movie> getFavoriteMovies(Set<String> favoriteIds) {
    return dummyMovies.where((movie) => favoriteIds.contains(movie.id)).toList();
  }

  // Ambil satu film berdasarkan ID
  Movie? getMovieById(String id) {
    try {
      return dummyMovies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }

  // Pencarian dengan filter genre
  List<Movie> searchMoviesWithFilters(String query, String genre) {
    List<Movie> results = dummyMovies;

    // Filter berdasarkan kata kunci
    if (query.isNotEmpty) {
      results = results.where((movie) =>
          movie.title.toLowerCase().contains(query.toLowerCase()) ||
          movie.genres.any((g) => g.toLowerCase().contains(query.toLowerCase()))).toList();
    }

    // Filter berdasarkan genre
    if (genre != 'All') {
      results = results.where((movie) => movie.genres.contains(genre)).toList();
    }

    return results;
  }
}
