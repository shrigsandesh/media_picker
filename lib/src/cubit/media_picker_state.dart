part of 'media_picker_cubit.dart';

class MediaPickerState extends Equatable {
  final List<MediaAlbum> albums;
  final MediaContent media;
  final int currentPage;
  final bool isLoading;
  final bool isPaginating;

  final bool hasReachedEndPhotos;
  final bool hasReachedEndVideos;
  final bool hasReachedEndCommon;
  final List<AssetEntity> pickedFiles;
  final MediaType currentMediaTye;
  final int pageSize;
  final MediaAlbum currentAlubm;
  final String error;

  const MediaPickerState({
    this.albums = const [],
    this.media = MediaContent.initial,
    this.currentPage = 0,
    this.isLoading = false,
    this.isPaginating = false,
    this.hasReachedEndPhotos = false,
    this.hasReachedEndVideos = false,
    this.hasReachedEndCommon = false,
    this.pickedFiles = const [],
    this.currentMediaTye = MediaType.common,
    this.pageSize = 40,
    this.error = "",
    this.currentAlubm = const MediaAlbum(id: "", name: "Recent", size: 0),
  });

  MediaPickerState copyWith({
    List<MediaAlbum>? albums,
    MediaContent? media,
    int? currentPage,
    bool? isLoading,
    bool? isPaginating,
    bool? hasReachedEndPhotos,
    bool? hasReachedEndVideos,
    bool? hasReachedEndCommon,
    List<AssetEntity>? pickedFiles,
    MediaType? currentMediaTye,
    int? pageSize,
    MediaAlbum? currentAlubm,
    String? error,
  }) {
    return MediaPickerState(
      albums: albums ?? this.albums,
      media: media ?? this.media,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      hasReachedEndPhotos: hasReachedEndPhotos ?? this.hasReachedEndPhotos,
      hasReachedEndVideos: hasReachedEndVideos ?? this.hasReachedEndVideos,
      hasReachedEndCommon: hasReachedEndCommon ?? this.hasReachedEndCommon,
      pickedFiles: pickedFiles ?? this.pickedFiles,
      currentMediaTye: currentMediaTye ?? this.currentMediaTye,
      pageSize: pageSize ?? this.pageSize,
      currentAlubm: currentAlubm ?? this.currentAlubm,
      error: error ?? this.error,
    );
  }

  bool get hasReachedEnd {
    switch (currentMediaTye) {
      case MediaType.image:
        return hasReachedEndPhotos;
      case MediaType.video:
        return hasReachedEndVideos;
      case MediaType.common:
        return hasReachedEndCommon;
    }
  }

  @override
  List<Object> get props => [
        albums,
        media,
        currentPage,
        isLoading,
        isPaginating,
        hasReachedEndPhotos,
        hasReachedEndVideos,
        hasReachedEndCommon,
        pickedFiles,
        currentMediaTye,
        pageSize,
        currentAlubm,
        error,
      ];
}
