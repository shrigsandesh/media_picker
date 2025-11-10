import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/media_picker.dart' hide MediaContent;
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/widgets/media_content.dart';

class MediaPickerPage extends StatefulWidget {
  const MediaPickerPage(
      {super.key,
      this.scaffoldBackgroundColor,
      this.tabBackgroundColor,
      required this.onMediaPicked,
      this.thumbnailBorderRadius,
      this.loading,
      this.thumbnailShimmer,
      required this.popWhenSingleMediaSelected,
      this.mediaGridPadding,
      required this.pageSize,
      this.crossAxisCount,
      required this.crossAxisSpacing,
      required this.mainAxisSpacing,
      this.onClose,
      this.limitedPermissionBuilder,
      required this.permissionState,
      this.assetGrouper,
      this.groupDateBuilder,
      this.customAlbumConfigs,
      this.tabBuilder,
      this.tabDecoration,
      this.appBar,
      this.hourGroupSpacing,
      this.mediaStackedWidgetsBuilder,
      this.initialTabIndex});

  final Color? scaffoldBackgroundColor;
  final Color? tabBackgroundColor;
  final PickedMediaCallback onMediaPicked;
  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridPadding;

  final Widget? loading;
  final Widget? thumbnailShimmer;
  final bool popWhenSingleMediaSelected;

  final int pageSize;
  final int? crossAxisCount;

  final MediaStackedWidgetsBuilder? mediaStackedWidgetsBuilder;

  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final VoidCallback? onClose;
  final LimitedPermissionBottomBuilder? limitedPermissionBuilder;
  final PermissionState permissionState;
  final AssetGrouperCallback? assetGrouper;
  final AssetsGroupDateBuilder? groupDateBuilder;
  final List<CustomAlbumConfig>? customAlbumConfigs;
  final CustomTabBuilder? tabBuilder;
  final TabDecoration? tabDecoration;
  final AppBar? appBar;
  final double? hourGroupSpacing;
  final int? initialTabIndex;
  @override
  State<MediaPickerPage> createState() => _MediaPickerPageState();
}

class _MediaPickerPageState extends State<MediaPickerPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<MediaAlbum> _currentAlbums = [];
  bool _initialIndexApplied = false;

  @override
  void initState() {
    super.initState();

    // Start with custom albums if available, else an empty list
    _currentAlbums = _initialAlbums;
    _initTabController();
  }

  /// Returns custom albums first (for early display)
  List<MediaAlbum> get _initialAlbums {
    final custom =
        widget.customAlbumConfigs?.map((e) => e.album).toList() ?? [];
    return custom;
  }

  /// Returns merged list when full albums become available (from Cubit)
  List<MediaAlbum> _mergedAlbums(BuildContext context, MediaPickerState state) {
    final custom =
        widget.customAlbumConfigs?.map((e) => e.album).toList() ?? [];
    final fetched = state.albums;
    return [...custom, ...fetched];
  }

  void _initTabController({int? initialIndex}) {
    final validIndex =
        _getSafeInitialIndex(initialIndex ?? widget.initialTabIndex);
    _tabController = TabController(
      initialIndex: validIndex,
      length: _currentAlbums.isEmpty ? 1 : _currentAlbums.length,
      vsync: this,
    )..addListener(_onTabChanged);

    // Manually trigger onChanged once a valid tab exists
    if (_currentAlbums.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onTabChanged();
      });
    }
  }

  void _updateTabController(List<MediaAlbum> newAlbums) {
    if (listEquals(newAlbums, _currentAlbums)) return;

    final previousIndex = _tabController.index;
    _currentAlbums = newAlbums;

    // Calculate the proper index to use
    int nextIndex = previousIndex;

    // If we haven't yet applied the desired initial index and it's now valid, use it
    if (!_initialIndexApplied &&
        widget.initialTabIndex != null &&
        widget.initialTabIndex! < _currentAlbums.length) {
      nextIndex = widget.initialTabIndex!;
      _initialIndexApplied = true; // prevent re-applying
    }

    // Clamp just in case
    nextIndex = nextIndex.clamp(0, _currentAlbums.length - 1);

    // Rebuild controller
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();

    _initTabController(initialIndex: nextIndex);

    setState(() {});

    // ✅ If we auto-moved to a different tab (like newly available index),
    // trigger the album change manually
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onTabChanged();
    });
  }

  void _onTabChanged() {
    if (_currentAlbums.isEmpty) return;
    if (_tabController.indexIsChanging) return;
    final index = _tabController.index;
    if (index < _currentAlbums.length) {
      context
          .read<MediaPickerCubit>()
          .changeAlbum(_currentAlbums[index], widget.pageSize);
    }
  }

  int _getSafeInitialIndex(int? index) {
    final count = _currentAlbums.length;
    if (count == 0) return 0;
    if (index == null || index < 0) return 0;
    if (index >= count) return count - 1;
    return index;
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MediaPickerCubit, MediaPickerState>(
      listenWhen: (p, c) => !listEquals(p.albums, c.albums),
      listener: (context, state) {
        final newAlbums = _mergedAlbums(context, state);
        _updateTabController(newAlbums);
      },
      builder: (context, state) {
        return Scaffold(
          appBar: widget.appBar,
          backgroundColor: widget.scaffoldBackgroundColor,
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight - 8),
                  child: Column(
                    children: [
                      if (widget.permissionState == PermissionState.limited &&
                          widget.limitedPermissionBuilder != null)
                        widget.limitedPermissionBuilder!(context),
                      Expanded(
                        child: MediaContent(
                          customAlbumConfigs: widget.customAlbumConfigs,
                          thumbnailBorderRadius: widget.thumbnailBorderRadius,
                          onSingleFileSelection: (media) {
                            widget.onMediaPicked([media]);
                            if (widget.popWhenSingleMediaSelected) {
                              Navigator.of(context).pop();
                            }
                          },
                          loading: widget.loading,
                          thumbnailShimmer: widget.thumbnailShimmer,
                          mediaGridPadding: widget.mediaGridPadding,
                          pageSize: widget.pageSize,
                          crossAxisCount: widget.crossAxisCount,
                          crossAxisSpacing: widget.crossAxisSpacing,
                          mainAxisSpacing: widget.mainAxisSpacing,
                          assetGrouper: widget.assetGrouper,
                          groupDateBuilder: widget.groupDateBuilder,
                          hourGroupSpacing: widget.hourGroupSpacing,
                          mediaStackedWidgets:
                              widget.mediaStackedWidgetsBuilder,
                        ),
                      ),
                    ],
                  ),
                ),
                MediaAppBar(
                  allAlbums: _currentAlbums,
                  tabBarBackgroundColor: widget.tabBackgroundColor,
                  tabBuilder: widget.tabBuilder,
                  tabDecoration: widget.tabDecoration,
                  initialTabIndex: widget.initialTabIndex,
                  tabController: _tabController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
