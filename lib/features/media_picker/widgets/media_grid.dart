import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaGrid extends StatelessWidget {
  const MediaGrid(
      {super.key, required this.pagingController, required this.medias});

  final PagingController<int, String> pagingController;
  final List<AssetEntity> medias;

  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, String>(
      pagingController: pagingController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of items per row
        childAspectRatio: 1.0,
      ),
      builderDelegate: PagedChildBuilderDelegate<String>(
        noMoreItemsIndicatorBuilder: (context) => const SizedBox.shrink(),
        itemBuilder: (context, item, index) => Card(
          margin: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(item),
          ),
        ),
        firstPageErrorIndicatorBuilder: (context) => const Center(
          child: Text('Error loading items'),
        ),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: Text('No items found'),
        ),
      ),
    );
  }
}
