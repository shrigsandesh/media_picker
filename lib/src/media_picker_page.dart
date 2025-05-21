import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';

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
            Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight - 8),
              child: MediaContent(
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
            ),
            _buildMediaAppBar(context),
          ],
        ),
      ),
    );
  }

  _buildMediaAppBar(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
      builder: (context, state) {
        return MediaAppBar(
          onChanged: (album) => context
              .read<MediaPickerCubit>()
              .changeAlbum(album, widget.pageSize),
          mediaAlbum: state.albums,
          albumDropdownColor: widget.dropdownColor,
          albumTile: widget.albumTileBuilder,
          albumButtonBuilder: widget.albumDropdownButtonBuilder,
          dropdownButtonColor: widget.dropdownButtonColor,
          closeIcon: widget.closeIcon,
          closeIconColor: widget.closeIconColor,
          albumCountStyle: widget.albumCountStyle,
          albumNameStyle: widget.albumNameStyle,
          customAlbum: widget.customAlbum,
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
      if (state.hasCustomAlbum &&
          state.currentAlubm.name == customAlbum?.name) {
        return mediaGridBuilder != null
            ? mediaGridBuilder!(context)
            : const CustomAlbumPlaceHolder();
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
      );
    });
  }
}
