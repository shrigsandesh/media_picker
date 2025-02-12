import 'package:flutter/material.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:photo_manager/photo_manager.dart';

typedef PickedMediaCallback = void Function(List<AssetEntity> assetEntity);
typedef AlbumDropdownButtonBuilder = Widget Function(
  bool isLoading,
  String selectedAlbumName,
  bool isDropdownShown,
);

typedef PickedMediaBottomSheetBuilder = Widget Function(
  BuildContext context,
  List<AssetEntity> albums,
);

typedef AlbumTileBuilder = Widget Function(
  BuildContext context,
  MediaAlbum album,
);

typedef SortFunction = int Function(AssetPathEntity, AssetPathEntity);
