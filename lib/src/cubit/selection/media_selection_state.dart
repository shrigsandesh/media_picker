part of 'media_selection_cubit.dart';

class MediaSelectionState extends Equatable {
  final bool isLoading;
  final List<MediaAlbum> albums;
  final MediaContent media;
  final List<AssetEntity> pickedFiles;
  final MediaType currentMedia;

  final bool hasReachedEnd;
  final int currentPage;

  const MediaSelectionState(
      {this.isLoading = false,
      this.albums = const [],
      this.media = MediaContent.initial,
      this.pickedFiles = const [],
      this.hasReachedEnd = false,
      this.currentPage = 1,
      this.currentMedia = MediaType.common});

  MediaSelectionState copyWith({
    bool? isLoading,
    List<MediaAlbum>? albums,
    MediaContent? media,
    List<AssetEntity>? pickedFiles,
    bool? hasReachedEnd,
    int? currentPage,
    MediaType? currentMedia,
  }) {
    return MediaSelectionState(
      isLoading: isLoading ?? this.isLoading,
      albums: albums ?? this.albums,
      media: media ?? this.media,
      pickedFiles: pickedFiles ?? this.pickedFiles,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      currentMedia: currentMedia ?? this.currentMedia,
    );
  }

  @override
  List<Object> get props =>
      [isLoading, albums, media, pickedFiles, hasReachedEnd];
}
