import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    // Initialize loading state
    safeEmit(state.copyWith(isLoading: true, currentPage: 0));

    // Handle custom album if provided
    if (hasCustomAlbum && !customAlbum.isEmpty()) {
      safeEmit(state.copyWith(currentAlubm: customAlbum, hasCustomAlbum: true));
    }

    // Fetch and filter albums
    final albums = await _fetchAndFilterAlbums(sortFunction);
    if (albums.isEmpty) {
      safeEmit(state.copyWith(isLoading: false));
      return;
    }

    // Get the target album
    final targetAlbum = _getTargetAlbum(albums, album);
    if (targetAlbum == null) {
      safeEmit(state.copyWith(isLoading: false));
      return;
    }

    // Fetch media content
    debugPrint("Fetching page ${state.currentPage + 1} for ${album?.name}");
    final mediaContent = await _fetchMediaContent(targetAlbum, album, pageSize);

    if (mediaContent.common.isEmpty) {
      safeEmit(state.copyWith(isLoading: false));
      return;
    }

    if (isClosed) return;

    // Update state with fetched data
    final filteredAlbums = await filterAlbum(albums, merge: false);
    safeEmit(
      state.copyWith(
        albums: album != null ? state.albums : filteredAlbums,
        media: mediaContent,
        currentPage: state.currentPage + 1,
        isLoading: false,
        pageSize: pageSize,
        hasReachedEndCommon:
            mediaContent.isCommonEnd(pageSize, MediaType.common),
      ),
    );
  }

// Helper method: Fetch albums and filter out empty ones
  Future<List<AssetPathEntity>> _fetchAndFilterAlbums(
    int Function(AssetPathEntity, AssetPathEntity)? sortFunction,
  ) async {
    final allAlbums =
        await PhotoManager.getAssetPathList(type: RequestType.common);

    final nonEmptyAlbums = <AssetPathEntity>[];
    for (final album in allAlbums) {
      final count = await album.assetCountAsync;
      if (count > 0) {
        nonEmptyAlbums.add(album);
      }
    }

    if (sortFunction != null) {
      nonEmptyAlbums.sort(sortFunction);
    }

    return nonEmptyAlbums;
  }

// Helper method: Get the target album to load media from
  AssetPathEntity? _getTargetAlbum(
    List<AssetPathEntity> albums,
    MediaAlbum? requestedAlbum,
  ) {
    if (requestedAlbum == null) {
      return albums.isNotEmpty ? albums[0] : null;
    }

    return albums.firstWhereOrNull(
      (e) => e.name == requestedAlbum.name && e.id == requestedAlbum.id,
    );
  }

// Helper method: Fetch media content from the target album
  Future<MediaContent> _fetchMediaContent(
    AssetPathEntity targetAlbum,
    MediaAlbum? album,
    int pageSize,
  ) async {
    final assets = await targetAlbum.getAssetListPaged(page: 0, size: pageSize);

    return MediaContent(
      id: album?.id ?? targetAlbum.id,
      name: album?.name ?? targetAlbum.name,
      common: assets,
    );
  }

  Future<void> loadMoreMedia({int pageSize = 40}) async {
    if (state.hasReachedEndCommon) return;
    safeEmit(state.copyWith(isLoading: true, isPaginating: true));

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
    );

    AssetPathEntity? currentAlbum = albums.firstWhereOrNull(
      (album) => album.name == state.media.name && album.id == state.media.id,
    );

    if (currentAlbum == null) {
      safeEmit(state.copyWith(
        isLoading: false,
        isPaginating: false,
        hasReachedEndCommon: true,
      ));
      return;
    }
    debugPrint("Fetching page ${state.currentPage + 1} for $currentAlbum");
    var allMedia = await currentAlbum.getAssetListPaged(
      page: state.currentPage,
      size: pageSize,
    );

    var mediaContent = MediaContent(
        id: state.media.id, common: allMedia, name: state.media.name);

    safeEmit(
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

    safeEmit(state.copyWith(
      media: MediaContent.initial,
      currentPage: 0,
      hasReachedEndCommon: false,
      currentAlubm: singleAlbum,
    ));

    loadMedia(pageSize: state.pageSize, album: singleAlbum);
  }
}

extension CubitExt<T> on Cubit<T> {
  void safeEmit(T state) {
    if (!isClosed) {
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      emit(state);
    }
  }
}
