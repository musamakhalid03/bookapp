import 'package:bloc/bloc.dart';
import 'package:com_test_testapp/features/movie/domain/usecases/get_movie_details.dart';
import 'package:com_test_testapp/features/movie/domain/usecases/get_movie_videos.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_detail_event.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_detail_state.dart';


class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetails getMovieDetails;
  final GetMovieVideos getMovieVideos;

  MovieDetailBloc({
    required this.getMovieDetails,
    required this.getMovieVideos,
  }) : super(MovieDetailInitial()) {
    on<LoadMovieDetail>(_onLoadMovieDetail);
  }

  Future<void> _onLoadMovieDetail(
    LoadMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());
    
    final movieDetailResult = await getMovieDetails(event.movieId);
    final videosResult = await getMovieVideos(event.movieId);

    movieDetailResult.fold(
      (failure) => emit(MovieDetailError(message: failure.message)),
      (movieDetail) {
        videosResult.fold(
          (failure) => emit(MovieDetailError(message: failure.message)),
          (videos) => emit(MovieDetailLoaded(movieDetail: movieDetail, videos: videos)),
        );
      },
    );
  }
}