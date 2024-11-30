import 'package:flutter/material.dart';
import 'package:media_picker/src/widgets/thumbnail_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingGridShimmer extends StatelessWidget {
  const LoadingGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 20,
        itemBuilder: (context, index) {
          return const ThumbnailSkeleton(borderRadius: 10);
        },
      ),
    );
  }
}
