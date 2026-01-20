import 'package:equatable/equatable.dart';
import 'genre.dart';

class MovieDetail extends Equatable {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? releaseDate;
  final double voteAverage;
  final int voteCount;
  final int? runtime;
  final List<Genre> genres;
  final String? status;
  final String? tagline;
  final int? budget;
  final int? revenue;

  const MovieDetail({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.runtime,
    this.genres = const [],
    this.status,
    this.tagline,
    this.budget,
    this.revenue,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        releaseDate,
        voteAverage,
        voteCount,
        runtime,
        genres,
        status,
        tagline,
        budget,
        revenue,
      ];
}