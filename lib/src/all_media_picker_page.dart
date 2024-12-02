import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/utils/tab_bar_decoration.dart';
import 'package:media_picker/src/widgets/loading_grid_shimmer.dart';
import 'package:media_picker/src/widgets/media_grid.dart';
import 'package:media_picker/src/widgets/media_picker_app_bar.dart';
import 'package:media_picker/src/widgets/selected_medias.dart';

class AllMediaPickerPage extends StatefulWidget {
  const AllMediaPickerPage(
      {super.key, required this.allowMultiple, this.tabBarDecoration});

  final bool allowMultiple;
  final TabBarDecoration? tabBarDecoration;

  @override
  State<AllMediaPickerPage> createState() => _AllMediaPickerPageState();
}

class _AllMediaPickerPageState extends State<AllMediaPickerPage> {
  @override
  Widget build(BuildContext context) {
    log("${widget.tabBarDecoration}");
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
                      ColoredBox(
                        color: widget.tabBarDecoration?.backgroundColor ??
                            Colors.white,
                        child: TabBar(
                          unselectedLabelStyle:
                              widget.tabBarDecoration?.unselectedLabelStyle ??
                                  const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                          labelStyle: widget.tabBarDecoration?.labelStyle ??
                              const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                          indicatorSize:
                              widget.tabBarDecoration?.indicatorSize ??
                                  TabBarIndicatorSize.tab,
                          indicatorColor:
                              widget.tabBarDecoration?.indicatorColor ??
                                  Colors.black,
                          indicator: widget.tabBarDecoration?.indicator,
                          tabs: const [
                            Tab(text: 'All'),
                            Tab(text: 'Video'),
                            Tab(text: 'Photos'),
                          ],
                        ),
                      ),
                      BlocBuilder<MediaPickerCubit, MediaPickerState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Expanded(child: LoadingGridShimmer());
                          }
                          return Expanded(
                            child: TabBarView(
                              children: [
                                MediaGrid(
                                  medias: state.media.common,
                                  name: "media",
                                  allowMultiple: widget.allowMultiple,
                                ),
                                MediaGrid(
                                  medias: state.media.videos,
                                  name: 'videos',
                                  allowMultiple: widget.allowMultiple,
                                ),
                                MediaGrid(
                                  medias: state.media.photos,
                                  name: "photos",
                                  allowMultiple: widget.allowMultiple,
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
                  builder: (context, state) => SelectedMedias(
                    pickedVideos: state.pickedFiles,
                    onPicked: (assets) {},
                  ),
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
