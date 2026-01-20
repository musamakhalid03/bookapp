import 'package:com_test_testapp/core/errors/failures.dart';
import 'package:com_test_testapp/features/movie/data/models/video_model.dart';
import 'package:com_test_testapp/features/movie/domain/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';


class GetMovieVideos {
  final MovieRepository repository;

  GetMovieVideos(this.repository);

  Future<Either<Failure, List<VideoModel>>> call(int movieId) async {
    return await repository.getMovieVideos(movieId);
  }
}