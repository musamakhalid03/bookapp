import 'dart:convert';
import 'package:com_test_testapp/core/constants/app_constants.dart';
import 'package:com_test_testapp/features/movie/data/models/movie_detail_model.dart';
import 'package:com_test_testapp/features/movie/data/models/movie_model.dart';
import 'package:com_test_testapp/features/movie/data/models/video_model.dart';
import 'package:http/http.dart' as http;


abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getUpcomingMovies();
  Future<MovieDetailModel> getMovieDetails(int movieId);
  Future<List<VideoModel>> getMovieVideos(int movieId);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getUpcomingMovies() async {
    final response = await client.get(
      Uri.parse(
          '${AppConstants.tmdbBaseUrl}${AppConstants.upcomingMoviesEndpoint}?api_key=${AppConstants.tmdbApiKey}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>? ?? [];
      return results
          .map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load upcoming movies: ${response.statusCode}');
    }
  }

  @override
  Future<MovieDetailModel> getMovieDetails(int movieId) async {
    final response = await client.get(
      Uri.parse(
          '${AppConstants.tmdbBaseUrl}${AppConstants.movieDetailsEndpoint}/$movieId?api_key=${AppConstants.tmdbApiKey}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return MovieDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load movie details: ${response.statusCode}');
    }
  }

  @override
  Future<List<VideoModel>> getMovieVideos(int movieId) async {
    final response = await client.get(
      Uri.parse(
          '${AppConstants.tmdbBaseUrl}${AppConstants.movieDetailsEndpoint}/$movieId${AppConstants.movieVideosEndpoint}?api_key=${AppConstants.tmdbApiKey}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>? ?? [];
      return results
          .map((videoJson) => VideoModel.fromJson(videoJson as Map<String, dynamic>))
          .where((video) => video.isYouTubeTrailer)
          .toList();
    } else {
      throw Exception('Failed to load movie videos: ${response.statusCode}');
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get(
      Uri.parse(
          '${AppConstants.tmdbBaseUrl}${AppConstants.searchMoviesEndpoint}?api_key=${AppConstants.tmdbApiKey}&query=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>? ?? [];
      return results
          .map((movieJson) => MovieModel.fromJson(movieJson as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to search movies: ${response.statusCode}');
    }
  }
}