import 'package:com_test_testapp/core/errors/failures.dart';
import 'package:com_test_testapp/core/usecases/usecase.dart';
import 'package:com_test_testapp/features/movie/domain/entities/movie.dart';
import 'package:com_test_testapp/features/movie/domain/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';

class GetUpcomingMovies implements UseCase<List<Movie>, NoParams> {
  final MovieRepository repository;

  GetUpcomingMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) async {
    return await repository.getUpcomingMovies();
  }
}