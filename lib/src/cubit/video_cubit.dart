import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/cubit/media_state.dart';
import 'package:photo_manager/photo_manager.dart';

class VideoCubit extends Cubit<MediaState> {
  VideoCubit() : super(const MediaState());

  void loadVideos([bool isPaginating = false]) async {
    emit(state.copyWith(isLoading: true));
    List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: RequestType.video);

    int end = await albums[0].assetCountAsync;
    var videos = await albums[0].getAssetListRange(start: 0, end: end);
    emit(state.copyWith(isLoading: false, medias: videos));
  }

  void updateVideos(List<AssetEntity> medias) {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(medias: medias, isLoading: false));
  }
}
