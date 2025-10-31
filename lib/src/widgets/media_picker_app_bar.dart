import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/constants/typedefs.dart';

class MediaAppBar extends StatefulWidget {
  const MediaAppBar({
    super.key,
    required this.mediaAlbum,
    required this.onChanged,
    this.tabBarBackgroundColor,
    this.customAlbum,
    this.tabDecoration,
    this.tabBuilder,
  });

  final List<MediaAlbum> mediaAlbum;
  final Function(MediaAlbum) onChanged;
  final Color? tabBarBackgroundColor;

  final List<MediaAlbum>? customAlbum;

  final TabDecoration? tabDecoration;

  /// Allows custom rendering of tabs
  final CustomTabBuilder? tabBuilder;

  @override
  State<MediaAppBar> createState() => _MediaAppBarState();
}

class _MediaAppBarState extends State<MediaAppBar>
    with TickerProviderStateMixin {
  late TabController _tabController;

  List<MediaAlbum> get _albums {
    // Fixed the logic: check if customAlbum is not null AND not empty
    if (widget.customAlbum != null && widget.customAlbum!.isNotEmpty) {
      return [...widget.customAlbum!, ...widget.mediaAlbum];
    }
    return widget.mediaAlbum;
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _albums.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      widget.onChanged(_albums[_tabController.index]);
    }
  }

  @override
  void didUpdateWidget(covariant MediaAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Use the same logic as the getter for consistency
    final newAlbums = _albums;

    // Only recreate TabController if the length actually changed
    if (newAlbums.length != _tabController.length) {
      _tabController.removeListener(_onTabChanged);
      _tabController.dispose();
      _tabController = TabController(length: newAlbums.length, vsync: this);
      _tabController.addListener(_onTabChanged);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deco = widget.tabDecoration;

    return Container(
      color: widget.tabBarBackgroundColor ?? Colors.transparent,
      child: TabBar(
        controller: _tabController,
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

        tabs: _albums.asMap().entries.map((entry) {
          final index = entry.key;
          final album = entry.value;
          final isSelected = _tabController.index == index;

          // Use custom builder if provided
          if (widget.tabBuilder != null) {
            return widget.tabBuilder!(context, album, isSelected);
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
