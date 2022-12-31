import 'package:flutter/cupertino.dart';

import '../models/movie.dart';
import 'movie-poster.dart';

class PostersGridWidget extends StatelessWidget {
  const PostersGridWidget({
    Key? key,
    required List<Movie> movieList,
  })  : _movieList = movieList,
        super(key: key);

  final List<Movie> _movieList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [..._movieList.map((m) => MoviePoster(movie: m))],
      ),
    );
  }
}
