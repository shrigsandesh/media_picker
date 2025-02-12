Customizable flutter package to load media(image and video).

![Sample image](https://github.com/shrigsandesh/media_picker/blob/main/assets/sample.jpg)

## Getting started

Add the following to your `pubspec.yaml` file:

```yaml
media_picker:
  git: https://github.com/shrigsandesh/media_picker.git 
      

```

## Adding Permissions

To use this package, you need to add the appropriate permissions for accessing media and storage.

### Android

Add the following permissions to your `AndroidManifest.xml` file:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.app">
    
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    
    <!-- Required for devices running Android 13 (API level 33) -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
</manifest>
```

### iOS

Update the Info.plist with:

```swift
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to select media.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need access to your photo library to selec photos or videos.</string>
```

## Usage

```dart
 showMediaPicker(
    context: context,
    mediaTypes: {
        MediaType.common,
        MediaType.video,
        MediaType.image
    },
    pickedMedias: (assetEntity) {
         // returns list of picked media, if non selected returns empty list
    },
);
```
for more see [example](https://github.com/shrigsandesh/media_picker/tree/main/example)

## Parameters

| **Name**                 | **Type**                                                                                       | **Description**                                                                                                                                 |
|--------------------------|------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| `context`                | `BuildContext`                                                                                | The build context required for navigation.                                                                                                    |
| `onMediaPicked`           | `PickedMediaCallback`                                                                         | Callback to return the selected media files.                                                                                                 |
| `allowMultiple`          | `bool` (default: `false`)                                                                     | Whether multiple media files can be selected.                                                                                                |
| `albumDropdownColor`     | `Color?`                                                                                      | Background color for the album dropdown menu.                                                                                                |
| `tabBarDecoration`       | `TabBarDecoration?`                                                                           | Custom decoration for the tab bar.                                                                                                           |
| `mediaTypes`             | `Set<MediaType>?`                                                                             | Specifies the types of media (e.g., images, videos) allowed for selection. Must not be empty if provided.                                    |
| `scaffoldBackgroundColor`| `Color?`                                                                                      | Background color of the picker scaffold.                                                                                                     |
| `checkedIconColor`       | `Color?`                                                                                      | Color of the checked icon for selected items.                                                                                                |
| `thumbnailBorderRadius`  | `double?`                                                                                     | Border radius for the media thumbnails.                                                                                                      |
| `mediaGridMargin`        | `EdgeInsetsGeometry?`                                                                         | Margin in between the media grid layout.                                                                                                            |
| `loading`                | `Widget?`                                                                                     | Widget displayed during loading states.                                                                                                     |
| `thumbnailShimmer`       | `Widget?`                                                                                     | Widget displayed as a shimmer effect while loading thumbnails.                                                                              |
| `pickedMediaBottomSheetBuilder` | `Widget Function(BuildContext context, List<AssetEntity> albums)?`                            | Custom widget for displaying picked media in a bottom sheet.                                                                                |
| `albumTileBuilder`              | `Widget Function(BuildContext context, MediaAlbum album)?`                                    | Custom widget for displaying an album tile.                                                                                                 |
| `albumDropdownButtonBuilder`              | `Widget Function(BuildContext context, List<AssetEntity> albums)?`| Custom widget for displaying album dropdown button.
| `transitionBuilder`      | `Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?`               | Custom transition builder for the navigation.                                                                                               |
| `popWhenSingleMediaSelected`              | `bool` (default: `true`) |                                   Whether to pop media picker page after single media file is picked (Ignored if  `allowMultiple`is set to `true`.)  |
| `contentPadding`              | `EdgeInsetsGeometry?` | Padding around the media grid  |
| `pageSize`               | `int` (default: `40`)  | Number of media items to load per page.  |


## Dependencies

- **[photo_manager](https://pub.dev/packages/photo_manager)**
- **[flutter_bloc](https://pub.dev/packages/flutter_bloc)**
- **[equatable](https://pub.dev/packages/equatable)**
- **[skeletonizer](https://pub.dev/packages/skeletonizer)**
- **[collection](https://pub.dev/packages/collection)**


## Additional information

Available on **ANDROID** & **iOS** only. 
