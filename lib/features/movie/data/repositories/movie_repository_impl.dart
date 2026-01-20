import 'package:com_test_testapp/core/errors/failures.dart';
import 'package:com_test_testapp/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:com_test_testapp/features/movie/data/models/video_model.dart';
import 'package:com_test_testapp/features/movie/domain/entities/movie.dart';
import 'package:com_test_testapp/features/movie/domain/entities/movie_detail.dart';
import 'package:com_test_testapp/features/movie/domain/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';


class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getUpcomingMovies() async {
    try {
      final movies = await remoteDataSource.getUpcomingMovies();
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetails(int movieId) async {
    try {
      final movieDetail = await remoteDataSource.getMovieDetails(movieId);
      return Right(movieDetail);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VideoModel>>> getMovieVideos(int movieId) async {
    try {
      final videos = await remoteDataSource.getMovieVideos(movieId);
      return Right(videos);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final movies = await remoteDataSource.searchMovies(query);
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}