import 'package:equatable/equatable.dart';
import 'package:media_picker/src/constants/enums.dart';
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

  const MediaContent({
    required this.name,
    required this.common,
  });

  int get commonSize => common.length;

  factory MediaContent.fromAssetEntity(List<AssetEntity> list, name) {
    return MediaContent(
      name: name,
      common: list
          .where((e) => e.type == AssetType.video || e.type == AssetType.image)
          .toList(),
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
    );
  }

  static const initial = MediaContent(
    name: " ",
    common: [],
  );

  @override
  List<Object> get props => [common];

  @override
  bool get stringify => true;
}

extension MediaContentExtensions on MediaContent {
  bool isCommonEnd(int pageSize, MediaType type) {
    return type == MediaType.common &&
        (commonSize < pageSize || common.isEmpty);
  }
}

class MediaAlbum extends Equatable {
  final String id;
  final String name;
  final int size;
  final AssetEntity? previewAsset;

  const MediaAlbum(
      {required this.id,
      required this.name,
      required this.size,
      this.previewAsset,
      p});

  @override
  List<Object> get props => [name, size, id];

  @override
  bool get stringify => true;
}

extension MediaAlbumNullableX on MediaAlbum? {
  bool isEmpty() => this == null || this!.size == 0;
}
