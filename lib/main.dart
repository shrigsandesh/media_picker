import 'package:flutter/material.dart';
import 'package:media_picker/core/di/di.dart';
import 'package:media_picker/features/media_picker/pages/media_picker_page.dart';
import 'package:photo_manager/photo_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await requestPermission().then((isGranted) {
    if (isGranted) {
      runApp(const MediaPicker());
    }
  });
}

class MediaPicker extends StatelessWidget {
  const MediaPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MediaPickerPage(),
    );
  }
}

Future<bool> requestPermission() async {
  final PermissionState permission =
      await PhotoManager.requestPermissionExtend();

  return permission.isAuth;
}
