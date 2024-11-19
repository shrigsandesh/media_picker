import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_picker/features/media_picker/bloc/media_picker_event.dart';
import 'package:media_picker/features/media_picker/bloc/media_picker_state.dart';

class MediaPickerBloc extends Bloc<MediaPickerEvent, MediaPickerState> {
  MediaPickerBloc() : super(MediaPickerState()) {
    // on<LoadHistory>(_onHistoryLoad);
  }
}
