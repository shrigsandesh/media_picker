import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/constants/typedefs.dart';

class MediaAppBar extends StatelessWidget {
  const MediaAppBar({
    super.key,
    required this.allAlbums,
    this.tabBarBackgroundColor,
    this.tabDecoration,
    this.tabBuilder,
    this.initialTabIndex,
    required this.tabController,
  });

  final List<MediaAlbum> allAlbums;
  final Color? tabBarBackgroundColor;

  final TabDecoration? tabDecoration;

  /// Allows custom rendering of tabs
  final CustomTabBuilder? tabBuilder;
  final int? initialTabIndex;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    if (allAlbums.isEmpty) {
      return const SizedBox.shrink();
    }
    final deco = tabDecoration;

    return Container(
      color: tabBarBackgroundColor ?? Colors.transparent,
      child: TabBar(
        controller: tabController,
        // Basic layout
        isScrollable: deco?.isScrollable ?? true,
        tabAlignment: deco?.tabAlignment ?? TabAlignment.start,
        dividerHeight: deco?.dividerHeight,

        padding: deco?.padding ??
            const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 2,
            ),

        labelPadding: deco?.labelPadding,

        // Label styles
        labelColor: deco?.labelColor,
        unselectedLabelColor: deco?.unselectedLabelColor,

        labelStyle: deco?.selectedTextStyle ??
            deco?.labelStyle ??
            const TextStyle(color: Color(0xffff8800)),
        unselectedLabelStyle: deco?.unselectedTextStyle,

        // Indicator
        indicatorColor: deco?.indicatorColor ?? const Color(0xffff8800),
        indicator: deco?.indicator,
        indicatorSize: deco?.indicatorSize ?? TabBarIndicatorSize.label,
        indicatorPadding: deco?.indicatorPadding ?? EdgeInsets.zero,

        // Divider
        dividerColor: deco?.dividerColor ?? Colors.transparent,

        // Overlay & splash

        overlayColor: deco?.overlayColorProperty ??
            WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                return states.contains(WidgetState.focused)
                    ? null
                    : Colors.transparent;
              },
            ),
        splashFactory: deco?.splashFactory ?? NoSplash.splashFactory,
        splashBorderRadius:
            deco?.splashBorderRadius ?? BorderRadius.circular(50),

        // Interaction
        mouseCursor: deco?.mouseCursor,
        enableFeedback: deco?.enableFeedback,
        dragStartBehavior: deco?.dragStartBehavior ?? DragStartBehavior.start,
        physics: deco?.physics,

        // Misc
        automaticIndicatorColorAdjustment:
            deco?.automaticIndicatorColorAdjustment ?? true,

        tabs: allAlbums.mapIndexed((index, album) {
          final isSelected = tabController.index == index;

          // Use custom builder if provided
          if (tabBuilder != null) {
            return tabBuilder!(context, album, isSelected);
          }

          // Default tab
          return Tab(
            height: deco?.tabHeight,
            text: "${album.name} (${album.size})",
          );
        }).toList(),
      ),
    );
  }
}
