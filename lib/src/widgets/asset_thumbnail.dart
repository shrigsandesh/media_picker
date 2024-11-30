import 'package:flutter/material.dart';
import 'package:media_picker/src/widgets/thumbnail_skeleton.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetThumbnail extends StatefulWidget {
  const AssetThumbnail(
      {super.key,
      this.asset,
      this.thumbnailSize,
      this.borderRadius,
      this.showSkeleton = true});

  final AssetEntity? asset;
  final ThumbnailSize? thumbnailSize;
  final double? borderRadius;
  final bool? showSkeleton;

  @override
  State<AssetThumbnail> createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail>
    with AutomaticKeepAliveClientMixin {
  ImageProvider? imageProvider;
  late ImageStreamListener _imageListener;
  bool isImageLoaded = false;
  late ThumbnailSize _thumbnailSize;

  @override
  void initState() {
    super.initState();
    _thumbnailSize = widget.thumbnailSize ?? const ThumbnailSize.square(200);
    loadThumbnailImage();
  }

  void loadThumbnailImage() async {
    final thumbnailFuture = await widget.asset?.thumbnailDataWithSize(
      _thumbnailSize,
    );
    if (thumbnailFuture == null) return;
    imageProvider = MemoryImage(thumbnailFuture);
    if (imageProvider == null) return;
    final ImageStream stream = imageProvider!.resolve(ImageConfiguration.empty);
    _imageListener = ImageStreamListener((info, __) {
      if (mounted) {
        setState(() {
          isImageLoaded = true;
        });
      }
    });
    stream.addListener(_imageListener);
  }

  @override
  void dispose() {
    if (imageProvider != null) {
      final ImageStream stream =
          imageProvider!.resolve(ImageConfiguration.empty);
      stream.removeListener(_imageListener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: (imageProvider != null && isImageLoaded)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 1),
              child: Image(
                image: imageProvider!,
                filterQuality: FilterQuality.low,
                fit: BoxFit.cover,
                height: _thumbnailSize.height.toDouble(),
                width: _thumbnailSize.width.toDouble(),
              ),
            )
          : widget.showSkeleton == true
              ? ThumbnailSkeleton(
                  borderRadius: widget.borderRadius ?? 1,
                  size: widget.thumbnailSize?.height.toDouble(),
                )
              : const SizedBox.shrink(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
