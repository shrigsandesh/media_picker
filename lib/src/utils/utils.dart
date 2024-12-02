import 'package:flutter/material.dart';
import 'package:media_picker/src/all_media_picker_page.dart';
import 'package:media_picker/src/media_picker_page.dart';
import 'package:media_picker/src/utils/page_transition.dart';
import 'package:media_picker/src/utils/tab_bar_decoration.dart';
import 'package:photo_manager/photo_manager.dart';

enum MediaType { common, image, video }

typedef PickedMediaCallback = void Function(List<AssetEntity> assetEntity);

Future<void> showMediaPicker({
  required BuildContext context,
  required PickedMediaCallback pickedMedias,
  MediaType? mediaType = MediaType.common,
  bool allowMultiple = false,
  Color? albumDropdownColor,
  TabBarDecoration? tabBarDecoration,
  Widget Function(PickedMediaCallback pickedMedias)? pickedMediaWidget,
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
      transitionBuilder,
}) async {
  await Permission.requestPermission().then((granted) {
    if (granted.isAuth) {
      if (!context.mounted) return;
      switch (mediaType) {
        case MediaType.common:
          Navigator.of(context).push(
            createRoute(
              transitionBuilder,
              AllMediaPickerPage(
                allowMultiple: true,
                tabBarDecoration: tabBarDecoration,
              ),
            ),
          );
          break;
        default:
          Navigator.of(context).push(
            createRoute(
              transitionBuilder,
              MediaPickerPage(
                mediaType: mediaType!,
                pickedMedias: pickedMedias,
                pickedMediaWidget: pickedMediaWidget,
                allowMultiple: allowMultiple,
                albumDropdownColor: albumDropdownColor,
              ),
            ),
          );
      }
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
