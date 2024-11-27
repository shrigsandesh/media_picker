part of 'media_picker_cubit.dart';

class MediaPickerState extends Equatable {
  final bool isLoading;
  final List<MediaAlbum> albums;
  final MediaContent media;
  final List<AssetEntity> pickedFiles;

  const MediaPickerState({
    this.isLoading = false,
    this.albums = const [],
    this.media = MediaContent.initial,
    this.pickedFiles = const [],
  });

  MediaPickerState copyWith({
    bool? isLoading,
    List<MediaAlbum>? albums,
    MediaContent? media,
    List<AssetEntity>? pickedFiles,
  }) {
    return MediaPickerState(
        isLoading: isLoading ?? this.isLoading,
        albums: albums ?? this.albums,
        media: media ?? this.media,
        pickedFiles: pickedFiles ?? this.pickedFiles);
  }

  @override
  List<Object> get props => [isLoading, albums, media, pickedFiles];
}
