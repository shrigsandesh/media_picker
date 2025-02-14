import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/widgets/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';

class SelectedMedias extends StatelessWidget {
  const SelectedMedias({
    super.key,
    required this.pickedVideos,
    required this.onPicked,
    this.showCircularPlaceholder,
  });

  final List<AssetEntity> pickedVideos;
  final Function(List<AssetEntity>) onPicked;

  final bool? showCircularPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (pickedVideos.isNotEmpty)
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                itemCount: pickedVideos.length,
                itemBuilder: (context, index) {
                  final video = pickedVideos[index];

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Stack(
                      children: [
                        AssetThumbnail(
                          key: ValueKey(video.id),
                          asset: video,
                          thumbnailSize: const ThumbnailSize(60, 80),
                          borderRadius: 10,
                          showSkeleton: false,
                          showCircularPlaceholder: showCircularPlaceholder,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: .5),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0))),
                            child: InkWell(
                                onTap: () {
                                  context
                                      .read<MediaPickerCubit>()
                                      .removeSelected(video);
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                )),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          _SelectedButton(
              selectedCount: pickedVideos.length,
              onPressed: () {
                onPicked(pickedVideos);
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }
}

class _SelectedButton extends StatelessWidget {
  const _SelectedButton({required this.onPressed, required this.selectedCount});
  final VoidCallback onPressed;
  final int selectedCount;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 45,
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.blue),
          child: Center(
            child: Text(
              "Selected ($selectedCount)",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ));
  }
}
