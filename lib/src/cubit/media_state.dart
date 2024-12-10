import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaState extends Equatable {
  final bool isLoading;
  final List<AssetEntity> medias;

  final bool hasReachedEnd;
  final int currentPage;

  const MediaState({
    this.isLoading = false,
    this.medias = const [],
    this.hasReachedEnd = false,
    this.currentPage = 1,
  });

  MediaState copyWith(
      {bool? isLoading,
      List<AssetEntity>? medias,
      bool? hasReachedEnd,
      int? currentPage}) {
    return MediaState(
      isLoading: isLoading ?? this.isLoading,
      medias: medias ?? this.medias,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [isLoading, medias, hasReachedEnd, currentPage];
}
