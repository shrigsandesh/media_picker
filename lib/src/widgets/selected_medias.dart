import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/widgets/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';

class SelectedMedias extends StatelessWidget {
  const SelectedMedias({super.key, required this.pickedVideos});

  final List<AssetEntity> pickedVideos;

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
                          thumbnailSize: const ThumbnailSize.square(80),
                          borderRadius: 10,
                          showSkeleton: false,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: ColoredBox(
                            color: Colors.grey,
                            child: InkWell(
                                onTap: () {
                                  context
                                      .read<MediaPickerCubit>()
                                      .removeSelected(video);
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.black,
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
                //navigate to next screen
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
