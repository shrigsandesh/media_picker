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

class DefaultAlbumButton extends StatelessWidget {
  const DefaultAlbumButton({
    super.key,
    this.dropdownButtonColor,
    required this.isEnabled,
    required this.name,
    required this.isExpanded,
  });

  final Color? dropdownButtonColor;
  final bool isEnabled;
  final String name;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(
              color: dropdownButtonColor ?? const Color(0xFFD3D3D3),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Skeletonizer(
                  enabled: isEnabled,
                  child: Skeleton.shade(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              AnimatedExpansionIcon(
                isExpanded: isExpanded,
              ),
            ],
          ),
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
