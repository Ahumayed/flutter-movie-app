import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/Genre.dart';

import '../models/movie.dart';
import '../service/movies_service.dart';
import '../widgets/posters_grid.dart';
import 'movie_details_screen.dart';

class SearchScreenWidget extends StatefulWidget {
  const SearchScreenWidget({Key? key}) : super(key: key);

  @override
  State<SearchScreenWidget> createState() => _SearchScreenWidgetState();
}

class _SearchScreenWidgetState extends State<SearchScreenWidget> {
  String _searchValue = '';
  MoviesService moviesService = MoviesService();
  List<Movie> _searchResults = [];
  List<String> _suggestions = [];
  final List<Genre> _selectedGenres = [];

  search() async {
    if (_searchValue.isEmpty && _selectedGenres.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    var results = await moviesService.search(_searchValue, _selectedGenres);
    setState(() {
      _suggestions = results.map((m) => m.title).toList();
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        backgroundColor: Colors.amber[800],
        title: const Text(''),
        searchHintText: 'Search by movie name',
        onSearch: (value) => {
          setState(() {
            _searchValue = value;
          }),
          search()
        },
        suggestions: _suggestions,
        debounceDuration: const Duration(milliseconds: 800),
        onSuggestionTap: (movieTitle) => {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MovieDetailsWidget(movie: _searchResults.firstWhere((m) => m.title == movieTitle));
          }))
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...moviesService.genres
                        .map((g) => GestureDetector(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Chip(
                                    label: Text(g.name),
                                    backgroundColor: _selectedGenres.contains(g) ? Colors.amber[800] : Colors.grey[700],
                                  )),
                              onTap: () {
                                setState(() {
                                  if (_selectedGenres.contains(g)) {
                                    _selectedGenres.remove(g);
                                  } else {
                                    _selectedGenres.add(g);
                                  }

                                  search();
                                });
                              },
                            ))
                        .toList()
                  ],
                ),
              ),
            ),
            _searchResults.isEmpty
                ? const Center(
                    child: Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 300),
                        child: Text(
                          "Select a genre or search by movie name",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                : PostersGridWidget(movieList: _searchResults),
          ],
        ),
      ),
    );
  }
}
