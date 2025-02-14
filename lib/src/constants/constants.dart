import 'package:media_picker/media_picker.dart';
import 'package:photo_manager/photo_manager.dart';

const kMediaTypes = [
  MediaType.image,
  MediaType.video,
  MediaType.common,
];

const int kPageSize = 40;
const int kCrossAxisCount = 3;
const double kThumbnailBorderRadius = 10.0;
const ThumbnailSize kThumbnailSize = ThumbnailSize.square(200);
const int kThumbnailQuality = 100;
