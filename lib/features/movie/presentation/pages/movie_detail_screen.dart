import 'package:com_test_testapp/features/movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_detail_event.dart';
import 'package:com_test_testapp/features/movie/presentation/bloc/movie_detail_state.dart';
import 'package:com_test_testapp/features/movie/presentation/pages/seat_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  YoutubePlayerController? _youtubeController;
  bool _isTrailerPlaying = false;

  @override
  void initState() {
    super.initState();
    context
        .read<MovieDetailBloc>()
        .add(LoadMovieDetail(movieId: widget.movieId));
  }

  void _playTrailer(String youtubeKey) {
    _youtubeController = YoutubePlayerController(
      initialVideoId: youtubeKey,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        autoPlay: true,
      ),
    );

    setState(() {
      _isTrailerPlaying = true;
    });
  }

  void _closeTrailer() {
    _youtubeController?.pause();
    setState(() {
      _isTrailerPlaying = false;
      _youtubeController = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailBloc, MovieDetailState>(
      builder: (context, state) {
        if (state is MovieDetailLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is MovieDetailLoaded) {
          final movie = state.movieDetail;
          final videos = state.videos;

          if (_isTrailerPlaying && _youtubeController != null) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Center(
                  child: YoutubePlayerIFrame(
          controller: _youtubeController!,
          aspectRatio: 16 / 9,
        ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _closeTrailer,
                child: const Icon(Icons.close),
              ),
            );
          }

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        movie.backdropPath != null
                            ? Image.network(
                                'https://image.tmdb.org/t/p/original${movie.backdropPath}',
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        Container(color: Colors.grey[800]),
                              )
                            : Container(color: Colors.grey[800]),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                                Colors.black,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.access_time, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              movie.runtime != null
                                  ? '${movie.runtime} min'
                                  : 'N/A',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'PG-13',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Overview',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.overview ?? 'No overview available.',
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SeatSelectionScreen(movie: movie),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.confirmation_num),
                                label: const Text('Get Tickets'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  backgroundColor: const Color(0xFF4DABF7),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (videos.isNotEmpty)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _playTrailer(videos.first.key);
                                  },
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Watch Trailer'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    backgroundColor: const Color(0xFF1F3A5F),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (movie.genres.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Genres',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: movie.genres
                                    .map((genre) => Chip(
                                          label: Text(genre.name),
                                          backgroundColor:
                                              const Color(0xFF1F3A5F),
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is MovieDetailError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<MovieDetailBloc>()
                          .add(LoadMovieDetail(movieId: widget.movieId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void dispose() {
    _youtubeController?.close();
    super.dispose();
  }
}
