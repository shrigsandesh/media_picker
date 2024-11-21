import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:media_picker/core/models/media_data.dart';
import 'package:photo_manager/photo_manager.dart';

part 'media_picker_bloc.freezed.dart';
part 'media_picker_state.dart';
part 'media_picker_event.dart';

@injectable
class MediaPickerBloc extends Bloc<MediaPickerEvent, MediaPickerState> {
  MediaPickerBloc() : super(const MediaPickerState.loading()) {
    on<_InitialEvent>(_onInitialEvent);
  }

  FutureOr<void> _onInitialEvent(
      _InitialEvent event, Emitter<MediaPickerState> emit) async {
    emit(const MediaPickerState.loading());

    try {
      // Fetch albums
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();

      // Fetch album details (names, sizes, thumbnails)
      List<MediaAlbum> mediaAlbums =
          await Future.wait(albums.map((album) async {
        String name = album.isAll ? "All" : album.name;
        int size = await album.assetCountAsync;
        AssetEntity? thumbnail =
            (await album.getAssetListRange(start: 0, end: 1)).firstOrNull;

        return MediaAlbum(name: name, size: size, thumbnail: thumbnail);
      }));

      emit(MediaPickerState.loaded(mediaAlbums));
    } catch (e) {
      emit(MediaPickerState.failure("Failed to load media: ${e.toString()}"));
    }
  }
}
