import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/media_picker.dart';
import 'package:media_picker/src/all_media_picker_page.dart';
import 'package:media_picker/src/cubit/common_media_cubit.dart';
import 'package:media_picker/src/cubit/media_state.dart';
import 'package:media_picker/src/cubit/photo_cubit.dart';

import 'package:media_picker/src/cubit/selection/media_selection_cubit.dart';
import 'package:media_picker/src/cubit/video_cubit.dart';
import 'package:media_picker/src/widgets/widgets_.dart';

class MediaPickerPage extends StatelessWidget {
  const MediaPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MediaSelectionCubit()..loadAlbums(),
        ),
        BlocProvider(
          create: (context) => CommonMediaCubit()..loadMedias(),
        ),
        BlocProvider(
          create: (context) => PhotoCubit()..loadPhotos(),
        ),
        BlocProvider(
          create: (context) => VideoCubit()..loadVideos(),
        ),
      ],
      child: Scaffold(
        body: BlocListener<MediaSelectionCubit, MediaSelectionState>(
          listenWhen: (previous, current) =>
              previous.media.name != current.media.name,
          listener: (context, state) => {
            context.read<CommonMediaCubit>().updateMedias(state.media.common),
            context.read<PhotoCubit>().updatePhotos(state.media.photos),
            context.read<VideoCubit>().updateVideos(state.media.videos),
          },
          child: SafeArea(
              child: Stack(
            children: [
              const MediaTabWidget(
                mediaTypes: [
                  MediaType.common,
                  MediaType.video,
                  MediaType.image,
                ],
              ),
              Positioned(
                bottom: 0,
                child: SelectedMediasBottomSheet(
                  pickedMediaCallback: (medias) {},
                ),
              ),
              MediaPickerAppBarSection(),
            ],
          )),
        ),
      ),
    );
  }
}

class MediaTabWidget extends StatefulWidget {
  const MediaTabWidget({super.key, required this.mediaTypes});

  final List<MediaType> mediaTypes;

  @override
  State<MediaTabWidget> createState() => _MediaTabWidgetState();
}

class _MediaTabWidgetState extends State<MediaTabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.mediaTypes.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight - 8),
      child: Column(
        children: [
          MediaTabBar(
            tabController: _tabController,
            mediaTypes: widget.mediaTypes,
            tabBarDecoration: const TabBarDecoration(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.mediaTypes.map((mediaType) {
                switch (mediaType) {
                  case MediaType.common:
                    return BlocBuilder<CommonMediaCubit, MediaState>(
                      builder: (context, state) {
                        return MediaGrid(
                          isLoading: state.isLoading,
                          medias: state.medias,
                          name: 'media',
                          allowMultiple: true,
                          mediaType: mediaType,
                        );
                      },
                    );
                  case MediaType.video:
                    return BlocBuilder<VideoCubit, MediaState>(
                      builder: (context, state) {
                        return MediaGrid(
                          isLoading: state.isLoading,
                          medias: state.medias,
                          name: 'video',
                          allowMultiple: true,
                          mediaType: mediaType,
                        );
                      },
                    );
                  case MediaType.image:
                    return BlocBuilder<PhotoCubit, MediaState>(
                      builder: (context, state) {
                        return MediaGrid(
                          isLoading: state.isLoading,
                          medias: state.medias,
                          name: 'photo',
                          allowMultiple: true,
                          mediaType: mediaType,
                        );
                      },
                    );
                  default:
                    return const SizedBox.shrink();
                }
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
