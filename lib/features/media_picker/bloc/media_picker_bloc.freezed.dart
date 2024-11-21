// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_picker_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MediaPickerState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<MediaAlbum> albums) loaded,
    required TResult Function(String message) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<MediaAlbum> albums)? loaded,
    TResult? Function(String message)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<MediaAlbum> albums)? loaded,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Failure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Failure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaPickerStateCopyWith<$Res> {
  factory $MediaPickerStateCopyWith(
          MediaPickerState value, $Res Function(MediaPickerState) then) =
      _$MediaPickerStateCopyWithImpl<$Res, MediaPickerState>;
}

/// @nodoc
class _$MediaPickerStateCopyWithImpl<$Res, $Val extends MediaPickerState>
    implements $MediaPickerStateCopyWith<$Res> {
  _$MediaPickerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaPickerState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$MediaPickerStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaPickerState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'MediaPickerState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<MediaAlbum> albums) loaded,
    required TResult Function(String message) failure,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<MediaAlbum> albums)? loaded,
    TResult? Function(String message)? failure,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<MediaAlbum> albums)? loaded,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Failure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Failure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements MediaPickerState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
          _$LoadedImpl value, $Res Function(_$LoadedImpl) then) =
      __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<MediaAlbum> albums});
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$MediaPickerStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
      _$LoadedImpl _value, $Res Function(_$LoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaPickerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? albums = null,
  }) {
    return _then(_$LoadedImpl(
      null == albums
          ? _value._albums
          : albums // ignore: cast_nullable_to_non_nullable
              as List<MediaAlbum>,
    ));
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(final List<MediaAlbum> albums) : _albums = albums;

  final List<MediaAlbum> _albums;
  @override
  List<MediaAlbum> get albums {
    if (_albums is EqualUnmodifiableListView) return _albums;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_albums);
  }

  @override
  String toString() {
    return 'MediaPickerState.loaded(albums: $albums)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            const DeepCollectionEquality().equals(other._albums, _albums));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_albums));

  /// Create a copy of MediaPickerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<MediaAlbum> albums) loaded,
    required TResult Function(String message) failure,
  }) {
    return loaded(albums);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<MediaAlbum> albums)? loaded,
    TResult? Function(String message)? failure,
  }) {
    return loaded?.call(albums);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<MediaAlbum> albums)? loaded,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(albums);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Failure value) failure,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Failure value)? failure,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements MediaPickerState {
  const factory _Loaded(final List<MediaAlbum> albums) = _$LoadedImpl;

  List<MediaAlbum> get albums;

  /// Create a copy of MediaPickerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FailureImplCopyWith<$Res> {
  factory _$$FailureImplCopyWith(
          _$FailureImpl value, $Res Function(_$FailureImpl) then) =
      __$$FailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FailureImplCopyWithImpl<$Res>
    extends _$MediaPickerStateCopyWithImpl<$Res, _$FailureImpl>
    implements _$$FailureImplCopyWith<$Res> {
  __$$FailureImplCopyWithImpl(
      _$FailureImpl _value, $Res Function(_$FailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaPickerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$FailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FailureImpl implements _Failure {
  const _$FailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'MediaPickerState.failure(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of MediaPickerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FailureImplCopyWith<_$FailureImpl> get copyWith =>
      __$$FailureImplCopyWithImpl<_$FailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<MediaAlbum> albums) loaded,
    required TResult Function(String message) failure,
  }) {
    return failure(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<MediaAlbum> albums)? loaded,
    TResult? Function(String message)? failure,
  }) {
    return failure?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<MediaAlbum> albums)? loaded,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Failure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Failure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _Failure implements MediaPickerState {
  const factory _Failure(final String message) = _$FailureImpl;

  String get message;

  /// Create a copy of MediaPickerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FailureImplCopyWith<_$FailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MediaPickerEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int index) changeAlbum,
    required TResult Function(AssetEntity asset) addPickedMedia,
    required TResult Function(AssetEntity asset) removeMedia,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int index)? changeAlbum,
    TResult? Function(AssetEntity asset)? addPickedMedia,
    TResult? Function(AssetEntity asset)? removeMedia,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int index)? changeAlbum,
    TResult Function(AssetEntity asset)? addPickedMedia,
    TResult Function(AssetEntity asset)? removeMedia,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialEvent value) initial,
    required TResult Function(_AlbumChanged value) changeAlbum,
    required TResult Function(_PickedMediaAdded value) addPickedMedia,
    required TResult Function(_MediaRemoved value) removeMedia,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialEvent value)? initial,
    TResult? Function(_AlbumChanged value)? changeAlbum,
    TResult? Function(_PickedMediaAdded value)? addPickedMedia,
    TResult? Function(_MediaRemoved value)? removeMedia,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialEvent value)? initial,
    TResult Function(_AlbumChanged value)? changeAlbum,
    TResult Function(_PickedMediaAdded value)? addPickedMedia,
    TResult Function(_MediaRemoved value)? removeMedia,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaPickerEventCopyWith<$Res> {
  factory $MediaPickerEventCopyWith(
          MediaPickerEvent value, $Res Function(MediaPickerEvent) then) =
      _$MediaPickerEventCopyWithImpl<$Res, MediaPickerEvent>;
}

