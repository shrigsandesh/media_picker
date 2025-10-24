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

/// Displays a customizable media picker that allows users to select images or videos.
///
/// This function handles permission requests, opens a media picker modal, and provides
/// callbacks for customization of UI components and behavior.
///
/// It automatically requests storage/gallery permissions before displaying the picker.
/// If permission is granted, it navigates to [MediaPickerPage] where users can browse and select media.
///
/// Throws an [Exception] if permissions are not granted.
///
/// ---
///
/// ### Parameters
///
/// **Required**
///
/// - [context]: The current [BuildContext].
/// - [onMediaPicked]: Callback function returning the selected media items.
/// - [permissionState]: The [PermissionState] indicating current permission status.
///
/// **Optional**
///
/// - [albumDropdownColor]: Background color of the album dropdown menu.
/// - [scaffoldBackgroundColor]: Background color of the main picker screen.
/// - [thumbnailBorderRadius]: Border radius applied to media thumbnails.
/// - [mediaGridMargin]: Margin applied around the media grid.
/// - [contentPadding]: Padding inside the picker’s main content area.
/// - [loading]: Custom widget displayed while loading media.
/// - [thumbnailLoader]: Custom widget for displaying thumbnail loading effects (e.g. shimmer).
/// - [popWhenSingleMediaSelected]: Whether to automatically close the picker when a single item is selected. Defaults to `true`.
/// - [albumTileBuilder]: Custom builder for rendering album list items.
/// - [albumDropdownButtonBuilder]: Custom builder for the album dropdown button.
/// - [transitionBuilder]: Custom navigation transition animation when opening the picker.
/// - [pageSize]: Number of media items to load per page. Defaults to [kPageSize].
/// - [crossAxisCount]: Number of columns in the media grid.
/// - [sortAlbumFunction]: Custom sorting function for albums.
/// - [dropdownButtonColor]: Background color for the album dropdown button.
/// - [closeIcon]: Custom close button widget.
/// - [closeIconColor]: Color for the close icon (ignored if [closeIcon] is provided).
/// - [albumNameStyle]: Custom text style for album names (ignored if [albumTileBuilder] is provided).
/// - [albumCountStyle]: Custom text style for album counts (ignored if [albumTileBuilder] is provided).
/// - [customAlbum]: A specific [MediaAlbum] to display initially instead of all albums.
/// - [mediaGridBuilder]: Custom builder for the media grid layout.
/// - [videoIconBuilder]: Custom builder for video overlay icons displayed on thumbnails.
/// - [crossAxisSpacing]: Horizontal spacing between grid items.
/// - [mainAxisSpacing]: Vertical spacing between grid items.
/// - [onClose]: Callback triggered when the picker is closed manually.
/// - [limitedPermissionBuilder]: Builder for displaying UI when limited gallery access is granted.
/// - [trailingIcon]: Optional custom widget displayed at the top-right corner (e.g. settings or info icon).
/// - [assetGrouper]: Function that groups assets (images/videos) by a custom criterion (e.g., by date).
/// - [groupDateBuilder]: Widget builder to display date or grouping headers for assets.
/// - [customAlbumConfigs]: List of [CustomAlbumConfig] objects defining custom album behaviors or sources.
/// - [tabDecoration]: Customizes the appearance and style of the album/media tabs.
/// - [tabBuilder]: Custom builder for tabs shown in the picker (e.g. “Photos”, “Videos”, “Albums”).
/// - [appBar]: Optional custom [AppBar] to replace the default picker header.
///
/// ---
///
/// ### Example
/// ```dart
/// showMediaPicker(
///   context: context,
///   onMediaPicked: (mediaList) {
///     print('Selected media: $mediaList');
///   },
///   crossAxisCount: 3,
///   albumDropdownColor: Colors.grey[900],
///   trailingIcon: Icon(Icons.check),
/// );
/// ```
///
/// ---
///
/// ### Assertions
/// - Both [mediaGridBuilder] and [customAlbum] must be provided together or both must be `null`.
/// - Both [assetGrouper] and [groupDateBuilder] must be provided together or both must be `null`.
///

Future<void> showMediaPicker({
  required BuildContext context,
  required PickedMediaCallback onMediaPicked,
  Color? albumDropdownColor,
  Color? scaffoldBackgroundColor,
  double? thumbnailBorderRadius,
  EdgeInsetsGeometry? mediaGridMargin,
  EdgeInsetsGeometry? contentPadding,
  Widget? loading,
  Widget? thumbnailLoader,
  bool popWhenSingleMediaSelected = true,
  AlbumTileBuilder? albumTileBuilder,
  AlbumDropdownButtonBuilder? albumDropdownButtonBuilder,
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
      transitionBuilder,
  int pageSize = kPageSize,
  int? crossAxisCount,
  SortFunction? sortAlbumFunction,
  Color? dropdownButtonColor,
  Widget? closeIcon,
  Color? closeIconColor,
  TextStyle? albumNameStyle,
  TextStyle? albumCountStyle,
  MediaAlbum? customAlbum,
  MediaGridBuilder? mediaGridBuilder,
  VideoIconBuilder? videoIconBuilder,
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
}) async {
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
              scaffoldBackgroundColor: scaffoldBackgroundColor,
              dropdownColor: albumDropdownColor,
              albumTileBuilder: albumTileBuilder,
              onMediaPicked: onMediaPicked,
              thumbnailBorderRadius: thumbnailBorderRadius,
              mediaGridMargin: mediaGridMargin,
              loading: loading,
              thumbnailShimmer: thumbnailLoader,
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
              customAlbum: customAlbum,
              mediaGridBuilder: mediaGridBuilder,
              videoIconBuilder: videoIconBuilder,
              crossAxisSpacing: crossAxisSpacing ?? 0.0,
              mainAxisSpacing: mainAxisSpacing ?? 0.0,
              onClose: onClose,
              limitedPermissionBuilder: limitedPermissionBuilder,
              permissionState: permissionState,
              assetGrouper: assetGrouper,
              groupDateBuilder: groupDateBuilder,
              trailingIcon: trailingIcon,
              customAlbumConfigs: customAlbumConfigs,
              tabBuilder: tabBuilder,
              tabDecoration: tabDecoration,
              appBar: appBar,
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
