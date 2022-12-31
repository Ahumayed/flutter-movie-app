import 'dart:convert';

import 'package:movie_app/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../models/Genre.dart';

class MoviesService {
  final _tmdb = TMDB(
    ApiKeys('5d75d4630283a497cd22e9a50932f46b',
        'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ZDc1ZDQ2MzAyODNhNDk3Y2QyMmU5YTUwOTMyZjQ2YiIsInN1YiI6IjYzYTAyM2RjMmYzYjE3MDBiYTA0NTc5YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.C1uHV8gTpEOvVOnqjfCdfUw544PlWTR8m0eP1wzh2OQ'),
  );

  static final MoviesService _moviesService = MoviesService._internal();
  factory MoviesService() {
    return _moviesService;
  }
  MoviesService._internal();

  Future<List<Movie>> getUpcomingMovies() async {
    final res = await _tmdb.v3.movies.getUpcoming();

    return toMovies(res["results"]);
  }

  Future<List<Movie>> getTrendingMovies() async {
    final res = await _tmdb.v3.movies.getPopular();

    return toMovies(res["results"]);
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    final res = await _tmdb.v3.movies.getNowPlaying();

    return toMovies(res["results"]);
  }

  List<Movie> toMovies(List<dynamic> moviesMap) {
    List<Movie> movies = [];

    for (var m in moviesMap) {
      movies.add(Movie.fromJson(m));
    }
    return movies.toList();
  }

  Future<List<Movie>> search(String query, List<Genre> selectedGenres) async {
    final res = await _tmdb.v3.discover.getMovies(
      withKeywords: query,
      withGenres: selectedGenres.map((g) => g.id.toString()).join(','),
    );

    return toMovies(res["results"]);
  }

  Future<void> toggleFavorite(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final favMovie = prefs.get(movie.id.toString());

    if (favMovie != null) {
      prefs.remove(movie.id.toString());
    } else {
      prefs.setString(movie.id.toString(), jsonEncode(movie.toJson()));
    }
  }

  Future<bool> isFavorite(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final isFav = prefs.getString(movie.id.toString());
    return isFav != null;
  }

  Future<List<Movie>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favMovies = prefs.getKeys().map((key) => Movie.fromJson(jsonDecode(prefs.getString(key)!)));
    return favMovies.toList();
  }

  final List<Genre> genres = [
    {"id": 28, "name": "Action"},
    {"id": 12, "name": "Adventure"},
    {"id": 16, "name": "Animation"},
    {"id": 35, "name": "Comedy"},
    {"id": 80, "name": "Crime"},
    {"id": 99, "name": "Documentary"},
    {"id": 18, "name": "Drama"},
    {"id": 10751, "name": "Family"},
    {"id": 14, "name": "Fantasy"},
    {"id": 36, "name": "History"},
    {"id": 27, "name": "Horror"},
    {"id": 10402, "name": "Music"},
    {"id": 9648, "name": "Mystery"},
    {"id": 10749, "name": "Romance"},
    {"id": 878, "name": "Science Fiction"},
    {"id": 10770, "name": "TV Movie"},
    {"id": 53, "name": "Thriller"},
    {"id": 10752, "name": "War"},
    {"id": 37, "name": "Western"}
  ].map((g) => Genre.fromJson(g)).toList();
}
