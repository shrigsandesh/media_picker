import 'package:flutter/material.dart';
import 'package:media_picker/media_picker.dart';

class MediaConfig {
  final bool allowMultiple;
  final TabBarDecoration? tabBarDecoration;
  final List<MediaType> mediaTypes;
  final Color? scaffoldBackgroundColor;
  final Color? dropdownColor;
  final PickedMediaCallback pickedMedias;
  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridMargin;
  final Widget? loading;
  final Widget? thumbnailShimmer;
  final Color? checkedIconColor;

  MediaConfig(
      {required this.allowMultiple,
      required this.tabBarDecoration,
      required this.mediaTypes,
      required this.scaffoldBackgroundColor,
      required this.dropdownColor,
      required this.pickedMedias,
      required this.thumbnailBorderRadius,
      required this.mediaGridMargin,
      required this.loading,
      required this.thumbnailShimmer,
      required this.checkedIconColor});
}
