import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/constants/typedefs.dart';

class CustomAlbumConfig {
  final MediaAlbum album;
  final MediaGridBuilder builder;

  const CustomAlbumConfig({
    required this.album,
    required this.builder,
  });
}
