import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/constants/enums.dart';
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/model/styles.dart';
import 'package:media_picker/src/utils/helpers.dart';

import 'package:photo_manager/photo_manager.dart';
import 'package:media_picker/src/widgets/widgets_.dart';

class MediaPickerPage extends StatefulWidget {
  const MediaPickerPage({
    super.key,
    required this.allowMultiple,
    this.tabBarDecoration,
    required this.mediaTypes,
    this.scaffoldBackgroundColor,
    this.dropdownColor,
    this.pickedMediaBottomSheet,
    this.albumTileBuilder,
    required this.onMediaPicked,
    this.thumbnailBorderRadius,
    this.mediaGridMargin,
    this.loading,
    this.thumbnailShimmer,
    this.checkedIconColor,
    required this.popWhenSingleMediaSelected,
    this.contentPadding,
    this.albumDropdownButtonBuilder,
    required this.pageSize,
    this.crossAxisCount,
    this.dropdownButtonColor,
  });

  final bool allowMultiple;
  final TabBarDecoration? tabBarDecoration;
  final List<MediaType> mediaTypes;
  final Color? scaffoldBackgroundColor;
  final Color? dropdownColor;
  final PickedMediaCallback onMediaPicked;
  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridMargin;
  final EdgeInsetsGeometry? contentPadding;

  final Widget? loading;
  final Widget? thumbnailShimmer;
  final Color? checkedIconColor;
  final bool popWhenSingleMediaSelected;

  final PickedMediaBottomSheetBuilder? pickedMediaBottomSheet;
  final AlbumTileBuilder? albumTileBuilder;
  final AlbumDropdownButtonBuilder? albumDropdownButtonBuilder;

  final int pageSize;
  final int? crossAxisCount;
  final Color? dropdownButtonColor;

  @override
  State<MediaPickerPage> createState() => _MediaPickerPageState();
}

class _MediaPickerPageState extends State<MediaPickerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.mediaTypes.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only set up the listener once
    if (!_isInitialized) {
      _tabController.addListener(() {
        if (!_tabController.indexIsChanging) {
          context
              .read<MediaPickerCubit>()
              .changeMediaType(widget.mediaTypes[_tabController.index]);
        }
      });
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            MediaContent(
              tabController: _tabController,
              mediaTypes: widget.mediaTypes,
              tabBarDecoration: widget.tabBarDecoration,
              allowMultiple: widget.allowMultiple,
              thumbnailBorderRadius: widget.thumbnailBorderRadius,
              mediaGridMargin: widget.mediaGridMargin,
              onSingleFileSelection: (media) {
                widget.onMediaPicked([media]);
                if (widget.popWhenSingleMediaSelected) {
                  Navigator.of(context).pop();
                }
              },
              loading: widget.loading,
              thumbnailShimmer: widget.thumbnailShimmer,
              checkedIconColor: widget.checkedIconColor,
              contentPadding: widget.contentPadding,
              pageSize: widget.pageSize,
              crossAxisCount: widget.crossAxisCount,
            ),
            Positioned(
              bottom: 0,
              child: SelectedMediasBottomSheet(
                bottomSheet: widget.pickedMediaBottomSheet,
                pickedMediaCallback: widget.onMediaPicked,
              ),
            ),
            MediaPickerAppBarSection(
              albumDropdownColor: widget.dropdownColor,
              albumTile: widget.albumTileBuilder,
              albumButtonBuilder: widget.albumDropdownButtonBuilder,
              pageSize: widget.pageSize,
              dropdownButtonColor: widget.dropdownButtonColor,
            ),
          ],
        ),
      ),
    );
  }
}

class MediaContent extends StatelessWidget {
  const MediaContent({
    super.key,
    required this.tabController,
    required this.mediaTypes,
    required this.tabBarDecoration,
    required this.allowMultiple,
    this.thumbnailBorderRadius,
    this.mediaGridMargin,
    this.onSingleFileSelection,
    this.loading,
    this.thumbnailShimmer,
    this.checkedIconColor,
    this.contentPadding,
    required this.pageSize,
    this.crossAxisCount,
  });

  final TabController tabController;
  final List<MediaType> mediaTypes;
  final TabBarDecoration? tabBarDecoration;
  final bool allowMultiple;
  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridMargin;
  final EdgeInsetsGeometry? contentPadding;
  final Function(AssetEntity)? onSingleFileSelection;
  final Widget? loading;
  final Widget? thumbnailShimmer;
  final Color? checkedIconColor;

  final int pageSize;
  final int? crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight - 8),
      child: Column(
        children: [
          if (mediaTypes.length > 1)
            MediaTabBar(
              tabController: tabController,
              mediaTypes: mediaTypes,
              tabBarDecoration: tabBarDecoration,
            ),
          MediaTabContent(
            tabController: tabController,
            mediaTypes: mediaTypes,
            allowMultiple: allowMultiple,
            thumbnailBorderRadius: thumbnailBorderRadius,
            mediaGridMargin: mediaGridMargin,
            onSingleFileSelection: onSingleFileSelection,
            loading: loading,
            thumbnailShimmer: thumbnailShimmer,
            checkedIconColor: checkedIconColor,
            contentPadding: contentPadding,
            pageSize: pageSize,
            crossAxisCount: crossAxisCount,
          ),
        ],
      ),
    );
  }
}

