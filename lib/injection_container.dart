import 'package:com_test_testapp/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:com_test_testapp/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:com_test_testapp/features/movie/domain/repositories/movie_repository.dart';
import 'package:com_test_testapp/features/movie/domain/usecases/get_movie_details.dart';
import 'package:com_test_testapp/features/movie/domain/usecases/get_movie_videos.dart';
import 'package:com_test_testapp/features/movie/domain/usecases/get_upcoming_movies.dart';
import 'package:com_test_testapp/features/movie/domain/usecases/search_movies.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_bloc.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_search_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Movie
  sl.registerFactory(() => MovieBloc(getUpcomingMovies: sl()));
  sl.registerFactory(() => MovieDetailBloc(
        getMovieDetails: sl(),
        getMovieVideos: sl(),
      ));
  sl.registerFactory(() => MovieSearchBloc(searchMovies: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetUpcomingMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl()));
  sl.registerLazySingleton(() => GetMovieVideos(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}