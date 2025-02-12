import 'package:flutter/material.dart';
import 'package:media_picker/src/constants/enums.dart';
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/media_picker_wrapper.dart';
import 'package:media_picker/src/model/styles.dart';
import 'package:media_picker/src/utils/page_transition.dart';
import 'package:photo_manager/photo_manager.dart';

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
  int? pageSize,
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
          MediaPickerPageWrapper(
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
            pageSize: pageSize ?? 40,
          ),
        ),
      );
    } else {
      throw Exception("No permission allowed");
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
