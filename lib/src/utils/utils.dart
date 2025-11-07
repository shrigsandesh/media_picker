import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/constants/constants.dart';
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/media_picker_page.dart';
import 'package:media_picker/src/model/config.dart';
import 'package:media_picker/src/model/media_model.dart';
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
///
/// [scaffoldBackgroundColor] defines the background color of the media picker screen.
///
/// [thumbnailBorderRadius] controls the border radius of media thumbnails.
///

/// [mediaGridPadding] applies padding to the main content area.
///
/// [loading] allows providing a custom widget to be displayed while media is loading.
///
/// [thumbnailLoader] provides a custom widget for thumbnail loading effects.
///
/// [popWhenSingleMediaSelected] determines whether the picker should close automatically
/// after selecting a single media file. Defaults to `true`.

///
/// [transitionBuilder] is a custom transition effect when navigating to the media picker.
///
/// [pageSize] defines the number of media items loaded per page.
///
/// [crossAxisCount] determines the number of media columns in the grid.
///
/// [sortAlbumFunction] provides a sorting function for albums.
///

/// [trailingIcon] is a  option custom trailing icon at top right section
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
/// );
///

Future<void> showMediaPicker(
    {required BuildContext context,
    required PickedMediaCallback onMediaPicked,
    Color? scaffoldBackgroundColor,
    double? thumbnailBorderRadius,
    EdgeInsetsGeometry? mediaGridPadding,
    Widget? loading,
    Widget? thumbnailLoader,
    bool popWhenSingleMediaSelected = true,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transitionBuilder,
    int pageSize = kPageSize,
    int? crossAxisCount,
    SortFunction? sortAlbumFunction,
    Color? tabBackgroundColor,
    MediaAlbum? customAlbum,
    MediaGridBuilder? mediaGridBuilder,
    MediaStackedWidgetsBuilder? mediaStackedWidgetsBuilder,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    VoidCallback? onClose,
    LimitedPermissionBottomBuilder? limitedPermissionBuilder,
    Widget? trailingIcon,
    required PermissionState permissionState,
    AssetGrouperCallback? assetGrouper,
    AssetsGroupDateBuilder? groupDateBuilder,
    List<CustomAlbumConfig>? customAlbumConfigs,
    TabDecoration? tabDecoration,
    CustomTabBuilder? tabBuilder,
    AppBar? appBar,
    double? hourGroupSpacing,
    int? initialTabIndex}) async {
  assert(
    (mediaGridBuilder == null && customAlbum == null) ||
        (mediaGridBuilder != null && customAlbum != null),
    'Both mediaGridBuilder and customAlbum must be provided together, or both must be null.',
  );
  assert(
    (assetGrouper == null && groupDateBuilder == null) ||
        (assetGrouper != null && groupDateBuilder != null),
    'Both assetGrouper and groupDateBuilder must be provided together, or both must be null.',
  );

  await Permission.requestPermission().then((granted) {
    if (granted.hasAccess) {
      if (!context.mounted) return;
      Navigator.of(context).push(
        createRoute(
          transitionBuilder,
          BlocProvider(
            create: (context) => MediaPickerCubit()
              ..loadMedia(
                pageSize: pageSize,
                sortFunction: sortAlbumFunction,
                hasCustomAlbum: customAlbumConfigs?.isNotEmpty ?? false,
                customAlbum: (customAlbumConfigs?.isNotEmpty ?? false)
                    ? customAlbumConfigs!.first.album
                    : null,
              ),
            child: MediaPickerPage(
              initialTabIndex: initialTabIndex,
              scaffoldBackgroundColor: scaffoldBackgroundColor,
              tabBackgroundColor: tabBackgroundColor,
              onMediaPicked: onMediaPicked,
              thumbnailBorderRadius: thumbnailBorderRadius,
              loading: loading,
              thumbnailShimmer: thumbnailLoader,
              popWhenSingleMediaSelected: popWhenSingleMediaSelected,
              mediaGridPadding: mediaGridPadding,
              pageSize: pageSize,
              crossAxisCount: crossAxisCount,
              customAlbum: customAlbum,
              mediaGridBuilder: mediaGridBuilder,
              mediaStackedWidgetsBuilder: mediaStackedWidgetsBuilder,
              crossAxisSpacing: crossAxisSpacing ?? 0.0,
              mainAxisSpacing: mainAxisSpacing ?? 0.0,
              onClose: onClose,
              limitedPermissionBuilder: limitedPermissionBuilder,
              permissionState: permissionState,
              assetGrouper: assetGrouper,
              groupDateBuilder: groupDateBuilder,
              customAlbumConfigs: customAlbumConfigs,
              tabBuilder: tabBuilder,
              tabDecoration: tabDecoration,
              appBar: appBar,
              hourGroupSpacing: hourGroupSpacing,
            ),
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
