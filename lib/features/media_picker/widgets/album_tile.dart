import 'package:flutter/material.dart';
import 'package:media_picker/features/media_picker/widgets/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumTile extends StatelessWidget {
  const AlbumTile(
      {super.key, required this.name, required this.size, required this.asset});

  final String name;
  final String size;
  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AssetThumbnail(asset: asset),
        const SizedBox(
          width: 50,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(name), Text(size)],
        ),
      ],
    );
  }
}
