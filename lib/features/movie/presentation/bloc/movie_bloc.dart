import 'package:bloc/bloc.dart';
import 'package:com_test_testapp/core/usecases/usecase.dart';
import 'package:com_test_testapp/features/movie/domain/entities/movie.dart';
import 'package:com_test_testapp/features/movie/domain/usecases/get_upcoming_movies.dart';
import 'package:equatable/equatable.dart';


part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetUpcomingMovies getUpcomingMovies;

  MovieBloc({required this.getUpcomingMovies}) : super(MovieInitial()) {
    on<GetUpcomingMoviesEvent>(_onGetUpcomingMovies);
  }

  Future<void> _onGetUpcomingMovies(
    GetUpcomingMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    
    final result = await getUpcomingMovies(NoParams());
    
    result.fold(
      (failure) => emit(MovieError(message: failure.message)),
      (movies) => emit(MovieLoaded(movies: movies)),
    );
  }
}