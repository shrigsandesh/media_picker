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
  final List<AssetEntity> all;
  final List<AssetEntity> videos;
  final List<AssetEntity> photos;

  const MediaContent(
      {required this.all, required this.videos, required this.photos});

  @override
  List<Object> get props => [all, videos, photos];

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
