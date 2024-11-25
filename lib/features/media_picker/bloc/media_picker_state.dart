part of 'media_picker_cubit.dart';

@freezed
class MediaPickerState with _$MediaPickerState {
  const factory MediaPickerState({
    @Default(false) bool isLoading,
    @Default([]) List<MediaAlbum> albums,
    @Default(MediaContent.initial) MediaContent media,
    @Default([]) List<AssetEntity> pickedFiles,
  }) = _MediaPickerState;
}

enum MediaType { media, video, photo }
