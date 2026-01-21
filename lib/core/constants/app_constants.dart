class AppConstants {
  static const String appName = 'Movie Booking';
  static const String tmdbApiKey = '670a10aa3f16f4d1cd07ab2188f7767f';

  static const String tmdbAccessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NzBhMTBhYTNmMTZmNGQxY2QwN2FiMjE4OGY3NzY3ZiIsIm5iZiI6MTc2ODk0MTQyMi4xMDIwMDAyLCJzdWIiOiI2OTZmZTc2ZWI1NDg5MjQ4NzRmZTE0NjAiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.d7VKJ1BOXfLsVlq9LJB_abQ9UJlE36Cfv4loMra9TMw';
  
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';
  
  static const String upcomingMoviesEndpoint = '/movie/upcoming';
  static const String movieDetailsEndpoint = '/movie';
  static const String movieVideosEndpoint = '/videos';
  static const String searchMoviesEndpoint = '/search/movie';
  
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int moviesPerPage = 20;
  
  static const String imageSizeOriginal = 'original';
  static const String imageSizeW500 = 'w500';
  static const String imageSizeW342 = 'w342';
  static const String imageSizeW185 = 'w185';
}