import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/media_picker_page.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';

class MediaPickerPageWrapper extends StatelessWidget {
  const MediaPickerPageWrapper({
    super.key,
    required this.allowMultiple,
    this.tabBarDecoration,
    required this.mediaTypes,
    this.scaffoldBackgroundColor,
    this.dropdownColor,
    required this.onMediaPicked,
    this.thumbnailBorderRadius,
    this.mediaGridMargin,
    this.contentPadding,
    this.loading,
    this.thumbnailShimmer,
    this.checkedIconColor,
    required this.popWhenSingleMediaSelected,
    this.pickedMediaBottomSheet,
    this.albumTileBuilder,
    this.albumDropdownButtonBuilder,
    required this.pageSize,
    this.crossAxisCount,
    required this.sortFunction,
    this.dropdownButtonColor,
    this.closeIcon,
    this.closeIconColor,
    this.albumNameStyle,
    this.albumCountStyle,
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
  final SortFunction? sortFunction;
  final Color? dropdownButtonColor;

  final Widget? closeIcon;
  final Color? closeIconColor;
  final TextStyle? albumNameStyle;
  final TextStyle? albumCountStyle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaPickerCubit()
        ..loadMedia(
          mediaType: mediaTypes,
          pageSize: pageSize,
          sortFunction: sortFunction,
        ),
      child: MediaPickerPage(
        allowMultiple: allowMultiple,
        tabBarDecoration: tabBarDecoration,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        mediaTypes: mediaTypes,
        dropdownColor: dropdownColor,
        pickedMediaBottomSheet: pickedMediaBottomSheet,
        albumTileBuilder: albumTileBuilder,
        onMediaPicked: onMediaPicked,
        thumbnailBorderRadius: thumbnailBorderRadius,
        mediaGridMargin: mediaGridMargin,
        loading: loading,
        thumbnailShimmer: thumbnailShimmer,
        checkedIconColor: checkedIconColor,
        popWhenSingleMediaSelected: popWhenSingleMediaSelected,
        contentPadding: contentPadding,
        albumDropdownButtonBuilder: albumDropdownButtonBuilder,
        pageSize: pageSize,
        crossAxisCount: crossAxisCount,
        dropdownButtonColor: dropdownButtonColor,
        closeIcon: closeIcon,
        closeIconColor: closeIconColor,
        albumNameStyle: albumNameStyle,
        albumCountStyle: albumCountStyle,
      ),
    );
  }
}
