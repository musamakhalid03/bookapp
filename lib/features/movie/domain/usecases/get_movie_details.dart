import 'package:com_test_testapp/core/errors/failures.dart';
import 'package:com_test_testapp/features/movie/domain/entities/movie_detail.dart';
import 'package:com_test_testapp/features/movie/domain/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';

class GetMovieDetails {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  Future<Either<Failure, MovieDetail>> call(int movieId) async {
    return await repository.getMovieDetails(movieId);
  }
}