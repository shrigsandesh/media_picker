import 'package:flutter/material.dart';
import 'package:media_picker/src/constants/constants.dart';
import 'package:media_picker/src/widgets/thumbnail_skeleton.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/foundation.dart';

class AssetThumbnail extends StatefulWidget {
  const AssetThumbnail({
    super.key,
    this.asset,
    this.thumbnailSize,
    this.borderRadius,
    this.showSkeleton = true,
    this.thumbnailShimmer,
    this.thumbnailQuality = kThumbnailQuality,
    this.memoryCacheWidth,
    this.memoryCacheHeight,
  });

  final AssetEntity? asset;
  final ThumbnailSize? thumbnailSize;
  final double? borderRadius;
  final bool? showSkeleton;
  final Widget? thumbnailShimmer;
  final int thumbnailQuality;
  final int? memoryCacheWidth;
  final int? memoryCacheHeight;

  @override
  State<AssetThumbnail> createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail>
    with AutomaticKeepAliveClientMixin {
  Future<Uint8List?>? _thumbnailFuture;
  bool isImageLoaded = false;
  late ThumbnailSize _thumbnailSize;

  @override
  void initState() {
    super.initState();
    _thumbnailSize = widget.thumbnailSize ?? kThumbnailSize;
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(AssetThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset?.id != widget.asset?.id) {
      _loadThumbnail();
    }
  }

  void _loadThumbnail() {
    if (widget.asset == null) return;

    _thumbnailFuture = widget.asset!.thumbnailDataWithOption(
      ThumbnailOption(
        size: _thumbnailSize,
        quality: widget.thumbnailQuality,
        format: ThumbnailFormat.jpeg,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<Uint8List?>(
      future: _thumbnailFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 1),
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              height: _thumbnailSize.height.toDouble(),
              width: _thumbnailSize.width.toDouble(),
              gaplessPlayback: true,
              cacheWidth: widget.memoryCacheWidth,
              cacheHeight: widget.memoryCacheHeight,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (frame == null && widget.showSkeleton == true) {
                  return widget.thumbnailShimmer ??
                      ThumbnailSkeleton(
                        borderRadius: widget.borderRadius ?? 1,
                        size: widget.thumbnailSize?.height.toDouble(),
                      );
                }
                return child;
              },
            ),
          );
        }

        return widget.showSkeleton == true
            ? widget.thumbnailShimmer ??
                ThumbnailSkeleton(
                  borderRadius: widget.borderRadius ?? 1,
                  size: widget.thumbnailSize?.height.toDouble(),
                )
            : const SizedBox.shrink();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
