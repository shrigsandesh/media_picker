import 'package:flutter/material.dart';
import 'package:media_picker/src/media_picker_page.dart';
import 'package:media_picker/src/utils/page_transition.dart';
import 'package:photo_manager/photo_manager.dart';

Future<void> showMediaPicker(
  BuildContext context,
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
      mediaPickerTransition,
) async {
  await Permission.requestPermission().then((granted) {
    if (granted) {
      if (!context.mounted) return;
      Navigator.of(context)
          .push(createRoute(mediaPickerTransition, const MediaPickerPage()));
    }
  });
}

class Permission {
  static Future<bool> requestPermission() async {
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();

    return permission.isAuth;
  }
}
