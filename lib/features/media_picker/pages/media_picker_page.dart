import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/features/media_picker/bloc/media_picker_cubit.dart';
import 'package:media_picker/features/media_picker/widgets/media_app_bar.dart';
import 'package:media_picker/features/media_picker/widgets/media_grid.dart';
import 'package:media_picker/features/media_picker/widgets/selected_medias.dart';

class MediaPickerPage extends StatefulWidget {
  const MediaPickerPage({super.key});

  @override
  State<MediaPickerPage> createState() => _MediaPickerPageState();
}

class _MediaPickerPageState extends State<MediaPickerPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => MediaPickerCubit()..loadMedia(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight - 8),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const ColoredBox(
                        color: Colors.white,
                        child: TabBar(
                          unselectedLabelStyle: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w500),
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor: Colors.black,
                          tabs: [
                            Tab(text: 'All'),
                            Tab(text: 'Video'),
                            Tab(text: 'Photos'),
                          ],
                        ),
                      ),
                      BlocBuilder<MediaPickerCubit, MediaPickerState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return Expanded(
                            child: TabBarView(
                              children: [
                                MediaGrid(
                                  medias: state.media.common,
                                  name: "media",
                                ),
                                MediaGrid(
                                  medias: state.media.videos,
                                  name: 'videos',
                                ),
                                MediaGrid(
                                  medias: state.media.photos,
                                  name: "photos",
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: BlocBuilder<MediaPickerCubit, MediaPickerState>(
                  builder: (context, state) =>
                      SelectedMedias(pickedVideos: state.pickedFiles),
                ),
              ),
              BlocBuilder<MediaPickerCubit, MediaPickerState>(
                builder: (context, state) {
                  return MediaAppBar(
                    onChanged: (albumName) =>
                        context.read<MediaPickerCubit>().changeAlbum(albumName),
                    mediaAlbum: state.albums,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
