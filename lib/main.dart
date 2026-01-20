import 'package:com_test_testapp/core/app_theme.dart';
import 'package:com_test_testapp/features/movie/presentation/pages/movie_list_screen.dart';
import 'package:com_test_testapp/injection_container.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Booking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MovieListScreen(),
    );
  }
}