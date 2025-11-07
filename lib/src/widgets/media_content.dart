import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';

class MediaContent extends StatelessWidget {
  const MediaContent(
      {super.key,
      this.thumbnailBorderRadius,
      this.onSingleFileSelection,
      this.loading,
      this.thumbnailShimmer,
      this.checkedIconColor,
      this.mediaGridPadding,
      required this.pageSize,
      this.crossAxisCount,
      required this.crossAxisSpacing,
      required this.mainAxisSpacing,
      this.assetGrouper,
      this.groupDateBuilder,
      required this.customAlbumConfigs,
      this.hourGroupSpacing,
      this.mediaStackedWidgets});

  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridPadding;
  final Function(AssetEntity)? onSingleFileSelection;
  final Widget? loading;
  final Widget? thumbnailShimmer;
  final Color? checkedIconColor;
  final int pageSize;
  final int? crossAxisCount;
  final List<CustomAlbumConfig>? customAlbumConfigs;

  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final AssetGrouperCallback? assetGrouper;
  final AssetsGroupDateBuilder? groupDateBuilder;
  final double? hourGroupSpacing;
  final MediaStackedWidgetsBuilder? mediaStackedWidgets;
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
        onSingleFileSelection: onSingleFileSelection,
        thumbnailShimmer: thumbnailShimmer,
        mediaGridPadding: mediaGridPadding,
        pageSize: pageSize,
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        assetGrouper: assetGrouper,
        groupDateBuilder: groupDateBuilder,
        hourGroupSpacing: hourGroupSpacing,
        mediaStackedWidgets: mediaStackedWidgets,
      );
    });
  }
}
