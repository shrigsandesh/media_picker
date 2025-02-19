import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/constants/constants.dart';
import 'package:media_picker/src/constants/enums.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:media_picker/src/utils/helpers.dart';
import 'package:collection/collection.dart';
import 'package:photo_manager/photo_manager.dart';

part 'media_picker_state.dart';

class MediaPickerCubit extends Cubit<MediaPickerState> {
  MediaPickerCubit() : super(const MediaPickerState());

  void loadMedia({
    List<MediaType> mediaType = kMediaTypes,
    int pageSize = kPageSize,
    MediaAlbum? album,
    int Function(AssetPathEntity, AssetPathEntity)? sortFunction,
  }) async {
    emit(state.copyWith(isLoading: true, currentPage: 0));

    final albums = await _fetchAlbums(mediaType, sortFunction);
    if (albums.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    final mediaContent = await _fetchMediaContent(
        mediaType, albums, pageSize, album, sortFunction);
    if (mediaContent.isEmpty()) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    emit(state.copyWith(
      albums: album != null
          ? state.albums
          : await filterAlbum(albums, merge: false),
      media: mediaContent,
      currentPage: state.currentPage + 1,
      isLoading: false,
      pageSize: pageSize,
      hasReachedEndCommon: mediaContent.isCommonEnd(pageSize, MediaType.common),
      hasReachedEndPhotos: mediaContent.isPhotoEnd(pageSize, MediaType.image),
      hasReachedEndVideos: mediaContent.isVideoEnd(pageSize, MediaType.video),
    ));
  }

  Future<List<AssetPathEntity>> _fetchAlbums(List<MediaType> mediaType,
      int Function(AssetPathEntity, AssetPathEntity)? sortFunction) async {
    final albums = await PhotoManager.getAssetPathList(
        type: determineMediaType(mediaType));
    if (sortFunction != null) {
      albums.sort(sortFunction);
    }
    return albums;
  }

  Future<MediaContent> _fetchMediaContent(
      List<MediaType> mediaType,
      List<AssetPathEntity> albums,
      int pageSize,
      MediaAlbum? album,
      int Function(AssetPathEntity, AssetPathEntity)? sortFunction) async {
    List<AssetEntity> common = [], photos = [], videos = [];
    List<AssetPathEntity> tempAlbum = [];

    for (var type in mediaType) {
      tempAlbum = await _getFilteredAlbum(type, album, sortFunction);
      if (tempAlbum.isNotEmpty) {
        final assets =
            await tempAlbum.first.getAssetListPaged(page: 0, size: pageSize);
        if (type == MediaType.image) photos = assets;
        if (type == MediaType.video) videos = assets;
        if (type == MediaType.common) common = assets;
      }
    }
    return MediaContent(
      name: album?.name ??
          (tempAlbum.isNotEmpty ? tempAlbum.first.name : 'Recent'),
      common: common,
      photos: photos,
      videos: videos,
    );
  }

  Future<List<AssetPathEntity>> _getFilteredAlbum(
      MediaType type,
      MediaAlbum? album,
      int Function(AssetPathEntity, AssetPathEntity)? sortFunction) async {
    var tempAlbum = await PhotoManager.getAssetPathList(
        type: _mapMediaTypeToRequestType(type));
    if (sortFunction != null) tempAlbum.sort(sortFunction);
    if (album != null) {
      tempAlbum = tempAlbum
          .where((e) => e.name == album.name && e.id == album.id)
          .toList();
    }
    return tempAlbum;
  }

  RequestType _mapMediaTypeToRequestType(MediaType type) {
    switch (type) {
      case MediaType.image:
        return RequestType.image;
      case MediaType.video:
        return RequestType.video;
      case MediaType.common:
        return RequestType.common;
    }
  }

  void loadMoreMedia(
      {int pageSize = 40, MediaType type = MediaType.common}) async {
    if (_shouldStopLoading(type)) return;
    emit(state.copyWith(isLoading: true, isPaginating: true));

    final albums =
        await PhotoManager.getAssetPathList(type: determineMediaType([type]));
    final currentAlbum =
        albums.firstWhereOrNull((album) => album.name == state.media.name);
    if (currentAlbum == null) {
      emit(state.copyWith(
          isLoading: false,
          isPaginating: false,
          hasReachedEndCommon: type == MediaType.common));
      return;
    }

    final allMedia = await currentAlbum.getAssetListPaged(
        page: state.currentPage, size: pageSize);
    final mediaContent =
        MediaContent.fromAssetEntity(allMedia, state.media.name);

    emit(state.copyWith(
      media: mediaContent.copyWith(
        photos: [...state.media.photos, ...mediaContent.photos],
        videos: [...state.media.videos, ...mediaContent.videos],
        common: [...state.media.common, ...mediaContent.common],
      ),
      hasReachedEndCommon:
          mediaContent.isCommonEnd(pageSize, type) || state.hasReachedEndCommon,
      hasReachedEndPhotos:
          mediaContent.isPhotoEnd(pageSize, type) || state.hasReachedEndPhotos,
      hasReachedEndVideos:
          mediaContent.isVideoEnd(pageSize, type) || state.hasReachedEndVideos,
      currentPage: state.currentPage + 1,
      isLoading: false,
      isPaginating: false,
    ));
  }

  bool _shouldStopLoading(MediaType type) {
    return (type == MediaType.image && state.hasReachedEndPhotos) ||
        (type == MediaType.video && state.hasReachedEndVideos) ||
        (type == MediaType.common && state.hasReachedEndCommon);
  }

  void changeAlbum(MediaAlbum singleAlbum, [int pageSize = 40]) async {
    if (singleAlbum.name == state.media.name &&
        singleAlbum.id == state.currentAlubm.id) {
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
    if (!state.pickedFiles.contains(video)) {
      emit(state.copyWith(pickedFiles: [...state.pickedFiles, video]));
    }
  }

  void removeSelected(AssetEntity pickedVideo) {
    emit(state.copyWith(
        pickedFiles: state.pickedFiles
            .where((item) => item.id != pickedVideo.id)
            .toList()));
  }

  void clearSelected() {
    emit(state.copyWith(pickedFiles: []));
  }

  void changeMediaType(MediaType type) {
    emit(state.copyWith(currentMediaTye: type));
  }
}
