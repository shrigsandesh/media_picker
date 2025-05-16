import 'package:media_picker/src/model/media_model.dart';
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

extension AssetEntityListExtensions on List<AssetEntity> {
  void sortByCreateDateDescending() {
    sort(
        (a, b) => (b.createDateSecond ?? 0).compareTo(a.createDateSecond ?? 0));
  }
}
