import 'package:bloc/bloc.dart';
import 'package:com_test_testapp/features/movie/domain/usecases/search_movies.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_search_event.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_search_state.dart';


class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies}) : super(MovieSearchInitial()) {
    on<SearchMoviesEvent>(_onSearchMovies);
  }

  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MovieSearchState> emit,
  ) async {
    emit(MovieSearchLoading());
    
    final result = await searchMovies(event.query);
    
    result.fold(
      (failure) => emit(MovieSearchError(message: failure.message)),
      (movies) => emit(MovieSearchLoaded(movies: movies)),
    );
  }
}