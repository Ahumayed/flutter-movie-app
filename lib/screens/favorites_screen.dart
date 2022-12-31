import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../service/movies_service.dart';
import '../widgets/posters_grid.dart';

class FavoritesScreenWidget extends StatefulWidget {
  const FavoritesScreenWidget({Key? key}) : super(key: key);

  @override
  State<FavoritesScreenWidget> createState() => _FavoritesScreenWidgetState();
}

class _FavoritesScreenWidgetState extends State<FavoritesScreenWidget> {
  MoviesService moviesService = MoviesService();
  List<Movie> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final List<Movie> favorites = await moviesService.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _favorites.isEmpty
        ? const Center(
            child: Text(
              "Add some movies to your favorites",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          )
        : PostersGridWidget(movieList: _favorites);
  }
}
