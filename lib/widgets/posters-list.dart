import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/movie.dart';
import 'movie-poster.dart';

class PostersList extends StatelessWidget {
  const PostersList({Key? key, this.title = '', required this.moviesList}) : super(key: key);
  final String title;
  final List<Movie> moviesList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [...moviesList.map((m) => MoviePoster(movie: m)).toList()],
            ),
          ),
        ),
      ],
    );
  }
}
