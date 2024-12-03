import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:media_picker/src/utils/helpers.dart';
import 'package:media_picker/src/utils/utils.dart';

import 'package:photo_manager/photo_manager.dart';

part 'media_picker_state.dart';

class MediaPickerCubit extends Cubit<MediaPickerState> {
  MediaPickerCubit() : super(const MediaPickerState());

  void loadMedia([List<MediaType> mediaType = const []]) async {
    emit(state.copyWith(isLoading: true));

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: determineMediaType(mediaType));
    albums.toSet().toList();

    final mergedAlbums = await filterAlbum(albums);

    if (albums.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }
    int end = await albums[0].assetCountAsync;
    var allMedia = await albums[0].getAssetListRange(start: 0, end: end);
    var mediaContent = MediaContent.fromAssetEntity(allMedia, albums[0].name);

    emit(state.copyWith(
        albums: mergedAlbums, media: mediaContent, isLoading: false));
  }

  void changeAlbum(String albumName) async {
    if (albumName == state.media.name) {
      return;
    }
    emit(state.copyWith(isLoading: true));
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();

    var newList = albums.where((e) {
      return e.name == albumName;
    }).toList();

    List<AssetEntity> allAsset = [];

    for (var item in newList) {
      int end = await item.assetCountAsync;
      var asset = await item.getAssetListRange(start: 0, end: end);
      allAsset.addAll(asset);
    }

    var mediaContent = MediaContent.fromAssetEntity(allAsset, newList[0].name);
    emit(state.copyWith(media: mediaContent, isLoading: false));
  }

  void addPickedFiles(AssetEntity video) {
    if (state.pickedFiles.contains(video)) {
      return;
    }
    emit(
      state.copyWith(
        pickedFiles: [
          ...state.pickedFiles,
          ...[video]
        ],
      ),
    );
  }

  void removeSelected(AssetEntity pickedVideo) {
    emit(
      state.copyWith(
        pickedFiles: state.pickedFiles
            .where((item) => item.id != pickedVideo.id)
            .toList(),
      ),
    );
  }

  void clearSelected() {
    emit(
      state.copyWith(
        pickedFiles: [],
      ),
    );
  }
}
