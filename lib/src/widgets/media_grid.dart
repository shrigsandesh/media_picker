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
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        final cubit = context.read<MediaPickerCubit>();
        final state = cubit.state;

        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent * 0.8 &&
            !state.isLoading &&
            !state.hasReachedEnd) {
          cubit.loadMoreMedia(pageSize: widget.pageSize);
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _checkAndFetchNextPageIfNeeded(MediaPickerCubit cubit) {
    final state = cubit.state;

    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0 && !state.isLoading && !state.hasReachedEnd) {
      cubit.loadMoreMedia(pageSize: widget.pageSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaGridBuilder != null) {
      return widget.mediaGridBuilder!(context);
    } else {
      return BlocConsumer<MediaPickerCubit, MediaPickerState>(
        listener: (context, state) {
          final cubit = context.read<MediaPickerCubit>();
          if (!state.isLoading && widget.medias.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _checkAndFetchNextPageIfNeeded(cubit);
            });
          }
        },
        builder: (context, state) {
          if (state.isLoading && widget.medias.isEmpty) {
            return Center(
              child: widget.thumbnailShimmer ??
                  ThumbnailSkeleton(
                    borderRadius:
                        widget.thumbnailBorderRadius ?? kThumbnailBorderRadius,
                  ),
            );
          }

          if (widget.medias.isEmpty) {
            return Center(
                child: Text("No ${widget.name} found for this album."));
          }

          return GridView.builder(
            controller: _scrollController,
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
                onTap: () =>
                    widget.onSingleFileSelection?.call(widget.medias[index]),
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
                            children: [
                              const Icon(Icons.videocam,
                                  size: 18, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                video.duration.formattedDuration,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }
}

extension DurationFormat on int {
  String get formattedDuration {
    final minutes = ((this % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (this % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
