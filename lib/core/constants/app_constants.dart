class AppConstants {
  static const String appName = 'Movie Booking';
  static const String tmdbApiKey = 'api_key - 123456abcdefg';
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