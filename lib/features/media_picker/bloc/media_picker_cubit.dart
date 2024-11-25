import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:media_picker/core/models/media_data.dart';
import 'package:photo_manager/photo_manager.dart';

part 'media_picker_cubit.freezed.dart';
part 'media_picker_state.dart';

@injectable
class MediaPickerCubit extends Cubit<MediaPickerState> {
  MediaPickerCubit() : super(const MediaPickerState());

  void loadMedia() async {
    emit(state.copyWith(isLoading: true));
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
    albums.toSet().toList();

    // Fetch album details (names, sizes, thumbnails)
    List<MediaAlbum> mediaAlbums = await Future.wait(albums.map((album) async {
      String name = album.name;
      int size = await album.assetCountAsync;
      AssetEntity? thumbnail =
          (await album.getAssetListRange(start: 0, end: 1)).firstOrNull;

      return MediaAlbum(name: name, size: size, thumbnail: thumbnail);
    }));

    // Merge albums with the same name (case insensitive)
    Map<String, MediaAlbum> mergedAlbumsMap = {};

    for (var album in mediaAlbums) {
      String lowerCaseName = album.name.toLowerCase();

      if (mergedAlbumsMap.containsKey(lowerCaseName)) {
        // Merge size and keep the thumbnail of the first occurrence
        MediaAlbum existingAlbum = mergedAlbumsMap[lowerCaseName]!;
        mergedAlbumsMap[lowerCaseName] = MediaAlbum(
          name: existingAlbum.name, // Keep original case from the first entry
          size: existingAlbum.size + album.size,
          thumbnail: existingAlbum.thumbnail ?? album.thumbnail,
        );
      } else {
        // Add new album to the map
        mergedAlbumsMap[lowerCaseName] = album;
      }
    }

// Convert the map back to a list
    List<MediaAlbum> mergedAlbums = mergedAlbumsMap.values.toList();

    int end = await albums[0].assetCountAsync;
    var allMedia = await albums[0].getAssetListRange(start: 0, end: end);

    var mediaContent = MediaContent.fromAssetEntity(allMedia, albums[0].name);

    emit(state.copyWith(
        albums: mergedAlbums, media: mediaContent, isLoading: false));
  }

  void changeAlbum(String albumName) async {
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
