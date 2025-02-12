import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/constants/constants.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:media_picker/src/utils/helpers.dart';
import 'package:collection/collection.dart';

import 'package:photo_manager/photo_manager.dart';

part 'media_picker_state.dart';

class MediaPickerCubit extends Cubit<MediaPickerState> {
  MediaPickerCubit() : super(const MediaPickerState());

  void loadMedia({
    List<MediaType> mediaType = defaultMediaTypes,
    int pageSize = defaultPageSize,
    MediaAlbum? album,
    int Function(AssetPathEntity, AssetPathEntity)? sortFunction,
  }) async {
    emit(state.copyWith(isLoading: true, currentPage: 0));
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: determineMediaType(mediaType));

    if (sortFunction != null) {
      log("message");
      albums.sort(sortFunction);
    }
    log(albums.toString());

    final filterdAlbums = await filterAlbum(albums, merge: false);

    if (albums.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
      ));
      return;
    }

    MediaContent mediaContent;

    List<AssetEntity> common = [];
    List<AssetEntity> photos = [];
    List<AssetEntity> videos = [];

    if (mediaType.isEmpty) {
      var media = await albums[0].getAssetListPaged(
        page: 0,
        size: pageSize,
      );
      mediaContent = MediaContent.fromAssetEntity(media, albums[0].name);
    } else {
      List<AssetPathEntity> tempAlbum = [];
      for (var type in mediaType) {
        switch (type) {
          case MediaType.image:
            tempAlbum =
                await PhotoManager.getAssetPathList(type: RequestType.image);
            if (sortFunction != null) {
              tempAlbum.sort(sortFunction);
            }

            if (album != null) {
              tempAlbum = tempAlbum
                  .where(
                    (e) => e.name == album.name && e.id == album.id,
                  )
                  .toList();
            }
            if (tempAlbum.isEmpty) {
              break;
            }
            photos = await tempAlbum[0].getAssetListPaged(
              page: 0,
              size: pageSize,
            );
          case MediaType.video:
            tempAlbum =
                await PhotoManager.getAssetPathList(type: RequestType.video);
            if (sortFunction != null) {
              tempAlbum.sort(sortFunction);
            }

            if (album != null) {
              tempAlbum = tempAlbum
                  .where(
                    (e) => e.name == album.name && e.id == album.id,
                  )
                  .toList();
            }
            if (tempAlbum.isEmpty) {
              break;
            }
            videos = await tempAlbum[0].getAssetListPaged(
              page: 0,
              size: pageSize,
            );
            break;
          case MediaType.common:
            tempAlbum =
                await PhotoManager.getAssetPathList(type: RequestType.common);

            if (sortFunction != null) {
              tempAlbum.sort(sortFunction);
            }

            if (album != null) {
              tempAlbum = tempAlbum
                  .where(
                    (e) => e.name == album.name && e.id == album.id,
                  )
                  .toList();
            }
            if (tempAlbum.isEmpty) {
              break;
            }
            common = await tempAlbum[0].getAssetListPaged(
              page: 0,
              size: pageSize,
            );
            break;
        }
      }

      log("temp album : ${tempAlbum[0].name}");
      mediaContent = MediaContent(
        name: album?.name ??
            (tempAlbum.isNotEmpty ? tempAlbum[0].name : 'Recent'),
        common: common,
        photos: photos,
        videos: videos,
      );
    }

    if (mediaContent.common.isEmpty &&
        mediaContent.videos.isEmpty &&
        mediaContent.photos.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    emit(
      state.copyWith(
        albums: album != null ? state.albums : filterdAlbums,
        media: mediaContent,
        currentPage: state.currentPage + 1,
        isLoading: false,
        pageSize: pageSize,
      ),
    );
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
        hasReachedEndCommon:
            type == MediaType.common ? true : state.hasReachedEndCommon,
      ));
      return;
    }

    var allMedia = await currentAlbum.getAssetListPaged(
      page: state.currentPage,
      size: pageSize,
    );

    var mediaContent = MediaContent.fromAssetEntity(allMedia, state.media.name);

    emit(
      state.copyWith(
          media: mediaContent.copyWith(
            photos: [...state.media.photos, ...mediaContent.photos],
            videos: [...state.media.videos, ...mediaContent.videos],
            common: [...state.media.common, ...mediaContent.common],
          ),
          hasReachedEndPhotos: mediaContent.isPhotoEnd(pageSize, type)
              ? true
              : state.hasReachedEndPhotos,
          hasReachedEndVideos: mediaContent.isVideoEnd(pageSize, type)
              ? true
              : state.hasReachedEndVideos,
          hasReachedEndCommon: mediaContent.isCommonEnd(pageSize, type)
              ? true
              : state.hasReachedEndCommon,
          currentPage: state.currentPage + 1,
          isLoading: false,
          isPaginating: false),
    );
  }

  bool _shouldStopLoading(MediaType type) {
    return (type == MediaType.image && state.hasReachedEndPhotos) ||
        (type == MediaType.video && state.hasReachedEndVideos) ||
        (type == MediaType.common && state.hasReachedEndCommon);
  }

  void changeAlbum(MediaAlbum singleAlbum, [int pageSize = 40]) async {
    if (singleAlbum.name == state.media.name &&
        (singleAlbum.id == state.currentAlubm.id ||
            state.currentAlubm.name.toLowerCase().contains('recent'))) {
      return;
    }
    emit(state.copyWith(
      media: MediaContent.initial,
      currentPage: 0,
      hasReachedEndPhotos: false,
      hasReachedEndVideos: false,
      hasReachedEndCommon: false,
      currentAlubm: singleAlbum,
    ));

    loadMedia(pageSize: state.pageSize, album: singleAlbum);
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
      ),
    );
  }
}
