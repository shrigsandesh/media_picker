import 'package:flutter/material.dart';
import 'package:media_picker/src/model/media_config.dart';

class MediaConfigWrapper extends InheritedWidget {
  final MediaConfig data;

  const MediaConfigWrapper({
    super.key,
    required this.data,
    required super.child,
  });

  static MediaConfigWrapper? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MediaConfigWrapper>();
  }

  @override
  bool updateShouldNotify(MediaConfigWrapper oldWidget) {
    return data != oldWidget.data;
  }
}
