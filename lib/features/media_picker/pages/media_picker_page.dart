import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:media_picker/features/media_picker/bloc/media_picker_bloc.dart';
import 'package:media_picker/features/media_picker/widgets/media_app_bar.dart';
import 'package:media_picker/features/media_picker/widgets/media_grid.dart';

class MediaPickerPage extends StatefulWidget {
  const MediaPickerPage({super.key});

  @override
  State<MediaPickerPage> createState() => _MediaPickerPageState();
}

class _MediaPickerPageState extends State<MediaPickerPage>
    with SingleTickerProviderStateMixin {
  final PagingController<int, String> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // Simulating a network request with a delay
      await Future.delayed(const Duration(seconds: 2));

      // Example data fetching logic
      final newItems = List.generate(
        80,
        (index) => 'Item ${(pageKey - 1) * 80 + index + 1}',
      );

      final isLastPage = newItems.length < 80;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) =>
          MediaPickerBloc()..add(const MediaPickerEvent.initial()),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: 'All'),
                          Tab(text: 'Video'),
                          Tab(text: 'Photos'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(children: [
                          MediaGrid(
                              pagingController: _pagingController,
                              medias: const []),
                          MediaGrid(
                              pagingController: _pagingController,
                              medias: const []),
                          MediaGrid(
                              pagingController: _pagingController,
                              medias: const []),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<MediaPickerBloc, MediaPickerState>(
                builder: (context, state) {
                  return state.maybeMap(
                    loaded: (loaded) => MediaAppBar(
                      mediaAlbum: loaded.albums,
                    ),
                    orElse: () => const MediaAppBar(
                      mediaAlbum: [],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
