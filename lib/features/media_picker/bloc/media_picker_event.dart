part of 'media_picker_bloc.dart';

@freezed
class MediaPickerEvent with _$MediaPickerEvent {
  const factory MediaPickerEvent.initial() = _InitialEvent;
  const factory MediaPickerEvent.changeAlbum(int index) = _AlbumChanged;
  const factory MediaPickerEvent.addPickedMedia(AssetEntity asset) =
      _PickedMediaAdded;
  const factory MediaPickerEvent.removeMedia(AssetEntity asset) = _MediaRemoved;
}
