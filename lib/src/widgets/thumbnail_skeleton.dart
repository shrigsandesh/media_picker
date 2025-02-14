import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ThumbnailSkeleton extends StatelessWidget {
  const ThumbnailSkeleton({
    super.key,
    required this.borderRadius,
    this.size,
    this.showCircularPlaceholder,
  });

  final double borderRadius;
  final double? size;
  final bool? showCircularPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: Container(
        margin: const EdgeInsets.all(1),
        child: Stack(
          children: [
            Bone.square(
              size: size ?? 200.0,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            if (showCircularPlaceholder ?? false)
              Positioned(
                top: 2,
                right: 4,
                child: Icon(
                  Icons.circle,
                  color: Colors.grey.shade300,
                ),
              )
          ],
        ),
      ),
    );
  }
}
