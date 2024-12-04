import 'package:flutter/material.dart';
import 'package:media_picker/src/all_media_picker_page.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:media_picker/src/model/styles.dart';
import 'package:media_picker/src/utils/page_transition.dart';
import 'package:photo_manager/photo_manager.dart';

enum MediaType { common, image, video }

typedef PickedMediaCallback = void Function(List<AssetEntity> assetEntity);

/// shows media picker page
///
/// By default, tabbar is not shown,to show tabbar provide [mediaTypes]
/// To allow multiple media to be selected set [allowMultiple] flag to true, by default it is set to false
///
/// Note: [pickedMedias] callback returns an empty list if no medias were selected.

Future<void> showMediaPicker({
  required BuildContext context,
  required PickedMediaCallback pickedMedias,
  bool allowMultiple = false,
  Color? albumDropdownColor,
  TabBarDecoration? tabBarDecoration,
  Set<MediaType>? mediaTypes,
  Color? scaffoldBackgroundColor,
  Color? checkedIconColor,
  double? thumbnailBorderRadius,
  EdgeInsetsGeometry? mediaGridMargin,
  Widget? loading,
  Widget? thumbnailShimmer,
  Widget Function(BuildContext context, List<AssetEntity> albums)?
      pickedMediaBottomSheet,
  Widget Function(BuildContext context, MediaAlbum album)? albumTile,
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
            pickedMediaBottomSheet: pickedMediaBottomSheet,
            albumTile: albumTile,
            pickedMedias: pickedMedias,
            thumbnailBorderRadius: thumbnailBorderRadius,
            mediaGridMargin: mediaGridMargin,
            loading: loading,
            thumbnailShimmer: thumbnailShimmer,
            checkedIconColor: checkedIconColor,
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
