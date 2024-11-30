import 'package:flutter/material.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:media_picker/src/widgets/animated_expand_icon.dart';
import 'package:media_picker/src/widgets/asset_thumbnail.dart';

class MediaAppBar extends StatefulWidget {
  const MediaAppBar(
      {super.key, required this.mediaAlbum, required this.onChanged});

  final List<MediaAlbum> mediaAlbum;
  final Function(String) onChanged;
  @override
  State<MediaAppBar> createState() => _MediaAppBarState();
}

class _MediaAppBarState extends State<MediaAppBar> {
  bool _isExpanded = false;
  late String _selected =
      widget.mediaAlbum.isNotEmpty ? widget.mediaAlbum.first.name : "All";
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
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: const Color(0xFFD3D3D3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Text(
                            _selected,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 5),
                          AnimatedExpansionIcon(isExpanded: _isExpanded),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox.shrink(),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                // padding: const EdgeInsets.only(top: 20),
                itemCount: widget.mediaAlbum.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selected = widget.mediaAlbum[index].name;
                      widget.onChanged(_selected);
                      _isExpanded = false;
                    });
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          height: 80,
                          width: 80,
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
