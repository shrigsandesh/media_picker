// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_picker_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MediaPickerState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<MediaAlbum> get albums => throw _privateConstructorUsedError;
  MediaContent get media => throw _privateConstructorUsedError;
  List<AssetEntity> get pickedFiles => throw _privateConstructorUsedError;

  /// Create a copy of MediaPickerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaPickerStateCopyWith<MediaPickerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaPickerStateCopyWith<$Res> {
  factory $MediaPickerStateCopyWith(
          MediaPickerState value, $Res Function(MediaPickerState) then) =
      _$MediaPickerStateCopyWithImpl<$Res, MediaPickerState>;
  @useResult
  $Res call(
      {bool isLoading,
      List<MediaAlbum> albums,
      MediaContent media,
      List<AssetEntity> pickedFiles});
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
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? albums = null,
    Object? media = null,
    Object? pickedFiles = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      albums: null == albums
          ? _value.albums
          : albums // ignore: cast_nullable_to_non_nullable
              as List<MediaAlbum>,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as MediaContent,
      pickedFiles: null == pickedFiles
          ? _value.pickedFiles
          : pickedFiles // ignore: cast_nullable_to_non_nullable
              as List<AssetEntity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaPickerStateImplCopyWith<$Res>
    implements $MediaPickerStateCopyWith<$Res> {
  factory _$$MediaPickerStateImplCopyWith(_$MediaPickerStateImpl value,
          $Res Function(_$MediaPickerStateImpl) then) =
      __$$MediaPickerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<MediaAlbum> albums,
      MediaContent media,
      List<AssetEntity> pickedFiles});
}

/// @nodoc
class __$$MediaPickerStateImplCopyWithImpl<$Res>
    extends _$MediaPickerStateCopyWithImpl<$Res, _$MediaPickerStateImpl>
    implements _$$MediaPickerStateImplCopyWith<$Res> {
  __$$MediaPickerStateImplCopyWithImpl(_$MediaPickerStateImpl _value,
      $Res Function(_$MediaPickerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaPickerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? albums = null,
    Object? media = null,
    Object? pickedFiles = null,
  }) {
    return _then(_$MediaPickerStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      albums: null == albums
          ? _value._albums
          : albums // ignore: cast_nullable_to_non_nullable
              as List<MediaAlbum>,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as MediaContent,
      pickedFiles: null == pickedFiles
          ? _value._pickedFiles
          : pickedFiles // ignore: cast_nullable_to_non_nullable
              as List<AssetEntity>,
    ));
  }
}

/// @nodoc

class _$MediaPickerStateImpl implements _MediaPickerState {
  const _$MediaPickerStateImpl(
      {this.isLoading = false,
      final List<MediaAlbum> albums = const [],
      this.media = MediaContent.initial,
      final List<AssetEntity> pickedFiles = const []})
      : _albums = albums,
        _pickedFiles = pickedFiles;

  @override
  @JsonKey()
  final bool isLoading;
  final List<MediaAlbum> _albums;
  @override
  @JsonKey()
  List<MediaAlbum> get albums {
    if (_albums is EqualUnmodifiableListView) return _albums;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_albums);
  }

  @override
  @JsonKey()
  final MediaContent media;
  final List<AssetEntity> _pickedFiles;
  @override
  @JsonKey()
  List<AssetEntity> get pickedFiles {
    if (_pickedFiles is EqualUnmodifiableListView) return _pickedFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pickedFiles);
  }

  @override
  String toString() {
    return 'MediaPickerState(isLoading: $isLoading, albums: $albums, media: $media, pickedFiles: $pickedFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaPickerStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._albums, _albums) &&
            (identical(other.media, media) || other.media == media) &&
            const DeepCollectionEquality()
                .equals(other._pickedFiles, _pickedFiles));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(_albums),
      media,
      const DeepCollectionEquality().hash(_pickedFiles));

  /// Create a copy of MediaPickerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaPickerStateImplCopyWith<_$MediaPickerStateImpl> get copyWith =>
      __$$MediaPickerStateImplCopyWithImpl<_$MediaPickerStateImpl>(
          this, _$identity);
}

abstract class _MediaPickerState implements MediaPickerState {
  const factory _MediaPickerState(
      {final bool isLoading,
      final List<MediaAlbum> albums,
      final MediaContent media,
      final List<AssetEntity> pickedFiles}) = _$MediaPickerStateImpl;

  @override
  bool get isLoading;
  @override
  List<MediaAlbum> get albums;
  @override
  MediaContent get media;
  @override
  List<AssetEntity> get pickedFiles;

  /// Create a copy of MediaPickerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaPickerStateImplCopyWith<_$MediaPickerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
