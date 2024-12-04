<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.
# Documentation: `showMediaPicker`

The `showMediaPicker` method is a customizable media picker for Flutter applications. It provides options to pick single or multiple media files, supports different media types, and allows extensive UI customization.

---

## **Method Signature**

```dart
Future<void> showMediaPicker({
  required BuildContext context,
  required PickedMediaCallback pickedMedias,
  bool allowMultiple = false,
  Color? albumDropdownColor,
  TabBarDecoration? tabBarDecoration,
  Set<MediaType>? mediaTypes,
  Color? scaffoldBackgroundColor,
  Color? checkedIconColor,
  double? thumbnailBorderRadius,
  EdgeInsetsGeometry? mediaGridMargin,
  Widget? loading,
  Widget? thumbnailShimmer,
  Widget Function(BuildContext context, List<AssetEntity> albums)? pickedMediaBottomSheet,
  Widget Function(BuildContext context, MediaAlbum album)? albumTile,
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)? transitionBuilder,
}) async

[Documentation for showMediaPicker](docs/methods.md)


## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
