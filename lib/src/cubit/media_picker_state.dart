part of 'media_picker_cubit.dart';

class MediaPickerState extends Equatable {
  final bool isLoading;
  final List<MediaAlbum> albums;
  final MediaContent media;
  final List<AssetEntity> pickedFiles;
  final bool isPaginating;
  final bool hasReachedEnd;
  final List<AssetEntity> paginatedMedias;

  final int currentPage;
  final MediaType currentMediaTye;
  final int pageSize;

  const MediaPickerState({
    this.isLoading = false,
    this.albums = const [],
    this.media = MediaContent.initial,
    this.pickedFiles = const [],
    this.isPaginating = false,
    this.hasReachedEnd = false,
    this.paginatedMedias = const [],
    this.currentPage = 0,
    this.currentMediaTye = MediaType.common,
    this.pageSize = 40,
  });

  MediaPickerState copyWith({
    bool? isLoading,
    List<MediaAlbum>? albums,
    MediaContent? media,
    List<AssetEntity>? pickedFiles,
    bool? isPaginating,
    bool? hasReachedEnd,
    List<AssetEntity>? paginatedMedias,
    int? currentPage,
    List<AssetPathEntity>? albumsPaths,
    MediaType? currentMediaTye,
  }) {
    return MediaPickerState(
        isLoading: isLoading ?? this.isLoading,
        albums: albums ?? this.albums,
        media: media ?? this.media,
        pickedFiles: pickedFiles ?? this.pickedFiles,
        isPaginating: isPaginating ?? this.isPaginating,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
        currentPage: currentPage ?? this.currentPage,
        currentMediaTye: currentMediaTye ?? this.currentMediaTye);
  }

  @override
  List<Object> get props => [
        isLoading,
        albums,
        media,
        pickedFiles,
        hasReachedEnd,
        isPaginating,
        currentPage,
        currentMediaTye,
      ];
}
