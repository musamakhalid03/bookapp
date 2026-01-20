

import 'package:com_test_testapp/features/movie/data/models/video_model.dart';
import 'package:com_test_testapp/features/movie/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movieDetail;
  final List<VideoModel> videos;

  const MovieDetailLoaded({
    required this.movieDetail,
    required this.videos,
  });

  @override
  List<Object> get props => [movieDetail, videos];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError({required this.message});

  @override
  List<Object> get props => [message];
}