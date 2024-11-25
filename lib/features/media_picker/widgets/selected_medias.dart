import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/features/media_picker/bloc/media_picker_cubit.dart';
import 'package:media_picker/features/media_picker/widgets/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';

class SelectedMedias extends StatelessWidget {
  const SelectedMedias({super.key, required this.pickedVideos});

  final List<AssetEntity> pickedVideos;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pickedVideos.length,
        itemBuilder: (context, index) {
          final video = pickedVideos[index];

          return GestureDetector(
            onTap: () {
              context.read<MediaPickerCubit>().removeSelected(video);
            },
            child: AssetThumbnail(
              key: ValueKey(video.id),
              asset: video,
            ),
          );
        },
      ),
    );
  }
}
