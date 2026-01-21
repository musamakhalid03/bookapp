import 'package:com_test_testapp/core/app_theme.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_bloc.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_search_bloc.dart';
import 'package:com_test_testapp/features/movie/presentation/pages/movie_detail_screen.dart';
import 'package:com_test_testapp/features/movie/presentation/pages/movie_list_screen.dart';
import 'package:com_test_testapp/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<MovieBloc>()),
        BlocProvider(create: (_) => di.sl<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.sl<MovieSearchBloc>()),
      ],
      child: MaterialApp(
        title: 'Movie Booking App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const MovieListScreen(),
        routes: {
          '/movie_detail': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map;
            return MovieDetailScreen(movieId: args['movieId']);
          },
          '/movie_search': (context) {
            return Container();
          },
        },
      ),
    );
  }
}