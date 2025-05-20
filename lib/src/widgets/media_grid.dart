import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/constants/constants.dart';
import 'package:media_picker/src/constants/enums.dart';
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/widgets/widgets_.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaGrid extends StatefulWidget {
  const MediaGrid({
    super.key,
    required this.medias,
    required this.name,
    this.onSingleFileSelection,
    this.thumbnailBorderRadius,
    this.mediaGridMargin,
    this.thumbnailShimmer,
    this.contentPadding,
    required this.pageSize,
    required this.type,
    this.crossAxisCount,
    this.mediaGridBuilder,
  });
  final List<AssetEntity> medias;
  final String name;
  final Function(AssetEntity)? onSingleFileSelection;
  final double? thumbnailBorderRadius;
  final EdgeInsetsGeometry? mediaGridMargin;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? thumbnailShimmer;
  final int pageSize;
  final MediaType type;
  final int? crossAxisCount;
  final MediaGridBuilder? mediaGridBuilder;

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

        if (notification is ScrollUpdateNotification &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent * 0.8 &&
            !context.read<MediaPickerCubit>().state.isLoading &&
            !hasReachedEnd) {
          context
              .read<MediaPickerCubit>()
              .loadMoreMedia(pageSize: widget.pageSize);
        }

        return false;
      },
      child: BlocBuilder<MediaPickerCubit, MediaPickerState>(
        builder: (context, state) {
          if (state.isLoading && widget.medias.isEmpty) {
            return Center(
                child: widget.thumbnailShimmer ??
                    ThumbnailSkeleton(
                      borderRadius: widget.thumbnailBorderRadius ??
                          kThumbnailBorderRadius,
                    ));
          }
          if (widget.mediaGridBuilder != null) {
            return widget.mediaGridBuilder!(context);
          }
          return GridView.builder(
            key: const PageStorageKey("asset_grid"),
            padding: widget.contentPadding ??
                const EdgeInsets.fromLTRB(0, 0, 0, 100),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount ?? kCrossAxisCount,
              childAspectRatio: 1.0,
            ),
            itemCount: widget.medias.length +
                (state.isLoading && widget.medias.isNotEmpty ? 1 : 0),
            cacheExtent: 1000,
            itemBuilder: (context, index) {
              if (index == widget.medias.length) {
                return Center(
                  child: widget.thumbnailShimmer ??
                      ThumbnailSkeleton(
                        borderRadius: widget.thumbnailBorderRadius ??
                            kThumbnailBorderRadius,
                      ),
                );
              }
              final video = widget.medias[index];
              return GestureDetector(
                onTap: () {
                  if (widget.onSingleFileSelection != null) {
                    widget.onSingleFileSelection!(video);
                  }
                  return;
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
                      if (video.duration > 0)
                        Positioned(
                            bottom: 2,
                            right: 2,
                            child: Row(
                              spacing: 4.0,
                              children: [
                                const Icon(
                                  Icons.videocam,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                Text(
                                  video.duration.formattedDuration,
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
      ),
    );
  }
}

extension DurationFormat on int {
  String get formattedDuration {
    final minutes = ((this % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (this % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
