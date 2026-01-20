import 'package:com_test_testapp/features/movie/domain/entities/genre.dart';
import 'package:com_test_testapp/features/movie/domain/entities/movie_detail.dart';

class MovieDetailModel extends MovieDetail {
  const MovieDetailModel({
    required super.id,
    required super.title,
    super.overview,
    super.posterPath,
    super.backdropPath,
    super.releaseDate,
    super.voteAverage,
    super.voteCount,
    super.runtime,
    super.genres,
    super.status,
    super.tagline,
    super.budget,
    super.revenue,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Unknown Title',
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] != null && json['release_date'].toString().isNotEmpty
          ? DateTime.tryParse(json['release_date'].toString())
          : null,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      runtime: json['runtime'] as int?,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((genreJson) => Genre.fromJson(genreJson as Map<String, dynamic>))
              .toList() ??
          [],
      status: json['status'] as String?,
      tagline: json['tagline'] as String?,
      budget: json['budget'] as int?,
      revenue: json['revenue'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate?.toIso8601String(),
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'runtime': runtime,
      'genres': genres.map((genre) => genre.toJson()).toList(),
      'status': status,
      'tagline': tagline,
      'budget': budget,
      'revenue': revenue,
    };
  }
}