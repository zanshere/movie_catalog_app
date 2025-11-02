class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final double rating;
  final List<String> genres;
  final String description;
  final int releaseYear;
  final String duration;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.rating,
    required this.genres,
    required this.description,
    required this.releaseYear,
    required this.duration,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterUrl: json['posterUrl'],
      backdropUrl: json['backdropUrl'],
      rating: json['rating'].toDouble(),
      genres: List<String>.from(json['genres']),
      description: json['description'],
      releaseYear: json['releaseYear'],
      duration: json['duration'],
    );
  }
}