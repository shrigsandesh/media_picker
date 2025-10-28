import 'package:flutter/material.dart';
import 'package:media_picker/media_picker.dart';

import 'package:skeletonizer/skeletonizer.dart';

class DefaultAlbumTile extends StatelessWidget {
  const DefaultAlbumTile({
    super.key,
    this.mediaAlbum,
    this.albumNameStyle,
    this.albumCountStyle,
  });

  final MediaAlbum? mediaAlbum;
  final TextStyle? albumNameStyle;
  final TextStyle? albumCountStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox.square(
            dimension: 80,
            child: AssetThumbnail(
              asset: mediaAlbum?.previewAsset,
              showCircularPlaceholder: false,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mediaAlbum?.name ?? "",
              style: albumNameStyle ??
                  const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              mediaAlbum!.size.toString(),
              style: albumCountStyle ??
                  const TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomAlbumPlaceHolder extends StatelessWidget {
  const CustomAlbumPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No media found.'),
    );
  }
}