/// @nodoc
class _$MediaPickerEventCopyWithImpl<$Res, $Val extends MediaPickerEvent>
    implements $MediaPickerEventCopyWith<$Res> {
  _$MediaPickerEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaPickerEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialEventImplCopyWith<$Res> {
  factory _$$InitialEventImplCopyWith(
          _$InitialEventImpl value, $Res Function(_$InitialEventImpl) then) =
      __$$InitialEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialEventImplCopyWithImpl<$Res>
    extends _$MediaPickerEventCopyWithImpl<$Res, _$InitialEventImpl>
    implements _$$InitialEventImplCopyWith<$Res> {
  __$$InitialEventImplCopyWithImpl(
      _$InitialEventImpl _value, $Res Function(_$InitialEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaPickerEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialEventImpl implements _InitialEvent {
  const _$InitialEventImpl();

  @override
  String toString() {
    return 'MediaPickerEvent.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int index) changeAlbum,
    required TResult Function(AssetEntity asset) addPickedMedia,
    required TResult Function(AssetEntity asset) removeMedia,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int index)? changeAlbum,
    TResult? Function(AssetEntity asset)? addPickedMedia,
    TResult? Function(AssetEntity asset)? removeMedia,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int index)? changeAlbum,
    TResult Function(AssetEntity asset)? addPickedMedia,
    TResult Function(AssetEntity asset)? removeMedia,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialEvent value) initial,
    required TResult Function(_AlbumChanged value) changeAlbum,
    required TResult Function(_PickedMediaAdded value) addPickedMedia,
    required TResult Function(_MediaRemoved value) removeMedia,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialEvent value)? initial,
    TResult? Function(_AlbumChanged value)? changeAlbum,
    TResult? Function(_PickedMediaAdded value)? addPickedMedia,
    TResult? Function(_MediaRemoved value)? removeMedia,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialEvent value)? initial,
    TResult Function(_AlbumChanged value)? changeAlbum,
    TResult Function(_PickedMediaAdded value)? addPickedMedia,
    TResult Function(_MediaRemoved value)? removeMedia,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _InitialEvent implements MediaPickerEvent {
  const factory _InitialEvent() = _$InitialEventImpl;
}

/// @nodoc
abstract class _$$AlbumChangedImplCopyWith<$Res> {
  factory _$$AlbumChangedImplCopyWith(
          _$AlbumChangedImpl value, $Res Function(_$AlbumChangedImpl) then) =
      __$$AlbumChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int index});
}

