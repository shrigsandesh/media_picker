import 'package:flutter/material.dart';

class TabBarDecoration {
  final Color? backgroundColor;
  final TabBarIndicatorSize? indicatorSize;
  final Decoration? indicator;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final Color? indicatorColor;
  final TabLabels? tabLabels;

  const TabBarDecoration({
    this.backgroundColor,
    this.indicatorSize,
    this.indicator,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.labelPadding,
    this.indicatorColor,
    this.tabLabels,
  });
}

class TabLabels {
  final String? all;
  final String? image;
  final String? video;

  const TabLabels({
    required this.all,
    required this.image,
    required this.video,
  });
}
