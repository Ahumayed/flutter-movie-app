import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';

import '../screens/movie_details_screen.dart';

class MoviePoster extends StatelessWidget {
  const MoviePoster({Key? key, required this.movie}) : super(key: key);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 3,
        child: Card(elevation: 5, child: Image.network(movie.getPosterImageUrl())),
      ),
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MovieDetailsWidget(movie: movie);
        }))
      },
    );
  }
}
