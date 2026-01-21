import 'package:com_test_testapp/features/movie/data/models/video_model.dart';
import 'package:com_test_testapp/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_detail_event.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_detail_state.dart';
import 'package:com_test_testapp/features/seat_selection/presentation/pages/seat_selection_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize movie details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieDetailBloc>().add(LoadMovieDetail(movieId: widget.movieId));
    });
  }

  Future<void> _playTrailer(String youtubeKey) async {
    final youtubeUrl = 'https://www.youtube.com/watch?v=$youtubeKey';
    
    try {
      if (await canLaunchUrl(Uri.parse(youtubeUrl))) {
        await launchUrl(
          Uri.parse(youtubeUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw Exception('Could not launch $youtubeUrl');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cannot play trailer. Please try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  double _getResponsiveFontSize(BuildContext context, double mobile, double tablet, double desktop) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return mobile;
    if (screenWidth < 1200) return tablet;
    return desktop;
  }

  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return 16.0;
    if (screenWidth < 1200) return 20.0;
    return 24.0;
  }

  double _getAppBarHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    if (screenWidth < 600) {
      return screenHeight * 0.35; // 35% for mobile
    } else if (screenWidth < 1200) {
      return screenHeight * 0.40; // 40% for tablet
    } else {
      return screenHeight * 0.45; // 45% for desktop
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return _buildLoadingState();
          } else if (state is MovieDetailError) {
            return _buildErrorState(context, state.message);
          } else if (state is MovieDetailLoaded) {
            return _buildMovieDetail(context, state);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.blueAccent.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading movie details...',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_getResponsivePadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 18, 20, 22),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 14, 16, 18),
                color: Colors.grey.shade400,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<MovieDetailBloc>().add(LoadMovieDetail(movieId: widget.movieId));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: _getResponsivePadding(context) / 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(context, 14, 16, 18),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieDetail(BuildContext context, MovieDetailLoaded state) {
    final movie = state.movieDetail;
    final videos = state.videos;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: _getAppBarHeight(context),
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Movie backdrop image
                if (movie.backdropPath != null)
                  Image.network(
                    'https://image.tmdb.org/t/p/original${movie.backdropPath}',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.blueAccent,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade900,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 48,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Image not available',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    color: Colors.grey.shade900,
                    child: Center(
                      child: Icon(
                        Icons.movie,
                        size: 64,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),

                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.8),
                        Colors.black,
                      ],
                      stops: const [0, 0.3, 0.6, 0.8, 1],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(_getResponsivePadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Title
                Text(
                  movie.title,
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context, 24, 28, 32),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                // Movie Info Row
                _buildMovieInfoRow(context, movie),

                const SizedBox(height: 20),

                // Overview
                _buildOverviewSection(context, movie),

                const SizedBox(height: 24),

                // Action Buttons
                _buildActionButtons(context, movie, videos),

                const SizedBox(height: 24),

                // Genres
                if (movie.genres.isNotEmpty) _buildGenresSection(context, movie),

                const SizedBox(height: 16),

                // Additional Info
                _buildAdditionalInfo(context, movie),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieInfoRow(BuildContext context, MovieDetail movie) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Wrap(
      spacing: isSmallScreen ? 12 : 16,
      runSpacing: isSmallScreen ? 8 : 12,
      children: [
        // Rating
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rounded,
              color: Colors.amber.shade400,
              size: isSmallScreen ? 18 : 20,
            ),
            const SizedBox(width: 4),
            Text(
              movie.voteAverage.toStringAsFixed(1),
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        // Runtime
        if (movie.runtime != null && movie.runtime! > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time_rounded,
                color: Colors.grey.shade400,
                size: isSmallScreen ? 16 : 18,
              ),
              const SizedBox(width: 4),
              Text(
                '${movie.runtime} min',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            ],
          ),

        // Release Year
        if (movie.releaseDate != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: Colors.grey.shade400,
                size: isSmallScreen ? 16 : 18,
              ),
              const SizedBox(width: 4),
              Text(
                movie.releaseDate!.year.toString(),
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            ],
          ),

        // Rating Badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8 : 10,
            vertical: isSmallScreen ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'PG-13',
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewSection(BuildContext context, MovieDetail movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 18, 20, 22),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          movie.overview?.isNotEmpty == true
              ? movie.overview!
              : 'No overview available for this movie.',
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 14, 16, 18),
            color: Colors.grey.shade300,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, MovieDetail movie, List<VideoModel> videos) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Column(
      children: [
      
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeatSelectionScreen(movie: movie),
                ),
              );
            },
            icon: Icon(
              Icons.confirmation_num_rounded,
              size: isSmallScreen ? 20 : 24,
            ),
            label: Text(
              'Get Tickets',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 16 : 20,
                horizontal: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: Colors.blueAccent.withOpacity(0.5),
            ),
          ),
        ),

        SizedBox(height: isSmallScreen ? 12 : 16),
        if (videos.isNotEmpty)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _playTrailer(videos.first.key),
              icon: Icon(
                Icons.play_arrow_rounded,
                size: isSmallScreen ? 20 : 24,
              ),
              label: Text(
                'Watch Trailer',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 16 : 20,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: Colors.grey.shade600,
                  width: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGenresSection(BuildContext context, MovieDetail movie) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Genres',
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 18, 20, 22),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: isSmallScreen ? 8 : 12,
          runSpacing: isSmallScreen ? 8 : 12,
          children: movie.genres.map((genre) {
            return Chip(
              label: Text(
                genre.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
              backgroundColor: Colors.blueGrey.shade800,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 4 : 6,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context, MovieDetail movie) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (movie.tagline != null && movie.tagline!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                '"${movie.tagline!}"',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

        if (movie.status != null && movie.status!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Status: ${movie.status!}',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

