import 'package:flutter/material.dart';
import 'package:media_picker/src/constants/constants.dart';
import 'package:media_picker/src/constants/enums.dart';
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/media_picker_wrapper.dart';
import 'package:media_picker/src/model/styles.dart';
import 'package:media_picker/src/utils/page_transition.dart';
import 'package:photo_manager/photo_manager.dart';

// Displays a media picker modal that allows users to select images or videos.
///
/// This function requests the necessary permissions before opening the media picker.
/// If permission is granted, it navigates to the `MediaPickerPageWrapper` where users can
/// browse and select media files.
///
/// [context] is required to access the current build context.
///
/// [onMediaPicked] is a required callback function that returns the selected media.
///
/// [allowMultiple] determines whether multiple media selection is allowed. Defaults to `false`.
///
/// [albumDropdownColor] sets the background color of the album dropdown menu.
///
/// [tabBarDecoration] allows customizing the appearance of the tab bar.
///
/// [mediaTypes] specifies the types of media that can be selected (e.g., images, videos).
/// It must not be an empty set if provided.
///
/// [scaffoldBackgroundColor] defines the background color of the media picker screen.
///
/// [checkedIconColor] sets the color of the icon displayed on selected media thumbnails.
///
/// [thumbnailBorderRadius] controls the border radius of media thumbnails.
///
/// [mediaGridMargin] adds margin around the media grid.
///
/// [contentPadding] applies padding to the main content area.
///
/// [loading] allows providing a custom widget to be displayed while media is loading.
///
/// [thumbnailLoader] provides a custom widget for thumbnail loading effects.
///
/// [popWhenSingleMediaSelected] determines whether the picker should close automatically
/// after selecting a single media file. Defaults to `true`.
///
/// [pickedMediaBottomSheetBuilder] allows customization of the bottom sheet shown after media selection.
///
/// [albumTileBuilder] provides a custom builder for album list items.
///
/// [albumDropdownButtonBuilder] allows customization of the album dropdown button.
///
/// [transitionBuilder] is a custom transition effect when navigating to the media picker.
///
/// [pageSize] defines the number of media items loaded per page.
///
/// [crossAxisCount] determines the number of media columns in the grid.
///
/// [sortAlbumFunction] provides a sorting function for albums.
///
/// [dropdownButtonColor] sets the color of the dropdown button.
///
/// Throws an exception if permissions are not granted.
///
/// Example:
/// ```dart
/// showMediaPicker(
///   context: context,
///   onMediaPicked: (media) {
///     print("Selected media: $media");
///   },
///   allowMultiple: true,
///   mediaTypes: {MediaType.image, MediaType.video},
/// );
///

Future<void> showMediaPicker(
    {required BuildContext context,
    required PickedMediaCallback onMediaPicked,
    bool allowMultiple = false,
    Color? albumDropdownColor,
    TabBarDecoration? tabBarDecoration,
    Set<MediaType>? mediaTypes,
    Color? scaffoldBackgroundColor,
    Color? checkedIconColor,
    double? thumbnailBorderRadius,
    EdgeInsetsGeometry? mediaGridMargin,
    EdgeInsetsGeometry? contentPadding,
    Widget? loading,
    Widget? thumbnailLoader,
    bool popWhenSingleMediaSelected = true,
    PickedMediaBottomSheetBuilder? pickedMediaBottomSheetBuilder,
    AlbumTileBuilder? albumTileBuilder,
    AlbumDropdownButtonBuilder? albumDropdownButtonBuilder,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transitionBuilder,
    int? pageSize,
    int? crossAxisCount,
    SortFunction? sortAlbumFunction,
    Color? dropdownButtonColor}) async {
  if (mediaTypes != null) {
    assert(mediaTypes.isNotEmpty, 'MediaTypes must not be empty.');
  }
  await Permission.requestPermission().then((granted) {
    if (granted.isAuth) {
      if (!context.mounted) return;
      Navigator.of(context).push(
        createRoute(
          transitionBuilder,
          MediaPickerPageWrapper(
            allowMultiple: allowMultiple,
            tabBarDecoration: tabBarDecoration,
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            mediaTypes: mediaTypes?.toList() ?? [],
            dropdownColor: albumDropdownColor,
            pickedMediaBottomSheet: pickedMediaBottomSheetBuilder,
            albumTileBuilder: albumTileBuilder,
            onMediaPicked: onMediaPicked,
            thumbnailBorderRadius: thumbnailBorderRadius,
            mediaGridMargin: mediaGridMargin,
            loading: loading,
            thumbnailShimmer: thumbnailLoader,
            checkedIconColor: checkedIconColor,
            popWhenSingleMediaSelected: popWhenSingleMediaSelected,
            contentPadding: contentPadding,
            albumDropdownButtonBuilder: albumDropdownButtonBuilder,
            pageSize: pageSize ?? kPageSize,
            crossAxisCount: crossAxisCount,
            sortFunction: sortAlbumFunction,
            dropdownButtonColor: dropdownButtonColor,
          ),
        ),
      );
    } else {
      throw Exception("No permission allowed");
    }
  });
}

class Permission {
  static Future<PermissionState> requestPermission() async {
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();

    return permission;
  }
}
