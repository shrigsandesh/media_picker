import 'package:flutter/material.dart';
import 'package:media_picker/src/all_media_picker_page.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:media_picker/src/model/styles.dart';
import 'package:media_picker/src/utils/page_transition.dart';
import 'package:photo_manager/photo_manager.dart';

enum MediaType { common, image, video }

typedef PickedMediaCallback = void Function(List<AssetEntity> assetEntity);
typedef AlbumDropdownButtonBuilder = Widget Function(
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

Future<void> showMediaPicker({
  required BuildContext context,
  required PickedMediaCallback onMediaPicked,
  bool allowMultiple = false,
  Color? albumDropdownColor,
  TabBarDecoration? tabBarDecoration,
  Set<MediaType>? mediaTypes,
  Color? scaffoldBackgroundColor,
  Color? checkedIconColor,
  double? thumbnailBorderRadius,
  EdgeInsetsGeometry? mediaGridMargin,
  EdgeInsetsGeometry? contentPadding,
  Widget? loading,
  Widget? thumbnailLoader,
  bool popWhenSingleMediaSelected = true,
  PickedMediaBottomSheetBuilder? pickedMediaBottomSheetBuilder,
  AlbumTileBuilder? albumTileBuilder,
  AlbumDropdownButtonBuilder? albumDropdownButtonBuilder,
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
      transitionBuilder,
}) async {
  if (mediaTypes != null) {
    assert(mediaTypes.isNotEmpty, 'MediaTypes must not be empty.');
  }
  await Permission.requestPermission().then((granted) {
    if (granted.isAuth) {
      if (!context.mounted) return;
      Navigator.of(context).push(
        createRoute(
          transitionBuilder,
          AllMediaPickerPage(
            allowMultiple: allowMultiple,
            tabBarDecoration: tabBarDecoration,
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            mediaTypes: mediaTypes?.toList() ?? [],
            dropdownColor: albumDropdownColor,
            pickedMediaBottomSheet: pickedMediaBottomSheetBuilder,
            albumTileBuilder: albumTileBuilder,
            onMediaPicked: onMediaPicked,
            thumbnailBorderRadius: thumbnailBorderRadius,
            mediaGridMargin: mediaGridMargin,
            loading: loading,
            thumbnailShimmer: thumbnailLoader,
            checkedIconColor: checkedIconColor,
            popWhenSingleMediaSelected: popWhenSingleMediaSelected,
            contentPadding: contentPadding,
            albumDropdownButtonBuilder: albumDropdownButtonBuilder,
          ),
        ),
      );
    }
  });
}

class Permission {
  static Future<PermissionState> requestPermission() async {
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();

    return permission;
  }
}