/// @nodoc
class __$$AlbumChangedImplCopyWithImpl<$Res>
    extends _$MediaPickerEventCopyWithImpl<$Res, _$AlbumChangedImpl>
    implements _$$AlbumChangedImplCopyWith<$Res> {
  __$$AlbumChangedImplCopyWithImpl(
      _$AlbumChangedImpl _value, $Res Function(_$AlbumChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaPickerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
  }) {
    return _then(_$AlbumChangedImpl(
      null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AlbumChangedImpl implements _AlbumChanged {
  const _$AlbumChangedImpl(this.index);

  @override
  final int index;

  @override
  String toString() {
    return 'MediaPickerEvent.changeAlbum(index: $index)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumChangedImpl &&
            (identical(other.index, index) || other.index == index));
  }

  @override
  int get hashCode => Object.hash(runtimeType, index);

  /// Create a copy of MediaPickerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlbumChangedImplCopyWith<_$AlbumChangedImpl> get copyWith =>
      __$$AlbumChangedImplCopyWithImpl<_$AlbumChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int index) changeAlbum,
    required TResult Function(AssetEntity asset) addPickedMedia,
    required TResult Function(AssetEntity asset) removeMedia,
  }) {
    return changeAlbum(index);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int index)? changeAlbum,
    TResult? Function(AssetEntity asset)? addPickedMedia,
    TResult? Function(AssetEntity asset)? removeMedia,
  }) {
    return changeAlbum?.call(index);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int index)? changeAlbum,
    TResult Function(AssetEntity asset)? addPickedMedia,
    TResult Function(AssetEntity asset)? removeMedia,
    required TResult orElse(),
  }) {
    if (changeAlbum != null) {
      return changeAlbum(index);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialEvent value) initial,
    required TResult Function(_AlbumChanged value) changeAlbum,
    required TResult Function(_PickedMediaAdded value) addPickedMedia,
    required TResult Function(_MediaRemoved value) removeMedia,
  }) {
    return changeAlbum(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialEvent value)? initial,
    TResult? Function(_AlbumChanged value)? changeAlbum,
    TResult? Function(_PickedMediaAdded value)? addPickedMedia,
    TResult? Function(_MediaRemoved value)? removeMedia,
  }) {
    return changeAlbum?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialEvent value)? initial,
    TResult Function(_AlbumChanged value)? changeAlbum,
    TResult Function(_PickedMediaAdded value)? addPickedMedia,
    TResult Function(_MediaRemoved value)? removeMedia,
    required TResult orElse(),
  }) {
    if (changeAlbum != null) {
      return changeAlbum(this);
    }
    return orElse();
  }
}

abstract class _AlbumChanged implements MediaPickerEvent {
  const factory _AlbumChanged(final int index) = _$AlbumChangedImpl;

  int get index;

  /// Create a copy of MediaPickerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlbumChangedImplCopyWith<_$AlbumChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PickedMediaAddedImplCopyWith<$Res> {
  factory _$$PickedMediaAddedImplCopyWith(_$PickedMediaAddedImpl value,
          $Res Function(_$PickedMediaAddedImpl) then) =
      __$$PickedMediaAddedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AssetEntity asset});
}

/// @nodoc
class __$$PickedMediaAddedImplCopyWithImpl<$Res>
    extends _$MediaPickerEventCopyWithImpl<$Res, _$PickedMediaAddedImpl>
    implements _$$PickedMediaAddedImplCopyWith<$Res> {
  __$$PickedMediaAddedImplCopyWithImpl(_$PickedMediaAddedImpl _value,
      $Res Function(_$PickedMediaAddedImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaPickerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asset = null,
  }) {
    return _then(_$PickedMediaAddedImpl(
      null == asset
          ? _value.asset
          : asset // ignore: cast_nullable_to_non_nullable
              as AssetEntity,
    ));
  }
}

/// @nodoc

class _$PickedMediaAddedImpl implements _PickedMediaAdded {
  const _$PickedMediaAddedImpl(this.asset);

  @override
  final AssetEntity asset;

  @override
  String toString() {
    return 'MediaPickerEvent.addPickedMedia(asset: $asset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PickedMediaAddedImpl &&
            (identical(other.asset, asset) || other.asset == asset));
  }

  @override
  int get hashCode => Object.hash(runtimeType, asset);

  /// Create a copy of MediaPickerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PickedMediaAddedImplCopyWith<_$PickedMediaAddedImpl> get copyWith =>
      __$$PickedMediaAddedImplCopyWithImpl<_$PickedMediaAddedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int index) changeAlbum,
    required TResult Function(AssetEntity asset) addPickedMedia,
    required TResult Function(AssetEntity asset) removeMedia,
  }) {
    return addPickedMedia(asset);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int index)? changeAlbum,
    TResult? Function(AssetEntity asset)? addPickedMedia,
    TResult? Function(AssetEntity asset)? removeMedia,
  }) {
    return addPickedMedia?.call(asset);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int index)? changeAlbum,
    TResult Function(AssetEntity asset)? addPickedMedia,
    TResult Function(AssetEntity asset)? removeMedia,
    required TResult orElse(),
  }) {
    if (addPickedMedia != null) {
      return addPickedMedia(asset);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialEvent value) initial,
    required TResult Function(_AlbumChanged value) changeAlbum,
    required TResult Function(_PickedMediaAdded value) addPickedMedia,
    required TResult Function(_MediaRemoved value) removeMedia,
  }) {
    return addPickedMedia(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialEvent value)? initial,
    TResult? Function(_AlbumChanged value)? changeAlbum,
    TResult? Function(_PickedMediaAdded value)? addPickedMedia,
    TResult? Function(_MediaRemoved value)? removeMedia,
  }) {
    return addPickedMedia?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialEvent value)? initial,
    TResult Function(_AlbumChanged value)? changeAlbum,
    TResult Function(_PickedMediaAdded value)? addPickedMedia,
    TResult Function(_MediaRemoved value)? removeMedia,
    required TResult orElse(),
  }) {
    if (addPickedMedia != null) {
      return addPickedMedia(this);
    }
    return orElse();
  }
}

