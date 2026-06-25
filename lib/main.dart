import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Movie {
  final String title;
  final int year;
  final String genre;
  final double rating;
  final String? imageUrl;
  bool isFavorite;

  Movie({
    required this.title,
    required this.year,
    required this.genre,
    required this.rating,
    this.imageUrl,
    this.isFavorite = false,
  });
}

class MovieBloc {
  final List<Movie> _movies = [
    Movie(
      title: "The Shawshank Redemption",
      year: 1994,
      genre: "Drama",
      rating: 9.3,
      imageUrl: "assets/images/shawshank.jpg",
    ),
    Movie(
      title: "The Godfather",
      year: 1972,
      genre: "Crime, Drama",
      rating: 9.2,
      imageUrl: "assets/images/godfather.jpg",
    ),
    Movie(
      title: "A Movie Without A Poster",
      year: 2026,
      genre: "Mystery",
      rating: 7.5,
    ),
    Movie(
      title: "A Movie Without A Poster 2",
      year: 2026,
      genre: "Mystery",
      rating: 7.5,
    ),
  ];

  final StreamController<List<Movie>> _movieStreamController = StreamController<List<Movie>>.broadcast();

  Stream<List<Movie>> get movieStream => _movieStreamController.stream;

  Future<List<Movie>> fetchInitialMovies() async {
    await Future.delayed(const Duration(seconds: 2));
    _movieStreamController.sink.add(_movies);
    return _movies;
  }

  void toggleFavorite(Movie targetMovie) {
    final index = _movies.indexWhere((m) => m.title == targetMovie.title);
    if (index != -1) {
      _movies[index].isFavorite = !_movies[index].isFavorite;
      _movieStreamController.sink.add(List.from(_movies));
    }
  }

  void dispose() {
    _movieStreamController.close();
  }
}

final movieBloc = MovieBloc();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const MovieListScreen(),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> _initialMoviesFuture;

  @override
  void initState() {
    super.initState();
    _initialMoviesFuture = movieBloc.fetchInitialMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Catalog'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Movie>>(
        future: _initialMoviesFuture,
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (futureSnapshot.hasError) {
            return Center(child: Text('Error: ${futureSnapshot.error}'));
          }

          return StreamBuilder<List<Movie>>(
            stream: movieBloc.movieStream,
            initialData: futureSnapshot.data,
            builder: (context, streamSnapshot) {
              if (!streamSnapshot.hasData || streamSnapshot.data!.isEmpty) {
                return const Center(child: Text('No movies available'));
              }

              final movies = streamSnapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(movie: movie),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                movie.imageUrl ?? "assets/images/placeholder.png",
                                width: 70,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 70,
                                    height: 100,
                                    color: Colors.grey[400],
                                    child: const Icon(Icons.broken_image, color: Colors.white),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${movie.genre} • ${movie.year}",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: movie.isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                movieBloc.toggleFavorite(movie);
                              },
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  "${movie.rating}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          StreamBuilder<List<Movie>>(
            stream: movieBloc.movieStream,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(
                  movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: movie.isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  movieBloc.toggleFavorite(movie);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  movie.imageUrl ?? "assets/images/placeholder.png",
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 300,
                      color: Colors.grey[400],
                      child: const Icon(Icons.broken_image, size: 50, color: Colors.white),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    movie.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 28),
                    const SizedBox(width: 4),
                    Text(
                      "${movie.rating}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Genre: ${movie.genre}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 6),
            Text(
              "Tahun Rilis: ${movie.year}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            const Text(
              "Sinopsis",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ac pretium diam. Sed sit amet sem in lorem sodales eleifend. Phasellus feugiat accumsan ante eu finibus.",
              style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}