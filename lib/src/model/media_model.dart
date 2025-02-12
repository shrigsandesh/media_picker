import 'package:equatable/equatable.dart';
import 'package:media_picker/media_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaData extends Equatable {
  final String albumName;
  final AssetEntity thumbnailAsset;
  final MediaContent media;

  const MediaData(
      {required this.media,
      required this.albumName,
      required this.thumbnailAsset});

  @override
  List<Object> get props => [media, albumName, thumbnailAsset];

  @override
  bool get stringify => true;
}

class MediaContent extends Equatable {
  final String name;
  final List<AssetEntity> common;
  final List<AssetEntity> videos;
  final List<AssetEntity> photos;

  const MediaContent({
    required this.name,
    required this.common,
    required this.videos,
    required this.photos,
  });

  int get commonSize => common.length;
  int get videoSize => videos.length;
  int get photoSize => photos.length;

  factory MediaContent.fromAssetEntity(List<AssetEntity> list, name) {
    return MediaContent(
      name: name,
      common: list
          .where((e) => e.type == AssetType.video || e.type == AssetType.image)
          .toList(),
      videos: list.where((e) => e.type == AssetType.video).toList(),
      photos: list.where((e) => e.type == AssetType.image).toList(),
    );
  }

  MediaContent copyWith({
    String? name,
    List<AssetEntity>? common,
    List<AssetEntity>? videos,
    List<AssetEntity>? photos,
  }) {
    return MediaContent(
        name: name ?? this.name,
        common: common ?? this.common,
        videos: videos ?? this.videos,
        photos: photos ?? this.photos);
  }

  static const initial = MediaContent(
    name: "Recent",
    common: [],
    videos: [],
    photos: [],
  );

  @override
  List<Object> get props => [common, videos, photos];

  @override
  bool get stringify => true;
}

extension MediaContentExtensions on MediaContent {
  bool isVideoEnd(int pageSize, MediaType type) {
    return type == MediaType.video && (videoSize < pageSize || videos.isEmpty);
  }

  bool isPhotoEnd(int pageSize, MediaType type) {
    return type == MediaType.image && (photoSize < pageSize || photos.isEmpty);
  }

  bool isCommonEnd(int pageSize, MediaType type) {
    return type == MediaType.common &&
        (commonSize < pageSize || common.isEmpty);
  }
}

class MediaAlbum extends Equatable {
  final String id;
  final String name;
  final int size;
  final AssetEntity? thumbnail;

  const MediaAlbum(
      {required this.id,
      required this.name,
      required this.size,
      this.thumbnail});

  @override
  List<Object> get props => [name, size, id];

  @override
  bool get stringify => true;
}
