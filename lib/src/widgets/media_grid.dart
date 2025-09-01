import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
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
    this.videoIconBuilder,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    this.assetGrouper,
    this.groupDateBuilder,
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
  final VideoIconBuilder? videoIconBuilder;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final AssetGrouperCallback? assetGrouper;
  final AssetsGroupDateBuilder? groupDateBuilder;
  @override
  State<MediaGrid> createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<MediaPickerCubit>();

    debugPrint("Media Grid for ${cubit.state.currentAlubm.name} Initialized");
    _scrollController = ScrollController()
      ..addListener(() {
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
    debugPrint("Media Grid Destroyed");

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
            return _loadingBuilder();
          }

          if (widget.medias.isEmpty) {
            return Center(
                child: Text("No ${widget.name} found for this album."));
          }
          final grouped = widget.assetGrouper?.call(widget.medias);
          if (grouped == null) {
            return GridView.builder(
              controller: _scrollController,
              padding: widget.contentPadding ??
                  const EdgeInsets.fromLTRB(0, 0, 0, 100),
              gridDelegate: _gridDelegate(),
              itemCount: widget.medias.length +
                  (state.isLoading && widget.medias.isNotEmpty ? 1 : 0),
              cacheExtent: 1000,
              itemBuilder: (context, index) {
                return _mediaItemBuilder(widget.medias, index, context);
              },
            );
          }
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              for (final entry in grouped.entries) ...[
                SliverStickyHeader(
                  header: widget.groupDateBuilder?.call(context, entry.key),
                  sliver: SliverPadding(
                    padding: widget.contentPadding ??
                        const EdgeInsets.symmetric(horizontal: 8),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _mediaItemBuilder(entry.value, index, context);
                        },
                        childCount: entry.value.length +
                            (state.isLoading && entry.value.isNotEmpty ? 1 : 0),
                      ),
                      gridDelegate: _gridDelegate(),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      );
    }
  }

  Center _loadingBuilder() {
    return Center(
      child: widget.thumbnailShimmer ??
          ThumbnailSkeleton(
            borderRadius:
                widget.thumbnailBorderRadius ?? kThumbnailBorderRadius,
          ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _gridDelegate() {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: widget.crossAxisCount ?? kCrossAxisCount,
      childAspectRatio: 1.0,
      crossAxisSpacing: widget.crossAxisSpacing,
      mainAxisSpacing: widget.mainAxisSpacing,
    );
  }

  Widget _mediaItemBuilder(
      List<AssetEntity> assets, int index, BuildContext context) {
    if (index >= assets.length) {
      return _loadingBuilder();
    }

    final media = assets[index];
    return _mediaItem(media, context);
  }

  Widget _mediaItem(AssetEntity media, BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onSingleFileSelection?.call(media),
      child: Padding(
        padding: widget.mediaGridMargin ?? EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AssetThumbnail(
              borderRadius: widget.thumbnailBorderRadius,
              asset: media,
            ),
            if (media.duration > 0)
              widget.videoIconBuilder != null
                  ? widget.videoIconBuilder!(context, media.duration)
                  : Positioned(
                      bottom: 2,
                      right: 2,
                      child: Row(
                        children: [
                          const Icon(Icons.videocam,
                              size: 18, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            media.duration.formattedDuration,
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
  }
}

extension DurationFormat on int {
  String get formattedDuration {
    final minutes = ((this % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (this % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
