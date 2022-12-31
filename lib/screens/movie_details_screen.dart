import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/service/movies_service.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({Key? key, required this.movie}) : super(key: key);
  final Movie movie;

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  final MoviesService _moviesService = MoviesService();
  bool isFav = false;

  @override
  initState() {
    super.initState();

    _moviesService.isFavorite(widget.movie).then((value) {
      setState(() {
        isFav = value;
      });
    });
  }

  Future<void> _addToFavorites() async {
    await _moviesService.toggleFavorite(widget.movie);
    setState(() {
      isFav = !isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Image.network(widget.movie.getBackdropImageUrl(), fit: BoxFit.cover, height: 300),
              Positioned(
                top: 10,
                left: 10,
                child: Card(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Card(
                  child: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pink,
                    ),
                    onPressed: () => _addToFavorites(),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.movie.title,
                style: const TextStyle(fontSize: 30, shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(5.0, 5.0),
                  ),
                ]),
              ),
            ),
            Text(
              widget.movie.releaseDate,
              textAlign: TextAlign.start,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: widget.movie.genreIds
                    .map((genreId) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Chip(
                            label: Text(_moviesService.genres.firstWhere((g) => g.id == genreId).name),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.movie.overview),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
