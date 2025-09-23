import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';

class MediaPickerPage extends StatefulWidget {
  const MediaPickerPage({
    super.key,
    this.scaffoldBackgroundColor,
    this.dropdownColor,
    this.albumTileBuilder,
    required this.onMediaPicked,
    this.thumbnailBorderRadius,
    this.mediaGridMargin,
    this.loading,
    this.thumbnailShimmer,
    required this.popWhenSingleMediaSelected,
    this.contentPadding,
    this.albumDropdownButtonBuilder,
    required this.pageSize,
    this.crossAxisCount,
    this.dropdownButtonColor,
    this.closeIcon,
    this.closeIconColor,
    this.albumNameStyle,
    this.albumCountStyle,
    this.customAlbum,
    this.mediaGridBuilder,
    this.videoIconBuilder,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    this.onClose,
    this.limitedPermissionBuilder,
    required this.permissionState,
    this.assetGrouper,
    this.groupDateBuilder,
    this.trailingIcon,
    this.customAlbumConfigs,
  });

  final Color? scaffoldBackgroundColor;
  final Color? dropdownColor;
  final PickedMediaCallback onMediaPicked;
  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridMargin;
  final EdgeInsetsGeometry? contentPadding;

  final Widget? loading;
  final Widget? thumbnailShimmer;
  final bool popWhenSingleMediaSelected;

  final AlbumTileBuilder? albumTileBuilder;
  final AlbumDropdownButtonBuilder? albumDropdownButtonBuilder;

  final int pageSize;
  final int? crossAxisCount;
  final Color? dropdownButtonColor;

  final Widget? closeIcon;
  final Color? closeIconColor;
  final TextStyle? albumNameStyle;
  final TextStyle? albumCountStyle;

  final MediaAlbum? customAlbum;
  final MediaGridBuilder? mediaGridBuilder;
  final VideoIconBuilder? videoIconBuilder;

  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final VoidCallback? onClose;
  final LimitedPermissionBottomBuilder? limitedPermissionBuilder;
  final PermissionState permissionState;
  final AssetGrouperCallback? assetGrouper;
  final AssetsGroupDateBuilder? groupDateBuilder;
  final Widget? trailingIcon;
  final List<CustomAlbumConfig>? customAlbumConfigs;
  @override
  State<MediaPickerPage> createState() => _MediaPickerPageState();
}

class _MediaPickerPageState extends State<MediaPickerPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Gallery"),
        actions: const [CircularProgressIndicator.adaptive()],
      ),
      backgroundColor: widget.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight - 8),
            child: Column(
              children: [
                (widget.permissionState == PermissionState.limited &&
                        widget.limitedPermissionBuilder != null
                    ? widget.limitedPermissionBuilder!(context)
                    : const SizedBox.shrink()),
                Expanded(
                  child: MediaContent(
                    customAlbumConfigs: widget.customAlbumConfigs,
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
                    contentPadding: widget.contentPadding,
                    pageSize: widget.pageSize,
                    crossAxisCount: widget.crossAxisCount,
                    mediaGridBuilder: widget.mediaGridBuilder,
                    customAlbum: widget.customAlbum,
                    videoIconBuilder: widget.videoIconBuilder,
                    crossAxisSpacing: widget.crossAxisSpacing,
                    mainAxisSpacing: widget.mainAxisSpacing,
                  ),
                ),
              ],
            ),
          ),
          _buildMediaAppBar(context, widget.onClose),
        ],
      ),
    );
  }

  _buildMediaAppBar(BuildContext context, VoidCallback? onClose) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
      builder: (context, state) {
        return MediaAppBar(
          onChanged: (album) => context
              .read<MediaPickerCubit>()
              .changeAlbum(album, widget.pageSize),
          mediaAlbum: state.albums,
          albumDropdownColor: widget.dropdownColor,
          // albumTile: widget.albumTileBuilder,
          // albumButtonBuilder: widget.albumDropdownButtonBuilder,
          // dropdownButtonColor: widget.dropdownButtonColor,
          closeIcon: widget.closeIcon,
          closeIconColor: widget.closeIconColor,
          albumCountStyle: widget.albumCountStyle,
          albumNameStyle: widget.albumNameStyle,
          customAlbum: widget.customAlbumConfigs?.map((e) => e.album).toList(),
          onClose: onClose,
          trailingIcon: widget.trailingIcon,
        );
      },
    );
  }
}

class MediaContent extends StatelessWidget {
  const MediaContent({
    super.key,
    this.thumbnailBorderRadius,
    this.mediaGridMargin,
    this.onSingleFileSelection,
    this.loading,
    this.thumbnailShimmer,
    this.checkedIconColor,
    this.contentPadding,
    required this.pageSize,
    this.crossAxisCount,
    this.mediaGridBuilder,
    this.customAlbum,
    this.videoIconBuilder,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    this.assetGrouper,
    this.groupDateBuilder,
    required this.customAlbumConfigs,
  });

  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridMargin;
  final EdgeInsetsGeometry? contentPadding;
  final Function(AssetEntity)? onSingleFileSelection;
  final Widget? loading;
  final Widget? thumbnailShimmer;
  final Color? checkedIconColor;
  final int pageSize;
  final int? crossAxisCount;
  final List<CustomAlbumConfig>? customAlbumConfigs;

  final MediaGridBuilder? mediaGridBuilder;
  final MediaAlbum? customAlbum;
  final VideoIconBuilder? videoIconBuilder;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final AssetGrouperCallback? assetGrouper;
  final AssetsGroupDateBuilder? groupDateBuilder;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
        builder: (context, state) {
      if (state.hasCustomAlbum && customAlbumConfigs != null) {
        // Find matching custom album config
        final config = customAlbumConfigs!.firstWhereOrNull(
          (config) => config.album.name == state.currentAlubm.name,
        );
        if (config != null) {
          return config.builder(context);
        }
      }

      if (state.isLoading && !state.isPaginating) {
        return loading ??
            LoadingGridShimmer(
              crossAxisCount: crossAxisCount,
              borderRadius: thumbnailBorderRadius,
              pageSize: pageSize,
            );
      }

      return MediaGrid(
          type: MediaType.common,
          medias: state.media.common,
          name: "media",
          thumbnailBorderRadius: thumbnailBorderRadius,
          mediaGridMargin: mediaGridMargin,
          onSingleFileSelection: onSingleFileSelection,
          thumbnailShimmer: thumbnailShimmer,
          contentPadding: contentPadding,
          pageSize: pageSize,
          crossAxisCount: crossAxisCount,
          videoIconBuilder: videoIconBuilder,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          assetGrouper: assetGrouper,
          groupDateBuilder: groupDateBuilder);
    });
  }
}
