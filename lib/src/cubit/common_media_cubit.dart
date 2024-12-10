import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/src/cubit/media_state.dart';
import 'package:photo_manager/photo_manager.dart';

class CommonMediaCubit extends Cubit<MediaState> {
  CommonMediaCubit() : super(const MediaState());

  void loadMedias([bool isPaginating = false]) async {
    emit(state.copyWith(isLoading: true));
    List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: RequestType.common);

    int end = await albums[0].assetCountAsync;
    var medias = await albums[0].getAssetListRange(start: 0, end: end);

    emit(state.copyWith(isLoading: false, medias: medias));
  }

  void updateMedias(List<AssetEntity> medias) {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(medias: medias, isLoading: false));
  }
}