abstract class _PickedMediaAdded implements MediaPickerEvent {
  const factory _PickedMediaAdded(final AssetEntity asset) =
      _$PickedMediaAddedImpl;

  AssetEntity get asset;

  /// Create a copy of MediaPickerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PickedMediaAddedImplCopyWith<_$PickedMediaAddedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MediaRemovedImplCopyWith<$Res> {
  factory _$$MediaRemovedImplCopyWith(
          _$MediaRemovedImpl value, $Res Function(_$MediaRemovedImpl) then) =
      __$$MediaRemovedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AssetEntity asset});
}

/// @nodoc
class __$$MediaRemovedImplCopyWithImpl<$Res>
    extends _$MediaPickerEventCopyWithImpl<$Res, _$MediaRemovedImpl>
    implements _$$MediaRemovedImplCopyWith<$Res> {
  __$$MediaRemovedImplCopyWithImpl(
      _$MediaRemovedImpl _value, $Res Function(_$MediaRemovedImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaPickerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asset = null,
  }) {
    return _then(_$MediaRemovedImpl(
      null == asset
          ? _value.asset
          : asset // ignore: cast_nullable_to_non_nullable
              as AssetEntity,
    ));
  }
}

/// @nodoc

class _$MediaRemovedImpl implements _MediaRemoved {
  const _$MediaRemovedImpl(this.asset);

  @override
  final AssetEntity asset;

  @override
  String toString() {
    return 'MediaPickerEvent.removeMedia(asset: $asset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaRemovedImpl &&
            (identical(other.asset, asset) || other.asset == asset));
  }

  @override
  int get hashCode => Object.hash(runtimeType, asset);

  /// Create a copy of MediaPickerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaRemovedImplCopyWith<_$MediaRemovedImpl> get copyWith =>
      __$$MediaRemovedImplCopyWithImpl<_$MediaRemovedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int index) changeAlbum,
    required TResult Function(AssetEntity asset) addPickedMedia,
    required TResult Function(AssetEntity asset) removeMedia,
  }) {
    return removeMedia(asset);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int index)? changeAlbum,
    TResult? Function(AssetEntity asset)? addPickedMedia,
    TResult? Function(AssetEntity asset)? removeMedia,
  }) {
    return removeMedia?.call(asset);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int index)? changeAlbum,
    TResult Function(AssetEntity asset)? addPickedMedia,
    TResult Function(AssetEntity asset)? removeMedia,
    required TResult orElse(),
  }) {
    if (removeMedia != null) {
      return removeMedia(asset);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialEvent value) initial,
    required TResult Function(_AlbumChanged value) changeAlbum,
    required TResult Function(_PickedMediaAdded value) addPickedMedia,
    required TResult Function(_MediaRemoved value) removeMedia,
  }) {
    return removeMedia(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialEvent value)? initial,
    TResult? Function(_AlbumChanged value)? changeAlbum,
    TResult? Function(_PickedMediaAdded value)? addPickedMedia,
    TResult? Function(_MediaRemoved value)? removeMedia,
  }) {
    return removeMedia?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialEvent value)? initial,
    TResult Function(_AlbumChanged value)? changeAlbum,
    TResult Function(_PickedMediaAdded value)? addPickedMedia,
    TResult Function(_MediaRemoved value)? removeMedia,
    required TResult orElse(),
  }) {
    if (removeMedia != null) {
      return removeMedia(this);
    }
    return orElse();
  }
}

abstract class _MediaRemoved implements MediaPickerEvent {
  const factory _MediaRemoved(final AssetEntity asset) = _$MediaRemovedImpl;

  AssetEntity get asset;

  /// Create a copy of MediaPickerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaRemovedImplCopyWith<_$MediaRemovedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
