import 'package:equatable/equatable.dart';
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
    name: "All",
    common: [],
    videos: [],
    photos: [],
  );

  @override
  List<Object> get props => [common, videos, photos];

  @override
  bool get stringify => true;
}

class MediaAlbum extends Equatable {
  final String name;
  final int size;
  final AssetEntity? thumbnail;

  const MediaAlbum({required this.name, required this.size, this.thumbnail});

  @override
  List<Object> get props => [name, size];

  @override
  bool get stringify => true;
}
