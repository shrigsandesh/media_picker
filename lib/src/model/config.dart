import 'package:flutter/gestures.dart';
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
  final bool isScrollable;
  final TabAlignment tabAlignment;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? labelPadding;
  final Color? indicatorColor;
  final Decoration? indicator;
  final TabBarIndicatorSize? indicatorSize;
  final EdgeInsetsGeometry? indicatorPadding;
  final Color? dividerColor;
  final Color? overlayColor;
  final WidgetStateProperty<Color?>? overlayColorProperty;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final MouseCursor? mouseCursor;
  final BorderRadius? splashBorderRadius;
  final InteractiveInkFeatureFactory? splashFactory;
  final double? splashBorderWidth;
  final bool? enableFeedback;
  final DragStartBehavior? dragStartBehavior;
  final ScrollPhysics? physics;
  final double? tabHeight;
  final double? dividerHeight;
  final bool? automaticIndicatorColorAdjustment;

  const TabDecoration({
    this.isScrollable = true,
    this.tabAlignment = TabAlignment.start,
    this.height,
    this.padding,
    this.labelPadding,
    this.indicatorColor,
    this.indicator,
    this.indicatorSize,
    this.indicatorPadding,
    this.dividerColor,
    this.overlayColor,
    this.overlayColorProperty,
    this.labelColor,
    this.unselectedLabelColor,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.mouseCursor,
    this.splashBorderRadius,
    this.splashFactory,
    this.splashBorderWidth,
    this.enableFeedback,
    this.dragStartBehavior,
    this.physics,
    this.tabHeight,
    this.dividerHeight,
    this.automaticIndicatorColorAdjustment,
  });
}
