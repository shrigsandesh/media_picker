import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:media_picker/src/utils/helpers.dart';
import 'package:media_picker/src/utils/utils.dart';
import 'package:collection/collection.dart';

import 'package:photo_manager/photo_manager.dart';

part 'media_picker_state.dart';

class MediaPickerCubit extends Cubit<MediaPickerState> {
  MediaPickerCubit() : super(const MediaPickerState());

  void loadMedia(
      [List<MediaType> mediaType = const [], int pageSize = 40]) async {
    emit(state.copyWith(isLoading: true));

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: determineMediaType(mediaType));

    final filterdAlbums = await filterAlbum(albums, merge: false);

    if (albums.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }
    var allMedia = await albums[0]
        .getAssetListPaged(page: state.currentPage, size: pageSize);
    var mediaContent = MediaContent.fromAssetEntity(allMedia, albums[0].name);

    emit(state.copyWith(
        albums: filterdAlbums,
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

    AssetPathEntity? currentAlbum = albums.firstWhereOrNull(
      (album) => album.name == state.media.name,
    );

    if (currentAlbum == null) {
      emit(state.copyWith(
        isLoading: false,
        isPaginating: false,
        hasReachedEndPhotos:
            type == MediaType.image ? true : state.hasReachedEndPhotos,
        hasReachedEndVideos:
            type == MediaType.video ? true : state.hasReachedEndVideos,
      ));
      return;
    }

    var allMedia = await currentAlbum.getAssetListPaged(
      page: state.currentPage,
      size: pageSize,
    );

    var mediaContent = MediaContent.fromAssetEntity(allMedia, state.media.name);
    final bool isVideoEnd = type == MediaType.video &&
        (mediaContent.videoSize < pageSize || allMedia.isEmpty);
    final bool isPhotoEnd = type == MediaType.image &&
        (mediaContent.photoSize < pageSize || allMedia.isEmpty);

    emit(
      state.copyWith(
          media: mediaContent.copyWith(
            photos: [...state.media.photos, ...mediaContent.photos],
            videos: [...state.media.videos, ...mediaContent.videos],
            common: [...state.media.common, ...mediaContent.common],
          ),
          hasReachedEndPhotos: isPhotoEnd ? true : state.hasReachedEndPhotos,
          hasReachedEndVideos: isVideoEnd ? true : state.hasReachedEndVideos,
          currentPage: state.currentPage + 1,
          isLoading: false,
          isPaginating: false),
    );
  }

  bool _shouldStopLoading(MediaType type) {
    return (type == MediaType.image && state.hasReachedEndPhotos) ||
        (type == MediaType.video && state.hasReachedEndVideos) ||
        (type == MediaType.common &&
            state.hasReachedEndPhotos &&
            state.hasReachedEndVideos);
  }

  void changeAlbum(MediaAlbum singleAlbum, [int pageSize = 40]) async {
    if (singleAlbum.name == state.media.name &&
        singleAlbum.name.toLowerCase().contains('recent')) {
      return;
    }
    emit(state.copyWith(isLoading: true));
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();

    AssetPathEntity? currentAlbum = albums.firstWhere(
      (album) => album.name == singleAlbum.name && singleAlbum.id == album.id,
    );

    emit(state.copyWith(currentPage: 0));
    var allMedia = await currentAlbum.getAssetListPaged(
      page: 0,
      size: pageSize,
    );

    if (allMedia.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        hasReachedEndPhotos: state.currentMediaTye == MediaType.image
            ? true
            : state.hasReachedEndPhotos,
        hasReachedEndVideos: state.currentMediaTye == MediaType.video
            ? true
            : state.hasReachedEndVideos,
      ));
      return;
    }

    var mediaContent = MediaContent.fromAssetEntity(allMedia, singleAlbum.name);
    emit(
      state.copyWith(
        media: mediaContent,
        isLoading: false,
        currentPage: state.currentPage + 1,
        hasReachedEndPhotos: (mediaContent.photoSize < pageSize &&
                state.currentMediaTye == MediaType.image) ||
            mediaContent.photos.isEmpty,
        hasReachedEndVideos: (mediaContent.videoSize < pageSize &&
                state.currentMediaTye == MediaType.video) ||
            mediaContent.videos.isEmpty,
      ),
    );
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
