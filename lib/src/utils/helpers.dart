import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:photo_manager/photo_manager.dart';

RequestType getRequestType(MediaType mediaType) {
  switch (mediaType) {
    case MediaType.common:
      return RequestType.common;
    case MediaType.video:
      return RequestType.video;
    case MediaType.image:
      return RequestType.image;
    default:
      throw ArgumentError('Unsupported MediaType: $mediaType');
  }
}

Future<List<MediaAlbum>> filterAlbum(List<AssetPathEntity> albums) async {
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

  return mergedAlbums;
}
