import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../models/movie.dart';
import '../service/movies_service.dart';
import '../widgets/posters-list.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  MoviesService moviesService = MoviesService();
  List<Movie> upcomingMovies = [];
  List<Movie> trendingMovies = [];
  List<Movie> nowPlayingMovies = [];
  bool _isLoading = true;

  Future<void> getMovies() async {
    setState(() {
      _isLoading = true;
    });
    var um = await moviesService.getUpcomingMovies();
    var tm = await moviesService.getTrendingMovies();
    var np = await moviesService.getNowPlayingMovies();
    setState(() {
      upcomingMovies = um;
      nowPlayingMovies = np;
      trendingMovies = tm;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: _isLoading
            ? [
                const GridLoaderWidget(),
              ]
            : [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: PostersList(title: "Upcoming", moviesList: upcomingMovies),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: PostersList(title: "Playing", moviesList: nowPlayingMovies),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: PostersList(title: "Trending", moviesList: trendingMovies),
                ),
              ],
      ),
    );
  }
}

class GridLoaderWidget extends StatelessWidget {
  const GridLoaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonGridLoader(
      builder: Card(
        color: Colors.transparent,
        child: GridTile(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: []),
        ),
      ),
      items: 9,
      itemsPerRow: 3,
      period: const Duration(seconds: 1),
      highlightColor: Colors.white,
      direction: SkeletonDirection.ltr,
      childAspectRatio: 1,
    );
  }
}
