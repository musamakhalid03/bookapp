import 'package:com_test_testapp/core/errors/failures.dart';
import 'package:com_test_testapp/features/movie/data/models/video_model.dart';
import 'package:com_test_testapp/features/movie/domain/entities/movie.dart';
import 'package:com_test_testapp/features/movie/domain/entities/movie_detail.dart';
import 'package:dartz/dartz.dart';


abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getUpcomingMovies();
  Future<Either<Failure, MovieDetail>> getMovieDetails(int movieId);
  Future<Either<Failure, List<VideoModel>>> getMovieVideos(int movieId);
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
}