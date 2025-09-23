import 'package:flutter/material.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/constants/typedefs.dart';

class CustomAlbumConfig {
  final MediaAlbum album;
  final MediaGridBuilder builder;

  const CustomAlbumConfig({
    required this.album,
    required this.builder,
  });
}

class TabDecoration {
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Color? indicatorColor;
  final EdgeInsetsGeometry? indicatorPadding;
  final EdgeInsetsGeometry? labelPadding;
  final TabAlignment tabAlignment;
  final Color? dividerColor;
  final bool isScrollable;

  const TabDecoration({
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.indicatorColor,
    this.indicatorPadding,
    this.labelPadding,
    this.tabAlignment = TabAlignment.start,
    this.dividerColor,
    this.isScrollable = true,
  });
}
