import 'package:flutter/material.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:photo_manager/photo_manager.dart';

typedef PickedMediaCallback = void Function(List<AssetEntity> assetEntity);
typedef AlbumDropdownButtonBuilder = Widget Function(
  bool isEnabled,
  String name,
  bool isExpanded,
);

typedef AlbumTileBuilder = Widget Function(
  BuildContext context,
  MediaAlbum album,
);

typedef MediaGridBuilder = Widget Function(
  BuildContext context,
);

typedef SortFunction = int Function(AssetPathEntity, AssetPathEntity);

typedef VideoIconBuilder = Widget Function(BuildContext context, int duration);

typedef LimitedPermissionBottomBuilder = Widget Function(BuildContext context);
