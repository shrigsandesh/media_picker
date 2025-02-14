import 'package:flutter/material.dart';
import 'package:media_picker/src/constants/constants.dart';
import 'package:media_picker/src/widgets/thumbnail_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingGridShimmer extends StatelessWidget {
  const LoadingGridShimmer({
    super.key,
    this.borderRadius,
    this.crossAxisCount,
    this.pageSize,
    this.showCircularPlaceholder,
  });

  final double? borderRadius;
  final int? crossAxisCount;
  final int? pageSize;
  final bool? showCircularPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount ?? kCrossAxisCount),
        itemCount: pageSize ?? kPageSize,
        itemBuilder: (context, index) {
          return ThumbnailSkeleton(
              borderRadius: borderRadius ?? kThumbnailBorderRadius,
              showCircularPlaceholder: showCircularPlaceholder);
        },
      ),
    );
  }
}
