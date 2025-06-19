import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/constants/typedefs.dart';
import 'package:media_picker/src/cubit/media_picker_cubit.dart';
import 'package:media_picker/src/model/media_model.dart';
import 'package:media_picker/src/widgets/default_widgets.dart';

class MediaAppBar extends StatefulWidget {
  const MediaAppBar({
    super.key,
    required this.mediaAlbum,
    required this.onChanged,
    this.albumDropdownColor,
    this.albumTile,
    this.albumButtonBuilder,
    this.dropdownButtonColor,
    this.showCircularPlaceholder,
    this.closeIcon,
    this.closeIconColor,
    this.albumNameStyle,
    this.albumCountStyle,
    this.customAlbum,
    this.onClose,
  });

  final List<MediaAlbum> mediaAlbum;
  final Function(MediaAlbum) onChanged;
  final Color? albumDropdownColor;
  final AlbumTileBuilder? albumTile;
  final AlbumDropdownButtonBuilder? albumButtonBuilder;
  final Color? dropdownButtonColor;

  final bool? showCircularPlaceholder;

  final Widget? closeIcon;
  final Color? closeIconColor;
  final TextStyle? albumNameStyle;
  final TextStyle? albumCountStyle;
  final MediaAlbum? customAlbum;

  final VoidCallback? onClose;

  @override
  State<MediaAppBar> createState() => _MediaAppBarState();
}

class _MediaAppBarState extends State<MediaAppBar> {
  bool _isExpanded = false;
  String? _selected;

  List<MediaAlbum> get _mediaAlbum {
    if (widget.customAlbum != null && !widget.customAlbum.isEmpty()) {
      return [widget.customAlbum!, ...widget.mediaAlbum];
    }
    return widget.mediaAlbum;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        decoration: BoxDecoration(
          color: widget.albumDropdownColor ?? Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Fixed Row with close icon and toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    if (widget.onClose != null) {
                      widget.onClose!();
                    }
                  },
                  child: widget.closeIcon ??
                      Icon(
                        Icons.close,
                        color: widget.closeIconColor,
                      ),
                ),
                GestureDetector(onTap: () {
                  if (_mediaAlbum.isEmpty) return;
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                }, child: SizedBox(
                  child: BlocBuilder<MediaPickerCubit, MediaPickerState>(
                    builder: (context, state) {
                      final name = _selected ??
                          ((widget.customAlbum != null &&
                                  !widget.customAlbum!.isEmpty())
                              ? (widget.customAlbum?.name ?? state.media.name)
                              : state.media.name);
                      final isEnabled = state.isLoading && _mediaAlbum.isEmpty;
                      return widget.albumButtonBuilder != null
                          ? widget.albumButtonBuilder!(
                              isEnabled, name, _isExpanded)
                          : DefaultAlbumButton(
                              dropdownButtonColor: widget.dropdownButtonColor,
                              isEnabled: isEnabled,
                              name: name,
                              isExpanded: _isExpanded,
                            );
                    },
                  ),
                )),
                const SizedBox.shrink(),
              ],
            ),

            /// Animated dropdown section
            Flexible(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: Offstage(
                  offstage: !_isExpanded,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView.separated(
                      itemCount: _mediaAlbum.length,
                      itemBuilder: (context, index) => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            _selected = _mediaAlbum[index].name;
                            widget.onChanged(MediaAlbum(
                              id: _mediaAlbum[index].id,
                              name: _selected ?? '',
                              size: _mediaAlbum[index].size,
                            ));
                            _isExpanded = false;
                          });
                        },
                        child: widget.albumTile != null
                            ? Builder(
                                builder: (context) {
                                  return widget.albumTile!(
                                      context, _mediaAlbum[index]);
                                },
                              )
                            : DefaultAlbumTile(
                                mediaAlbum: _mediaAlbum[index],
                                albumNameStyle: widget.albumNameStyle,
                                albumCountStyle: widget.albumCountStyle,
                              ),
                      ),
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
