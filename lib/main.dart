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

  const Movie({
    required this.title,
    required this.year,
    required this.genre,
    required this.rating,
    this.imageUrl, // No longer required
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Movie> movies = [
      const Movie(
        title: "The Shawshank Redemption", 
        year: 1994, 
        genre: "Drama", 
        rating: 9.3,
        imageUrl: "assets/images/shawshank.jpg",
      ),
      const Movie(
        title: "The Godfather", 
        year: 1972, 
        genre: "Crime, Drama", 
        rating: 9.2,
        imageUrl: "assets/images/godfather.jpg",
      ),
      // 2. This movie has no image path specified
      const Movie(
        title: "A Movie Without A Poster", 
        year: 2026, 
        genre: "Mystery", 
        rating: 7.5,
        // imageUrl is completely omitted here
      ),
      const Movie(
        title: "A Movie Without A Poster", 
        year: 2026, 
        genre: "Mystery", 
        rating: 7.5,
      ),
      const Movie(
        title: "A Movie Without A Poster", 
        year: 2026, 
        genre: "Mystery", 
        rating: 7.5,
      ),
      const Movie(
        title: "A Movie Without A Poster", 
        year: 2026, 
        genre: "Mystery", 
        rating: 7.5,
      ),
      const Movie(
        title: "A Movie Without A Poster", 
        year: 2026, 
        genre: "Mystery", 
        rating: 7.5,
      ),
      const Movie(
        title: "A Movie Without A Poster", 
        year: 2026, 
        genre: "Mystery", 
        rating: 7.5,
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Catalog'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          addAutomaticKeepAlives: false,
          padding: const EdgeInsets.all(8.0),
          children: List.generate(movies.length, (index) {
            final movie = movies[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        // 3. Fallback logic: use movie image if available, else use placeholder
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
                    
                    // Center Column
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
                    
                    // Right Column
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
            );
          }),
        ),
      ),
    );
  }
}