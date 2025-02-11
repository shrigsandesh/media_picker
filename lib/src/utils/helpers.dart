import 'package:flutter/material.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:media_picker/src/widgets/media_grid.dart';
import 'package:photo_manager/photo_manager.dart';

Future<List<MediaAlbum>> filterAlbum(List<AssetPathEntity> albums,
    {bool merge = true}) async {
  // Fetch album details (names, sizes, thumbnails)
  List<MediaAlbum> mediaAlbums = await Future.wait(albums.map((album) async {
    String name = album.name;
    int size = await album.assetCountAsync;
    AssetEntity? thumbnail =
        (await album.getAssetListRange(start: 0, end: 1)).firstOrNull;

    return MediaAlbum(
        id: album.id, name: name, size: size, thumbnail: thumbnail);
  }));

  if (!merge) {
    return mediaAlbums;
  }

  // Merge albums with the same name (case insensitive)
  Map<String, MediaAlbum> mergedAlbumsMap = {};

  for (var album in mediaAlbums) {
    String lowerCaseName = album.name.toLowerCase();

    if (mergedAlbumsMap.containsKey(lowerCaseName)) {
      // Merge size and keep the thumbnail of the first occurrence
      MediaAlbum existingAlbum = mergedAlbumsMap[lowerCaseName]!;
      mergedAlbumsMap[lowerCaseName] = MediaAlbum(
        id: existingAlbum.id,
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

  return mergedAlbums;
}

RequestType determineMediaType(List<MediaType> mediaTypes) {
  if (mediaTypes.isEmpty) return RequestType.common;

  final isOnlyImages =
      mediaTypes.every((mediaType) => mediaType == MediaType.image);
  final isOnlyVideos =
      mediaTypes.every((mediaType) => mediaType == MediaType.video);

  if (isOnlyImages) {
    return RequestType.image;
  } else if (isOnlyVideos) {
    return RequestType.video;
  } else {
    return RequestType.common;
  }
}

String getTabTitle(MediaType mediaType, TabLabels? tablable) {
  switch (mediaType) {
    case MediaType.common:
      return tablable?.all ?? 'All';
    case MediaType.image:
      return tablable?.image ?? "Photo";
    case MediaType.video:
      return tablable?.video ?? 'Video';
  }
}

Widget getTabContent({
  required MediaType mediaType,
  required MediaContent content,
  required bool allowMultiple,
  double? thumbnailBorderRadius,
  EdgeInsetsGeometry? mediaGridMargin,
  void Function(AssetEntity)? onSingleFileSelection,
  Widget? thumbnailShimmer,
  Color? checkedIconColor,
  final EdgeInsetsGeometry? contentPadding,
}) {
  switch (mediaType) {
    case MediaType.common:
      return MediaGrid(
        medias: content.common,
        name: "media",
        allowMultiple: allowMultiple,
        thumbnailBorderRadius: thumbnailBorderRadius,
        mediaGridMargin: mediaGridMargin,
        onSingleFileSelection: onSingleFileSelection,
        thumbnailShimmer: thumbnailShimmer,
        checkedIconColor: checkedIconColor,
        contentPadding: contentPadding,
        type: mediaType,
      );
    case MediaType.image:
      return MediaGrid(
        medias: content.photos,
        name: "photos",
        allowMultiple: allowMultiple,
        thumbnailBorderRadius: thumbnailBorderRadius,
        mediaGridMargin: mediaGridMargin,
        onSingleFileSelection: onSingleFileSelection,
        thumbnailShimmer: thumbnailShimmer,
        checkedIconColor: checkedIconColor,
        contentPadding: contentPadding,
        type: mediaType,
      );
    case MediaType.video:
      return MediaGrid(
        medias: content.videos,
        name: "video",
        allowMultiple: allowMultiple,
        thumbnailBorderRadius: thumbnailBorderRadius,
        mediaGridMargin: mediaGridMargin,
        onSingleFileSelection: onSingleFileSelection,
        thumbnailShimmer: thumbnailShimmer,
        checkedIconColor: checkedIconColor,
        contentPadding: contentPadding,
        type: mediaType,
      );
  }
}
