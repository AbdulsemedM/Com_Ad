// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generic_cubit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GenericCubitState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) data,
    required TResult Function(String message) error,
    required TResult Function() loading,
    required TResult Function() init,
    required TResult Function(String message) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? data,
    TResult? Function(String message)? error,
    TResult? Function()? loading,
    TResult? Function()? init,
    TResult? Function(String message)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function(String message)? error,
    TResult Function()? loading,
    TResult Function()? init,
    TResult Function(String message)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenericCubitStateData<T> value) data,
    required TResult Function(GenericCubitStateError<T> value) error,
    required TResult Function(GenericCubitStateLoading<T> value) loading,
    required TResult Function(GenericCubitStateInit<T> value) init,
    required TResult Function(GenericCubitStateSuccess<T> value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenericCubitStateData<T> value)? data,
    TResult? Function(GenericCubitStateError<T> value)? error,
    TResult? Function(GenericCubitStateLoading<T> value)? loading,
    TResult? Function(GenericCubitStateInit<T> value)? init,
    TResult? Function(GenericCubitStateSuccess<T> value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenericCubitStateData<T> value)? data,
    TResult Function(GenericCubitStateError<T> value)? error,
    TResult Function(GenericCubitStateLoading<T> value)? loading,
    TResult Function(GenericCubitStateInit<T> value)? init,
    TResult Function(GenericCubitStateSuccess<T> value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenericCubitStateCopyWith<T, $Res> {
  factory $GenericCubitStateCopyWith(GenericCubitState<T> value,
          $Res Function(GenericCubitState<T>) then) =
      _$GenericCubitStateCopyWithImpl<T, $Res, GenericCubitState<T>>;
}

/// @nodoc
class _$GenericCubitStateCopyWithImpl<T, $Res,
        $Val extends GenericCubitState<T>>
    implements $GenericCubitStateCopyWith<T, $Res> {
  _$GenericCubitStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GenericCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GenericCubitStateDataImplCopyWith<T, $Res> {
  factory _$$GenericCubitStateDataImplCopyWith(
          _$GenericCubitStateDataImpl<T> value,
          $Res Function(_$GenericCubitStateDataImpl<T>) then) =
      __$$GenericCubitStateDataImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$GenericCubitStateDataImplCopyWithImpl<T, $Res>
    extends _$GenericCubitStateCopyWithImpl<T, $Res,
        _$GenericCubitStateDataImpl<T>>
    implements _$$GenericCubitStateDataImplCopyWith<T, $Res> {
  __$$GenericCubitStateDataImplCopyWithImpl(
      _$GenericCubitStateDataImpl<T> _value,
      $Res Function(_$GenericCubitStateDataImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of GenericCubitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$GenericCubitStateDataImpl<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$GenericCubitStateDataImpl<T> implements GenericCubitStateData<T> {
  const _$GenericCubitStateDataImpl(this.data);

  @override
  final T data;

  @override
  String toString() {
    return 'GenericCubitState<$T>.data(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenericCubitStateDataImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of GenericCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenericCubitStateDataImplCopyWith<T, _$GenericCubitStateDataImpl<T>>
      get copyWith => __$$GenericCubitStateDataImplCopyWithImpl<T,
          _$GenericCubitStateDataImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) data,
    required TResult Function(String message) error,
    required TResult Function() loading,
    required TResult Function() init,
    required TResult Function(String message) success,
  }) {
    return data(this.data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? data,
    TResult? Function(String message)? error,
    TResult? Function()? loading,
    TResult? Function()? init,
    TResult? Function(String message)? success,
  }) {
    return data?.call(this.data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function(String message)? error,
    TResult Function()? loading,
    TResult Function()? init,
    TResult Function(String message)? success,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this.data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenericCubitStateData<T> value) data,
    required TResult Function(GenericCubitStateError<T> value) error,
    required TResult Function(GenericCubitStateLoading<T> value) loading,
    required TResult Function(GenericCubitStateInit<T> value) init,
    required TResult Function(GenericCubitStateSuccess<T> value) success,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenericCubitStateData<T> value)? data,
    TResult? Function(GenericCubitStateError<T> value)? error,
    TResult? Function(GenericCubitStateLoading<T> value)? loading,
    TResult? Function(GenericCubitStateInit<T> value)? init,
    TResult? Function(GenericCubitStateSuccess<T> value)? success,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenericCubitStateData<T> value)? data,
    TResult Function(GenericCubitStateError<T> value)? error,
    TResult Function(GenericCubitStateLoading<T> value)? loading,
    TResult Function(GenericCubitStateInit<T> value)? init,
    TResult Function(GenericCubitStateSuccess<T> value)? success,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class GenericCubitStateData<T> implements GenericCubitState<T> {
  const factory GenericCubitStateData(final T data) =
      _$GenericCubitStateDataImpl<T>;

  T get data;

  /// Create a copy of GenericCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenericCubitStateDataImplCopyWith<T, _$GenericCubitStateDataImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GenericCubitStateErrorImplCopyWith<T, $Res> {
  factory _$$GenericCubitStateErrorImplCopyWith(
          _$GenericCubitStateErrorImpl<T> value,
          $Res Function(_$GenericCubitStateErrorImpl<T>) then) =
      __$$GenericCubitStateErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$GenericCubitStateErrorImplCopyWithImpl<T, $Res>
    extends _$GenericCubitStateCopyWithImpl<T, $Res,
        _$GenericCubitStateErrorImpl<T>>
    implements _$$GenericCubitStateErrorImplCopyWith<T, $Res> {
  __$$GenericCubitStateErrorImplCopyWithImpl(
      _$GenericCubitStateErrorImpl<T> _value,
      $Res Function(_$GenericCubitStateErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of GenericCubitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$GenericCubitStateErrorImpl<T>(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GenericCubitStateErrorImpl<T> implements GenericCubitStateError<T> {
  const _$GenericCubitStateErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'GenericCubitState<$T>.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenericCubitStateErrorImpl<T> &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of GenericCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenericCubitStateErrorImplCopyWith<T, _$GenericCubitStateErrorImpl<T>>
      get copyWith => __$$GenericCubitStateErrorImplCopyWithImpl<T,
          _$GenericCubitStateErrorImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) data,
    required TResult Function(String message) error,
    required TResult Function() loading,
    required TResult Function() init,
    required TResult Function(String message) success,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? data,
    TResult? Function(String message)? error,
    TResult? Function()? loading,
    TResult? Function()? init,
    TResult? Function(String message)? success,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function(String message)? error,
    TResult Function()? loading,
    TResult Function()? init,
    TResult Function(String message)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenericCubitStateData<T> value) data,
    required TResult Function(GenericCubitStateError<T> value) error,
    required TResult Function(GenericCubitStateLoading<T> value) loading,
    required TResult Function(GenericCubitStateInit<T> value) init,
    required TResult Function(GenericCubitStateSuccess<T> value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenericCubitStateData<T> value)? data,
    TResult? Function(GenericCubitStateError<T> value)? error,
    TResult? Function(GenericCubitStateLoading<T> value)? loading,
    TResult? Function(GenericCubitStateInit<T> value)? init,
    TResult? Function(GenericCubitStateSuccess<T> value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenericCubitStateData<T> value)? data,
    TResult Function(GenericCubitStateError<T> value)? error,
    TResult Function(GenericCubitStateLoading<T> value)? loading,
    TResult Function(GenericCubitStateInit<T> value)? init,
    TResult Function(GenericCubitStateSuccess<T> value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class GenericCubitStateError<T> implements GenericCubitState<T> {
  const factory GenericCubitStateError(final String message) =
      _$GenericCubitStateErrorImpl<T>;

  String get message;

  /// Create a copy of GenericCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenericCubitStateErrorImplCopyWith<T, _$GenericCubitStateErrorImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GenericCubitStateLoadingImplCopyWith<T, $Res> {
  factory _$$GenericCubitStateLoadingImplCopyWith(
          _$GenericCubitStateLoadingImpl<T> value,
          $Res Function(_$GenericCubitStateLoadingImpl<T>) then) =
      __$$GenericCubitStateLoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$GenericCubitStateLoadingImplCopyWithImpl<T, $Res>
    extends _$GenericCubitStateCopyWithImpl<T, $Res,
        _$GenericCubitStateLoadingImpl<T>>
    implements _$$GenericCubitStateLoadingImplCopyWith<T, $Res> {
  __$$GenericCubitStateLoadingImplCopyWithImpl(
      _$GenericCubitStateLoadingImpl<T> _value,
      $Res Function(_$GenericCubitStateLoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of GenericCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GenericCubitStateLoadingImpl<T> implements GenericCubitStateLoading<T> {
  const _$GenericCubitStateLoadingImpl();

  @override
  String toString() {
    return 'GenericCubitState<$T>.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenericCubitStateLoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) data,
    required TResult Function(String message) error,
    required TResult Function() loading,
    required TResult Function() init,
    required TResult Function(String message) success,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? data,
    TResult? Function(String message)? error,
    TResult? Function()? loading,
    TResult? Function()? init,
    TResult? Function(String message)? success,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function(String message)? error,
    TResult Function()? loading,
    TResult Function()? init,
    TResult Function(String message)? success,
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
    required TResult Function(GenericCubitStateData<T> value) data,
    required TResult Function(GenericCubitStateError<T> value) error,
    required TResult Function(GenericCubitStateLoading<T> value) loading,
    required TResult Function(GenericCubitStateInit<T> value) init,
    required TResult Function(GenericCubitStateSuccess<T> value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenericCubitStateData<T> value)? data,
    TResult? Function(GenericCubitStateError<T> value)? error,
    TResult? Function(GenericCubitStateLoading<T> value)? loading,
    TResult? Function(GenericCubitStateInit<T> value)? init,
    TResult? Function(GenericCubitStateSuccess<T> value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenericCubitStateData<T> value)? data,
    TResult Function(GenericCubitStateError<T> value)? error,
    TResult Function(GenericCubitStateLoading<T> value)? loading,
    TResult Function(GenericCubitStateInit<T> value)? init,
    TResult Function(GenericCubitStateSuccess<T> value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class GenericCubitStateLoading<T> implements GenericCubitState<T> {
  const factory GenericCubitStateLoading() = _$GenericCubitStateLoadingImpl<T>;
}

/// @nodoc
abstract class _$$GenericCubitStateInitImplCopyWith<T, $Res> {
  factory _$$GenericCubitStateInitImplCopyWith(
          _$GenericCubitStateInitImpl<T> value,
          $Res Function(_$GenericCubitStateInitImpl<T>) then) =
      __$$GenericCubitStateInitImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$GenericCubitStateInitImplCopyWithImpl<T, $Res>
    extends _$GenericCubitStateCopyWithImpl<T, $Res,
        _$GenericCubitStateInitImpl<T>>
    implements _$$GenericCubitStateInitImplCopyWith<T, $Res> {
  __$$GenericCubitStateInitImplCopyWithImpl(
      _$GenericCubitStateInitImpl<T> _value,
      $Res Function(_$GenericCubitStateInitImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of GenericCubitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GenericCubitStateInitImpl<T> implements GenericCubitStateInit<T> {
  const _$GenericCubitStateInitImpl();

  @override
  String toString() {
    return 'GenericCubitState<$T>.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenericCubitStateInitImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) data,
    required TResult Function(String message) error,
    required TResult Function() loading,
    required TResult Function() init,
    required TResult Function(String message) success,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? data,
    TResult? Function(String message)? error,
    TResult? Function()? loading,
    TResult? Function()? init,
    TResult? Function(String message)? success,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function(String message)? error,
    TResult Function()? loading,
    TResult Function()? init,
    TResult Function(String message)? success,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenericCubitStateData<T> value) data,
    required TResult Function(GenericCubitStateError<T> value) error,
    required TResult Function(GenericCubitStateLoading<T> value) loading,
    required TResult Function(GenericCubitStateInit<T> value) init,
    required TResult Function(GenericCubitStateSuccess<T> value) success,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenericCubitStateData<T> value)? data,
    TResult? Function(GenericCubitStateError<T> value)? error,
    TResult? Function(GenericCubitStateLoading<T> value)? loading,
    TResult? Function(GenericCubitStateInit<T> value)? init,
    TResult? Function(GenericCubitStateSuccess<T> value)? success,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenericCubitStateData<T> value)? data,
    TResult Function(GenericCubitStateError<T> value)? error,
    TResult Function(GenericCubitStateLoading<T> value)? loading,
    TResult Function(GenericCubitStateInit<T> value)? init,
    TResult Function(GenericCubitStateSuccess<T> value)? success,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class GenericCubitStateInit<T> implements GenericCubitState<T> {
  const factory GenericCubitStateInit() = _$GenericCubitStateInitImpl<T>;
}

/// @nodoc
abstract class _$$GenericCubitStateSuccessImplCopyWith<T, $Res> {
  factory _$$GenericCubitStateSuccessImplCopyWith(
          _$GenericCubitStateSuccessImpl<T> value,
          $Res Function(_$GenericCubitStateSuccessImpl<T>) then) =
      __$$GenericCubitStateSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$GenericCubitStateSuccessImplCopyWithImpl<T, $Res>
    extends _$GenericCubitStateCopyWithImpl<T, $Res,
        _$GenericCubitStateSuccessImpl<T>>
    implements _$$GenericCubitStateSuccessImplCopyWith<T, $Res> {
  __$$GenericCubitStateSuccessImplCopyWithImpl(
      _$GenericCubitStateSuccessImpl<T> _value,
      $Res Function(_$GenericCubitStateSuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of GenericCubitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$GenericCubitStateSuccessImpl<T>(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GenericCubitStateSuccessImpl<T> implements GenericCubitStateSuccess<T> {
  const _$GenericCubitStateSuccessImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'GenericCubitState<$T>.success(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenericCubitStateSuccessImpl<T> &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of GenericCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenericCubitStateSuccessImplCopyWith<T, _$GenericCubitStateSuccessImpl<T>>
      get copyWith => __$$GenericCubitStateSuccessImplCopyWithImpl<T,
          _$GenericCubitStateSuccessImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) data,
    required TResult Function(String message) error,
    required TResult Function() loading,
    required TResult Function() init,
    required TResult Function(String message) success,
  }) {
    return success(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? data,
    TResult? Function(String message)? error,
    TResult? Function()? loading,
    TResult? Function()? init,
    TResult? Function(String message)? success,
  }) {
    return success?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function(String message)? error,
    TResult Function()? loading,
    TResult Function()? init,
    TResult Function(String message)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenericCubitStateData<T> value) data,
    required TResult Function(GenericCubitStateError<T> value) error,
    required TResult Function(GenericCubitStateLoading<T> value) loading,
    required TResult Function(GenericCubitStateInit<T> value) init,
    required TResult Function(GenericCubitStateSuccess<T> value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenericCubitStateData<T> value)? data,
    TResult? Function(GenericCubitStateError<T> value)? error,
    TResult? Function(GenericCubitStateLoading<T> value)? loading,
    TResult? Function(GenericCubitStateInit<T> value)? init,
    TResult? Function(GenericCubitStateSuccess<T> value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenericCubitStateData<T> value)? data,
    TResult Function(GenericCubitStateError<T> value)? error,
    TResult Function(GenericCubitStateLoading<T> value)? loading,
    TResult Function(GenericCubitStateInit<T> value)? init,
    TResult Function(GenericCubitStateSuccess<T> value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class GenericCubitStateSuccess<T> implements GenericCubitState<T> {
  const factory GenericCubitStateSuccess(final String message) =
      _$GenericCubitStateSuccessImpl<T>;

  String get message;

  /// Create a copy of GenericCubitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenericCubitStateSuccessImplCopyWith<T, _$GenericCubitStateSuccessImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}
