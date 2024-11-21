part of 'media_picker_bloc.dart';

@freezed
class MediaPickerState with _$MediaPickerState {
  const factory MediaPickerState.loading() = _Loading;
  const factory MediaPickerState.loaded(List<MediaAlbum> albums) = _Loaded;
  const factory MediaPickerState.failure(String message) = _Failure;
}
