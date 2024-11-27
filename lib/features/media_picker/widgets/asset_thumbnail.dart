import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetThumbnail extends StatefulWidget {
  const AssetThumbnail(
      {super.key, this.asset, this.thumbnailSize, this.borderRadius});

  final AssetEntity? asset;
  final ThumbnailSize? thumbnailSize;
  final double? borderRadius;

  @override
  State<AssetThumbnail> createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  Future<Uint8List?>? _thumbnailFuture;

  @override
  void initState() {
    super.initState();
    _thumbnailFuture = widget.asset?.thumbnailDataWithSize(
      widget.thumbnailSize ?? const ThumbnailSize(200, 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _thumbnailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 1),
            child: Image.memory(
              filterQuality: FilterQuality.low,
              snapshot.data!,
              fit: BoxFit.cover,
              height: widget.thumbnailSize?.height.toDouble() ?? 80,
              width: widget.thumbnailSize?.width.toDouble() ?? 60,
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 1)),
            height: 80,
            width: 60,
          );
        }
      },
    );
  }
}
