import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:media_picker/src/utils/helpers.dart';

import 'package:photo_manager/photo_manager.dart';
import 'package:media_picker/src/widgets/widgets_.dart';

class AllMediaPickerPage extends StatefulWidget {
  const AllMediaPickerPage({
    super.key,
    required this.allowMultiple,
    this.tabBarDecoration,
    required this.mediaTypes,
    this.scaffoldBackgroundColor,
    this.dropdownColor,
    this.pickedMediaBottomSheet,
    this.albumTile,
    required this.onMediaPicked,
    this.thumbnailBorderRadius,
    this.mediaGridMargin,
    this.loading,
    this.thumbnailShimmer,
    this.checkedIconColor,
    required this.popWhenSingleMediaSelected,
  });

  final bool allowMultiple;
  final TabBarDecoration? tabBarDecoration;
  final List<MediaType> mediaTypes;
  final Color? scaffoldBackgroundColor;
  final Color? dropdownColor;
  final PickedMediaCallback onMediaPicked;
  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridMargin;
  final Widget? loading;
  final Widget? thumbnailShimmer;
  final Color? checkedIconColor;
  final bool popWhenSingleMediaSelected;

  final Widget Function(BuildContext context, List<AssetEntity> alubms)?
      pickedMediaBottomSheet;
  final Widget Function(BuildContext context, MediaAlbum alubms)? albumTile;

  @override
  State<AllMediaPickerPage> createState() => _AllMediaPickerPageState();
}

class _AllMediaPickerPageState extends State<AllMediaPickerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.mediaTypes.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaPickerCubit()..loadMedia(widget.mediaTypes),
      child: Scaffold(
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
                  checkedIconColor: widget.checkedIconColor),
              Positioned(
                bottom: 0,
                child: SelectedMediasBottomSheet(
                  pickedMediaBottomSheet: widget.pickedMediaBottomSheet,
                  pickedMediaCallback: widget.onMediaPicked,
                ),
              ),
              MediaPickerAppBarSection(
                albumDropdownColor: widget.dropdownColor,
                albumTile: widget.albumTile,
              ),
            ],
          ),
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
  });

  final TabController tabController;
  final List<MediaType> mediaTypes;
  final TabBarDecoration? tabBarDecoration;
  final bool allowMultiple;
  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridMargin;
  final Function(AssetEntity)? onSingleFileSelection;
  final Widget? loading;
  final Widget? thumbnailShimmer;
  final Color? checkedIconColor;

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
  });

  final TabController tabController;
  final List<MediaType> mediaTypes;
  final bool allowMultiple;
  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridMargin;
  final Function(AssetEntity)? onSingleFileSelection;
  final Widget? loading;
  final Widget? thumbnailShimmer;
  final Color? checkedIconColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Expanded(
            child: loading ??
                LoadingGridShimmer(
                  borderRadius: thumbnailBorderRadius,
                ),
          );
        }

        if (mediaTypes.isEmpty) {
          return Expanded(
            child: MediaGrid(
              medias: state.media.common,
              name: "media",
              allowMultiple: allowMultiple,
              thumbnailBorderRadius: thumbnailBorderRadius,
              mediaGridMargin: mediaGridMargin,
              onSingleFileSelection: onSingleFileSelection,
              thumbnailShimmer: thumbnailShimmer,
              checkedIconColor: checkedIconColor,
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
    this.pickedMediaBottomSheet,
    required this.pickedMediaCallback,
  });

  final Widget Function(BuildContext context, List<AssetEntity> alubms)?
      pickedMediaBottomSheet;
  final PickedMediaCallback pickedMediaCallback;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
      builder: (context, state) {
        if (pickedMediaBottomSheet != null) {
          return Container(
              child: pickedMediaBottomSheet!(context, state.pickedFiles));
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
  });

  final Color? albumDropdownColor;
  final Widget Function(BuildContext context, MediaAlbum alubm)? albumTile;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
      builder: (context, state) {
        return MediaAppBar(
          onChanged: (albumName) =>
              context.read<MediaPickerCubit>().changeAlbum(albumName),
          mediaAlbum: state.albums,
          albumDropdownColor: albumDropdownColor,
          albumTile: albumTile,
        );
      },
    );
  }
}
