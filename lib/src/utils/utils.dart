import 'package:flutter/material.dart';
import 'package:media_picker/src/all_media_picker_page.dart';
import 'package:media_picker/src/media_picker_page.dart';
import 'package:media_picker/src/utils/page_transition.dart';
import 'package:photo_manager/photo_manager.dart';

enum MediaType { common, image, video }

Future<void> showMediaPicker({
  required BuildContext context,
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
      transitionBuilder,
  MediaType? mediaType = MediaType.common,
}) async {
  await Permission.requestPermission().then((granted) {
    if (granted.isAuth) {
      if (!context.mounted) return;
      switch (mediaType) {
        case MediaType.common:
          Navigator.of(context)
              .push(createRoute(transitionBuilder, const AllMediaPickerPage()));
          break;
        default:
          Navigator.of(context).push(createRoute(
              transitionBuilder, MediaPickerPage(mediaType: mediaType!)));
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
