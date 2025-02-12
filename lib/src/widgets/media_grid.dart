import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/constants/constants.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/widgets/widgets_.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaGrid extends StatefulWidget {
  const MediaGrid({
    super.key,
    required this.medias,
    required this.name,
    required this.allowMultiple,
    this.onSingleFileSelection,
    this.thumbnailBorderRadius,
    this.mediaGridMargin,
    this.thumbnailShimmer,
    this.checkedIconColor,
    this.contentPadding,
    required this.pageSize,
    required this.type,
    this.crossAxisCount,
  });
  final List<AssetEntity> medias;
  final String name;
  final bool allowMultiple;
  final Function(AssetEntity)? onSingleFileSelection;
  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridMargin;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? thumbnailShimmer;
  final Color? checkedIconColor;
  final int pageSize;
  final MediaType type;
  final int? crossAxisCount;

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
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        bool hasReachedEnd =
            context.read<MediaPickerCubit>().state.hasReachedEnd;

        if (notification is ScrollEndNotification &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent * 0.8 &&
            !context.read<MediaPickerCubit>().state.isLoading &&
            !hasReachedEnd) {
          context
              .read<MediaPickerCubit>()
              .loadMoreMedia(type: widget.type, pageSize: widget.pageSize);
        }

        return false;
      },
      child: BlocBuilder<MediaPickerCubit, MediaPickerState>(
        builder: (context, state) {
          if (state.isLoading && widget.medias.isEmpty) {
            return const Center(
                child: ThumbnailSkeleton(
              borderRadius: 12.0,
            ));
          }
          return GridView.builder(
            padding: widget.contentPadding ??
                const EdgeInsets.fromLTRB(0, 0, 0, 100),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount ?? defaultCrossAxisCount,
              childAspectRatio: 1.0,
            ),
            itemCount: widget.medias.length +
                (state.isLoading && widget.medias.isNotEmpty ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == widget.medias.length) {
                return const Center(
                  child: ThumbnailSkeleton(borderRadius: 12.0),
                );
              }
              final video = widget.medias[index];
              return BlocBuilder<MediaPickerCubit, MediaPickerState>(
                builder: (context, state) {
                  final isSelected = state.pickedFiles
                      .contains(video); // Check if video is selected
                  final selectionIndex = state.pickedFiles.indexOf(video);
                  return GestureDetector(
                    onTap: () {
                      if (!widget.allowMultiple) {
                        if (widget.onSingleFileSelection != null) {
                          widget.onSingleFileSelection!(video);
                        }
                        return;
                      }
                      if (!isSelected) {
                        context.read<MediaPickerCubit>().addPickedFiles(video);
                      } else {
                        context.read<MediaPickerCubit>().removeSelected(video);
                      }
                    },
                    child: Padding(
                      padding: widget.mediaGridMargin ?? EdgeInsets.zero,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AssetThumbnail(
                            borderRadius: widget.thumbnailBorderRadius,
                            asset: widget.medias[index],
                          ),
                          if (widget.allowMultiple)
                            Positioned(
                                top: 4,
                                right: 4,
                                child: isSelected
                                    ? CircleAvatar(
                                        radius: 12,
                                        backgroundColor:
                                            widget.checkedIconColor ??
                                                Colors.blue,
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
                                      )),
                          if (video.duration > 0)
                            Positioned(
                                bottom: 2,
                                right: 2,
                                child: Row(
                                  spacing: 4.0,
                                  children: [
                                    Icon(
                                      Icons.videocam,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      formatTime(video.duration),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ))
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

String formatTime(int timeInSeconds) {
  final minutes = ((timeInSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
  final seconds = (timeInSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
