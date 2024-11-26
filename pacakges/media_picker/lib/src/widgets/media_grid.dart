import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/widgets/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaGrid extends StatefulWidget {
  const MediaGrid({
    super.key,
    required this.medias,
    required this.name,
  });
  final List<AssetEntity> medias;
  final String name;

  @override
  State<MediaGrid> createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  @override
  Widget build(BuildContext context) {
    if (widget.medias.isEmpty) {
      return Center(
        child: Text("No ${widget.name} found for this album."),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of items per row
        childAspectRatio: 1.0,
      ),
      itemCount: widget.medias.length,
      itemBuilder: (context, index) {
        final video = widget.medias[index];
        return Stack(
          fit: StackFit.expand,
          children: [
            AssetThumbnail(
              asset: widget.medias[index],
            ),
            BlocBuilder<MediaPickerCubit, MediaPickerState>(
              builder: (context, state) {
                final isSelected = state.pickedFiles
                    .contains(video); // Check if video is selected
                final selectionIndex = state.pickedFiles.indexOf(video);

                return Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                        onTap: () {
                          if (!isSelected) {
                            context
                                .read<MediaPickerCubit>()
                                .addPickedFiles(video);
                          } else {
                            context
                                .read<MediaPickerCubit>()
                                .removeSelected(video);
                          }
                        },
                        child: isSelected
                            ? CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.blue,
                                child: Text(
                                  // Display the order number (1-based index)
                                  (selectionIndex + 1).toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : Icon(
                                isSelected
                                    ? Icons.check
                                    : Icons.circle_outlined,
                                color: Colors.white,
                              )));
              },
            ),
            if (video.duration > 0)
              Positioned(
                  bottom: 2,
                  right: 2,
                  child: Text(
                    formatTime(video.duration),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ))
          ],
        );
      },
    );
  }
}

String formatTime(int timeInSeconds) {
  final minutes = ((timeInSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
  final seconds = (timeInSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
