

import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchMoviesEvent extends MovieSearchEvent {
  final String query;

  const SearchMoviesEvent({required this.query});

  @override
  List<Object> get props => [query];
}