import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/utils/utils.dart';
import 'package:media_picker/src/widgets/loading_grid_shimmer.dart';
import 'package:media_picker/src/widgets/media_grid.dart';
import 'package:media_picker/src/widgets/media_picker_app_bar.dart';
import 'package:media_picker/src/widgets/selected_medias.dart';

class MediaPickerPage extends StatefulWidget {
  const MediaPickerPage({super.key, required this.mediaType});

  final MediaType mediaType;

  @override
  State<MediaPickerPage> createState() => _MediaPickerPageState();
}

class _MediaPickerPageState extends State<MediaPickerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaPickerCubit()..loadMedia(widget.mediaType),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<MediaPickerCubit, MediaPickerState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Padding(
                        padding: EdgeInsets.only(top: kToolbarHeight),
                        child: LoadingGridShimmer());
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: kToolbarHeight - 8),
                    child: MediaGrid(
                      medias: getMediaType(widget.mediaType, state),
                      name: widget.mediaType.name,
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 0,
                child: BlocBuilder<MediaPickerCubit, MediaPickerState>(
                  builder: (context, state) =>
                      SelectedMedias(pickedVideos: state.pickedFiles),
                ),
              ),
              BlocBuilder<MediaPickerCubit, MediaPickerState>(
                buildWhen: (previous, current) =>
                    previous.albums != current.albums,
                builder: (context, state) {
                  return MediaAppBar(
                      mediaAlbum: state.albums,
                      onChanged: (albumName) {
                        context.read<MediaPickerCubit>().changeAlbum(albumName);
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  getMediaType(MediaType mediaType, MediaPickerState state) {
    switch (mediaType) {
      case MediaType.image:
        return state.media.photos;

      case MediaType.video:
        return state.media.videos;

      default:
        return state.media.common;
    }
  }
}
