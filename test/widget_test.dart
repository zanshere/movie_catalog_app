import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_catalog_app/main.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/widgets/movie_card.dart';

void main() {
  testWidgets('Home screen loads correctly', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MyApp());

    // Verify app title is displayed
    expect(find.text('MovieStream'), findsOneWidget);

    // Verify search icon is present
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Verify featured movies section
    expect(find.text('Featured Movies'), findsOneWidget);

    // Verify new movies section
    expect(find.text('New Movies'), findsOneWidget);

    // Verify popular movies section
    expect(find.text('Popular Movies'), findsOneWidget);
  });

  testWidgets('Movie card displays movie information', (WidgetTester tester) async {
    final testMovie = Movie(
      id: '1',
      title: 'Test Movie',
      posterUrl: 'https://example.com/poster.jpg',
      backdropUrl: 'https://example.com/backdrop.jpg',
      rating: 8.5,
      genres: ['Action', 'Adventure'],
      description: 'Test description',
      releaseYear: 2024,
      duration: '2h 0min',
      cast: ['Actor 1', 'Actor 2', 'Actor 3'], // Tambahkan properti cast
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MovieCard(
          movie: testMovie,
          isFavorite: false,
          onFavoriteToggle: (isFavorite) {},
        ),
      ),
    ));

    // Verify movie title is displayed
    expect(find.text('Test Movie'), findsOneWidget);

    // Verify rating is displayed
    expect(find.text('8.5'), findsOneWidget);

    // Verify genres are displayed
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('Adventure'), findsOneWidget);
  });
}