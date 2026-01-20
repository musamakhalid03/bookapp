import 'package:com_test_testapp/core/errors/failures.dart';
import 'package:com_test_testapp/features/movie/domain/entities/movie.dart';
import 'package:com_test_testapp/features/movie/domain/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';


class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call(String query) async {
    return await repository.searchMovies(query);
  }
}