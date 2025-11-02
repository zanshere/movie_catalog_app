import 'package:movie_catalog_app/data/movie_data.dart';
import 'package:movie_catalog_app/models/movie.dart';

class MovieService {
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

  List<Movie> getMoviesByGenre(String genre) {
    return dummyMovies.where((movie) => movie.genres.contains(genre)).toList();
  }

  List<Movie> getPopularMovies() {
    return List.from(dummyMovies)..sort((a, b) => b.rating.compareTo(a.rating));
  }

  List<Movie> getNewMovies() {
    return List.from(dummyMovies)..sort((a, b) => b.releaseYear.compareTo(a.releaseYear));
  }
}