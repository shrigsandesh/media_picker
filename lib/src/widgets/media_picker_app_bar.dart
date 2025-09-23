import 'package:flutter/material.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/constants/typedefs.dart';

class MediaAppBar extends StatefulWidget {
  const MediaAppBar({
    super.key,
    required this.mediaAlbum,
    required this.onChanged,
    this.albumDropdownColor,
    this.closeIcon,
    this.closeIconColor,
    this.albumNameStyle,
    this.albumCountStyle,
    this.customAlbum,
    this.onClose,
    this.trailingIcon,
    this.tabDecoration,
    this.tabBuilder,
  });

  final List<MediaAlbum> mediaAlbum;
  final Function(MediaAlbum) onChanged;
  final Color? albumDropdownColor;

  final Widget? closeIcon;
  final Color? closeIconColor;
  final TextStyle? albumNameStyle;
  final TextStyle? albumCountStyle;
  final List<MediaAlbum>? customAlbum;
  final VoidCallback? onClose;
  final Widget? trailingIcon;

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
      color: widget.albumDropdownColor ?? Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: deco?.isScrollable ?? true,
        labelStyle: deco?.selectedTextStyle ??
            const TextStyle(color: Color(0xffff8800)),
        unselectedLabelStyle: deco?.unselectedTextStyle,
        indicatorColor: deco?.indicatorColor ?? const Color(0xffff8800),
        indicatorPadding: deco?.indicatorPadding ?? EdgeInsets.zero,
        labelPadding: deco?.labelPadding,
        dividerColor: deco?.dividerColor ?? Colors.transparent,
        tabAlignment: deco?.tabAlignment ?? TabAlignment.start,
        tabs: _albums.asMap().entries.map((entry) {
          final index = entry.key;
          final album = entry.value;
          final isSelected = _tabController.index == index;

          // Use custom builder if provided
          if (widget.tabBuilder != null) {
            return Tab(
              child: widget.tabBuilder!(context, album, isSelected),
            );
          }

          // Default tab
          return Tab(
            text: "${album.name} (${album.size})",
          );
        }).toList(),
      ),
    );
  }
}
