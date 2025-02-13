import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:media_picker/src/widgets/animated_expand_icon.dart';
import 'package:media_picker/src/widgets/asset_thumbnail.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MediaAppBar extends StatefulWidget {
  const MediaAppBar(
      {super.key,
      required this.mediaAlbum,
      required this.onChanged,
      this.albumDropdownColor,
      this.albumTile,
      this.albumButtonBuilder,
      this.dropdownButtonColor});

  final List<MediaAlbum> mediaAlbum;
  final Function(MediaAlbum) onChanged;
  final Color? albumDropdownColor;
  final AlbumTileBuilder? albumTile;
  final AlbumDropdownButtonBuilder? albumButtonBuilder;
  final Color? dropdownButtonColor;

  @override
  State<MediaAppBar> createState() => _MediaAppBarState();
}

class _MediaAppBarState extends State<MediaAppBar> {
  bool _isExpanded = false;
  String? _selected;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        height: _isExpanded
            ? MediaQuery.of(context).size.height
            : kToolbarHeight - 8,
        decoration:
            BoxDecoration(color: widget.albumDropdownColor ?? Colors.white),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close),
                  ),
                  GestureDetector(onTap: () {
                    if (widget.mediaAlbum.isEmpty) return;
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  }, child: SizedBox(
                    child: BlocBuilder<MediaPickerCubit, MediaPickerState>(
                      builder: (context, state) {
                        return widget.albumButtonBuilder != null
                            ? widget.albumButtonBuilder!(
                                state.isLoading, _selected ?? '', _isExpanded)
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                    color: widget.dropdownButtonColor ??
                                        const Color(0xFFD3D3D3),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    Skeletonizer(
                                      enabled: state.isLoading &&
                                          state.albums.isEmpty,
                                      child: Text(
                                        _selected ?? state.media.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    AnimatedExpansionIcon(
                                        isExpanded: _isExpanded),
                                  ],
                                ),
                              );
                      },
                    ),
                  )),
                  const SizedBox.shrink(),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: widget.mediaAlbum.length,
                itemBuilder: (context, index) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      _selected = widget.mediaAlbum[index].name;
                      widget.onChanged(MediaAlbum(
                          id: widget.mediaAlbum[index].id,
                          name: _selected ?? '',
                          size: widget.mediaAlbum[index].size));
                      _isExpanded = false;
                    });
                  },
                  child: widget.albumTile != null
                      ? Builder(
                          builder: (context) {
                            return widget.albumTile!(
                                context, widget.mediaAlbum[index]);
                          },
                        )
                      : Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: SizedBox.square(
                                dimension: 80,
                                child: AssetThumbnail(
                                    asset: widget.mediaAlbum[index].thumbnail),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.mediaAlbum[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.mediaAlbum[index].size.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