class MediaTabBar extends StatelessWidget {
  const MediaTabBar({
    super.key,
    required this.tabController,
    required this.mediaTypes,
    required this.tabBarDecoration,
  });

  final TabController tabController;
  final List<MediaType> mediaTypes;
  final TabBarDecoration? tabBarDecoration;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: tabBarDecoration?.backgroundColor ?? Colors.white,
      child: TabBar(
        controller: tabController,
        unselectedLabelStyle: tabBarDecoration?.unselectedLabelStyle ??
            const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        labelStyle: tabBarDecoration?.labelStyle ??
            const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
        indicatorSize:
            tabBarDecoration?.indicatorSize ?? TabBarIndicatorSize.tab,
        indicatorColor: tabBarDecoration?.indicatorColor ?? Colors.black,
        indicator: tabBarDecoration?.indicator,
        tabs: mediaTypes
            .map((mediaType) =>
                Tab(text: getTabTitle(mediaType, tabBarDecoration?.tabLabels)))
            .toList(),
      ),
    );
  }
}

class MediaTabContent extends StatelessWidget {
  const MediaTabContent({
    super.key,
    required this.tabController,
    required this.mediaTypes,
    required this.allowMultiple,
    this.thumbnailBorderRadius,
    this.mediaGridMargin,
    this.onSingleFileSelection,
    this.loading,
    this.thumbnailShimmer,
    this.checkedIconColor,
    this.contentPadding,
    required this.pageSize,
    this.crossAxisCount,
  });

  final TabController tabController;
  final List<MediaType> mediaTypes;
  final bool allowMultiple;
  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridMargin;
  final EdgeInsetsGeometry? contentPadding;
  final Function(AssetEntity)? onSingleFileSelection;
  final Widget? loading;
  final Widget? thumbnailShimmer;
  final Color? checkedIconColor;
  final int pageSize;
  final int? crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
      builder: (context, state) {
        if (state.isLoading && !state.isPaginating) {
          return Expanded(
            child: loading ??
                LoadingGridShimmer(
                  crossAxisCount: crossAxisCount,
                  borderRadius: thumbnailBorderRadius,
                  pageSize: pageSize,
                ),
          );
        }

        if (mediaTypes.isEmpty) {
          return Expanded(
            child: MediaGrid(
              type: MediaType.common,
              medias: state.media.common,
              name: "media",
              allowMultiple: allowMultiple,
              thumbnailBorderRadius: thumbnailBorderRadius,
              mediaGridMargin: mediaGridMargin,
              onSingleFileSelection: onSingleFileSelection,
              thumbnailShimmer: thumbnailShimmer,
              checkedIconColor: checkedIconColor,
              contentPadding: contentPadding,
              pageSize: pageSize,
              crossAxisCount: crossAxisCount,
            ),
          );
        }

        return Expanded(
          child: TabBarView(
            controller: tabController,
            children: mediaTypes
                .map(
                  (mediaType) => getTabContent(
                    mediaType: mediaType,
                    content: state.media,
                    allowMultiple: allowMultiple,
                    thumbnailBorderRadius: thumbnailBorderRadius,
                    mediaGridMargin: mediaGridMargin,
                    onSingleFileSelection: onSingleFileSelection,
                    thumbnailShimmer: thumbnailShimmer,
                    checkedIconColor: checkedIconColor,
                    contentPadding: contentPadding,
                    pageSize: pageSize,
                    crossAxisCount: crossAxisCount,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class SelectedMediasBottomSheet extends StatelessWidget {
  const SelectedMediasBottomSheet({
    super.key,
    this.bottomSheet,
    required this.pickedMediaCallback,
  });

  final Widget Function(BuildContext context, List<AssetEntity> alubms)?
      bottomSheet;
  final PickedMediaCallback pickedMediaCallback;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
      builder: (context, state) {
        if (bottomSheet != null) {
          return Container(child: bottomSheet!(context, state.pickedFiles));
        }
        if (state.pickedFiles.isEmpty) {
          return const SizedBox.shrink();
        }
        return SelectedMedias(
          pickedVideos: state.pickedFiles,
          onPicked: (assets) {
            pickedMediaCallback(assets);
          },
        );
      },
    );
  }
}

class MediaPickerAppBarSection extends StatelessWidget {
  const MediaPickerAppBarSection({
    super.key,
    this.albumDropdownColor,
    this.albumTile,
    this.albumButtonBuilder,
    required this.pageSize,
    this.dropdownButtonColor,
  });

  final Color? albumDropdownColor;
  final AlbumTileBuilder? albumTile;
  final AlbumDropdownButtonBuilder? albumButtonBuilder;
  final int pageSize;
  final Color? dropdownButtonColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
      builder: (context, state) {
        return MediaAppBar(
          onChanged: (album) =>
              context.read<MediaPickerCubit>().changeAlbum(album, pageSize),
          mediaAlbum: state.albums,
          albumDropdownColor: albumDropdownColor,
          albumTile: albumTile,
          albumButtonBuilder: albumButtonBuilder,
          dropdownButtonColor: dropdownButtonColor,
        );
      },
    );
  }
}
