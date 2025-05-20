import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/constants/enums.dart';
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/model/media_model.dart';

import 'package:photo_manager/photo_manager.dart';
import 'package:media_picker/src/widgets/widgets_.dart';

class MediaPickerPage extends StatefulWidget {
  const MediaPickerPage({
    super.key,
    this.scaffoldBackgroundColor,
    this.dropdownColor,
    this.pickedMediaBottomSheet,
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

  final PickedMediaBottomSheetBuilder? pickedMediaBottomSheet;
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

  @override
  State<MediaPickerPage> createState() => _MediaPickerPageState();
}

class _MediaPickerPageState extends State<MediaPickerPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            MediaContent(
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
            ),
            MediaPickerAppBarSection(
              albumDropdownColor: widget.dropdownColor,
              albumTile: widget.albumTileBuilder,
              albumButtonBuilder: widget.albumDropdownButtonBuilder,
              pageSize: widget.pageSize,
              dropdownButtonColor: widget.dropdownButtonColor,
              closeIcon: widget.closeIcon,
              closeIconColor: widget.closeIconColor,
              albumCountStyle: widget.albumCountStyle,
              albumNameStyle: widget.albumNameStyle,
              customAlbum: widget.customAlbum,
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
    this.thumbnailBorderRadius,
    this.mediaGridMargin,
    this.onSingleFileSelection,
    this.loading,
    this.thumbnailShimmer,
    this.contentPadding,
    required this.pageSize,
    this.crossAxisCount,
    this.mediaGridBuilder,
    this.customAlbum,
  });

  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridMargin;
  final EdgeInsetsGeometry? contentPadding;
  final Function(AssetEntity)? onSingleFileSelection;
  final Widget? loading;
  final Widget? thumbnailShimmer;

  final int pageSize;
  final int? crossAxisCount;
  final MediaGridBuilder? mediaGridBuilder;
  final MediaAlbum? customAlbum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight - 8),
      child: Column(
        children: [
          MediaTabContent(
            thumbnailBorderRadius: thumbnailBorderRadius,
            mediaGridMargin: mediaGridMargin,
            onSingleFileSelection: onSingleFileSelection,
            loading: loading,
            thumbnailShimmer: thumbnailShimmer,
            contentPadding: contentPadding,
            pageSize: pageSize,
            crossAxisCount: crossAxisCount,
            mediaGridBuilder: mediaGridBuilder,
            customAlbum: customAlbum,
          ),
        ],
      ),
    );
  }
}

class MediaTabContent extends StatelessWidget {
  const MediaTabContent({
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
  final MediaGridBuilder? mediaGridBuilder;
  final MediaAlbum? customAlbum;

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
      if (mediaGridBuilder != null ||
          state.hasCustomAlbum &&
              state.currentAlubm.name == customAlbum?.name) {
        log("Custom Album: ${state.currentAlubm.name}");
        return Expanded(
            child: mediaGridBuilder != null
                ? mediaGridBuilder!(context)
                : const CustomAlbumPlaceHolder());
      }

      return Expanded(
        child: MediaGrid(
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
        ),
      );
    });
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
    this.showCircularPlaceholder,
    this.closeIcon,
    this.closeIconColor,
    this.albumNameStyle,
    this.albumCountStyle,
    this.customAlbum,
  });

  final Color? albumDropdownColor;
  final AlbumTileBuilder? albumTile;
  final AlbumDropdownButtonBuilder? albumButtonBuilder;
  final int pageSize;
  final Color? dropdownButtonColor;

  final bool? showCircularPlaceholder;

  final Widget? closeIcon;
  final Color? closeIconColor;
  final TextStyle? albumNameStyle;
  final TextStyle? albumCountStyle;
  final MediaAlbum? customAlbum;

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
          showCircularPlaceholder: showCircularPlaceholder,
          closeIcon: closeIcon,
          closeIconColor: closeIconColor,
          albumCountStyle: albumCountStyle,
          albumNameStyle: albumNameStyle,
          customAlbum: customAlbum,
        );
      },
    );
  }
}
