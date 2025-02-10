import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:media_picker/src/utils/helpers.dart';
import 'package:media_picker/src/utils/utils.dart';

import 'package:photo_manager/photo_manager.dart';

part 'media_picker_state.dart';

class MediaPickerCubit extends Cubit<MediaPickerState> {
  MediaPickerCubit() : super(const MediaPickerState());

  void loadMedia(
      [List<MediaType> mediaType = const [], int pageSize = 40]) async {
    emit(state.copyWith(isLoading: true));

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: determineMediaType(mediaType));
    albums.toSet().toList();

    final mergedAlbums = await filterAlbum(albums);

    if (albums.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }
    var allMedia = await albums[0]
        .getAssetListPaged(page: state.currentPage, size: pageSize);
    var mediaContent = MediaContent.fromAssetEntity(allMedia, albums[0].name);

    emit(state.copyWith(
        albums: mergedAlbums,
        media: mediaContent,
        currentPage: state.currentPage + 1,
        isLoading: false));
  }

  void loadMoreMedia(
      {int pageSize = 40, MediaType type = MediaType.common}) async {
    if (_shouldStopLoading(type)) return;
    emit(state.copyWith(isLoading: true, isPaginating: true));

    List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: determineMediaType([type]));

    final mergedAlbums = await filterAlbum(albums);

    final int count = await albums[0].assetCountAsync;

    var allMedia = await albums[0].getAssetListPaged(
      page: state.currentPage,
      size: pageSize,
    );

    var mediaContent = MediaContent.fromAssetEntity(allMedia, albums[0].name);

    emit(state.copyWith(
        albums: mergedAlbums,
        media: mediaContent.copyWith(
          photos: [...state.media.photos, ...mediaContent.photos],
          videos: [...state.media.videos, ...mediaContent.videos],
          common: [...state.media.common, ...mediaContent.common],
        ),
        hasReachedEndPhotos: type == MediaType.image
            ? count < pageSize
            : state.hasReachedEndPhotos,
        hasReachedEndVideos: type == MediaType.video
            ? count < pageSize
            : state.hasReachedEndPhotos,
        currentPage: state.currentPage + 1,
        isLoading: false,
        isPaginating: false));
  }

  bool _shouldStopLoading(MediaType type) {
    return (type == MediaType.image && state.hasReachedEndPhotos) ||
        (type == MediaType.video && state.hasReachedEndVideos) ||
        (type == MediaType.common &&
            state.hasReachedEndPhotos &&
            state.hasReachedEndVideos);
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

  void changeMediaType(MediaType type) {
    emit(
      state.copyWith(
        currentMediaTye: type,
        isLoading: false,
      ),
    );
    switch (state.currentMediaTye) {
      case MediaType.video:
        if (state.media.videoSize < state.pageSize) {
          loadMoreMedia(type: MediaType.video);
        }

      case MediaType.image:
        if (state.media.videoSize < state.pageSize) {
          loadMoreMedia(type: MediaType.image);
        }
        break;
      default:
    }
  }
}
