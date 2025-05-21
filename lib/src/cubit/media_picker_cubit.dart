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

  Future<void> loadMedia({
    int pageSize = kPageSize,
    MediaAlbum? album,
    int Function(AssetPathEntity, AssetPathEntity)? sortFunction,
    bool hasCustomAlbum = false,
    MediaAlbum? customAlbum,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      currentPage: 0,
    ));
    if (hasCustomAlbum) {
      emit(state.copyWith(currentAlubm: customAlbum, hasCustomAlbum: true));
    }
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
    );

    // Filter out empty albums
    List<AssetPathEntity> filteredAlbums = [];
    for (final album in albums) {
      int count = await album.assetCountAsync;
      if (count > 0) {
        filteredAlbums.add(album);
      }
    }
    albums = filteredAlbums;

    if (sortFunction != null) {
      albums.sort(sortFunction);
    }

    final filteredAlbumsFinal = await filterAlbum(albums, merge: false);

    if (albums.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    List<AssetEntity> common = [];
    List<AssetPathEntity> tempAlbum = [];

    tempAlbum = albums;
    if (album != null) {
      tempAlbum = tempAlbum
          .where((e) => e.name == album.name && e.id == album.id)
          .toList();
    }
    if (tempAlbum.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }
    common = await tempAlbum[0].getAssetListPaged(
      page: 0,
      size: pageSize,
    );

    final mediaContent = MediaContent(
      name:
          album?.name ?? (tempAlbum.isNotEmpty ? tempAlbum[0].name : 'Recent'),
      common: common,
      photos: const [],
      videos: const [],
    );

    if (mediaContent.common.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    emit(
      state.copyWith(
        albums: album != null ? state.albums : filteredAlbumsFinal,
        media: mediaContent,
        currentPage: state.currentPage + 1,
        isLoading: false,
        pageSize: pageSize,
        hasReachedEndCommon:
            mediaContent.isCommonEnd(pageSize, MediaType.common),
      ),
    );
  }

  Future<void> loadMoreMedia({int pageSize = 40}) async {
    if (state.hasReachedEndCommon) return;
    emit(state.copyWith(isLoading: true, isPaginating: true));

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
    );

    AssetPathEntity? currentAlbum = albums.firstWhereOrNull(
      (album) => album.name == state.media.name,
    );

    if (currentAlbum == null) {
      emit(state.copyWith(
        isLoading: false,
        isPaginating: false,
        hasReachedEndCommon: true,
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
          common: [...state.media.common, ...mediaContent.common],
        ),
        hasReachedEndCommon:
            mediaContent.isCommonEnd(pageSize, MediaType.common)
                ? true
                : state.hasReachedEndCommon,
        currentPage: state.currentPage + 1,
        isLoading: false,
        isPaginating: false,
      ),
    );
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
      hasReachedEndCommon: false,
      currentAlubm: singleAlbum,
    ));

    loadMedia(pageSize: state.pageSize, album: singleAlbum);
  }
}
