import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 1. Model Data Movie (Ditambahkan field isFavorite)
class Movie {
  final String title;
  final int year;
  final String genre;
  final double rating;
  final String? imageUrl;
  bool isFavorite; // Diubah jadi non-final & tidak const agar bisa di-toggle status favoritnya

  Movie({
    required this.title,
    required this.year,
    required this.genre,
    required this.rating,
    this.imageUrl,
    this.isFavorite = false, // Default awal belum difavoritkan
  });
}

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

// 2. Halaman Utama (Menggunakan StatefulWidget untuk mengelola state favorit)
class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  // Pindahkan list movies ke dalam State agar datanya bisa dimutasi
  final List<Movie> movies = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Catalog'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      // Menerapkan ListView.builder sesuai instruksi tugas sebelumnya
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              // NAVIGASI: Pindah ke halaman detail saat Card diklik
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
                // Refresh halaman utama setelah kembali dari halaman detail agar status favorit sinkron
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Bagian Gambar Poster
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

                    // Info Judul dan Genre
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

                    // FITUR FAVORIT (Halaman List)
                    IconButton(
                      icon: Icon(
                        movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: movie.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          movie.isFavorite = !movie.isFavorite;
                        });
                      },
                    ),

                    // Rating
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
      ),
    );
  }
}

// 3. HALAMAN DETAIL (Menampilkan detail film & Fitur Favorit)
class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // FITUR FAVORIT (Halaman Detail)
          IconButton(
            icon: Icon(
              movie.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: movie.isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              setState(() {
                movie.isFavorite = !movie.isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Film Besar
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

            // Judul dan Rating
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

            // Metadata info
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
            
            // Dummy Deskripsi / Sinopsis tambahan agar halaman detail terlihat kaya informasi
            const Text(
              "Sinopsis",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ac pretium diam. "
              "Sed sit amet sem in lorem sodales eleifend. Phasellus feugiat accumsan ante eu finibus.",
              style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}