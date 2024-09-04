// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SessionState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(MerchantInfo user) merchant,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(MerchantInfo user)? merchant,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(MerchantInfo user)? merchant,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SessionStateInit value) init,
    required TResult Function(SessionStateLoading value) loading,
    required TResult Function(SessionStateError value) error,
    required TResult Function(SessionStateUser value) merchant,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SessionStateInit value)? init,
    TResult? Function(SessionStateLoading value)? loading,
    TResult? Function(SessionStateError value)? error,
    TResult? Function(SessionStateUser value)? merchant,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SessionStateInit value)? init,
    TResult Function(SessionStateLoading value)? loading,
    TResult Function(SessionStateError value)? error,
    TResult Function(SessionStateUser value)? merchant,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionStateCopyWith<$Res> {
  factory $SessionStateCopyWith(
          SessionState value, $Res Function(SessionState) then) =
      _$SessionStateCopyWithImpl<$Res, SessionState>;
}

/// @nodoc
class _$SessionStateCopyWithImpl<$Res, $Val extends SessionState>
    implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SessionStateInitImplCopyWith<$Res> {
  factory _$$SessionStateInitImplCopyWith(_$SessionStateInitImpl value,
          $Res Function(_$SessionStateInitImpl) then) =
      __$$SessionStateInitImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SessionStateInitImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$SessionStateInitImpl>
    implements _$$SessionStateInitImplCopyWith<$Res> {
  __$$SessionStateInitImplCopyWithImpl(_$SessionStateInitImpl _value,
      $Res Function(_$SessionStateInitImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SessionStateInitImpl implements SessionStateInit {
  const _$SessionStateInitImpl();

  @override
  String toString() {
    return 'SessionState.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SessionStateInitImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(MerchantInfo user) merchant,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(MerchantInfo user)? merchant,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(MerchantInfo user)? merchant,
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
    required TResult Function(SessionStateInit value) init,
    required TResult Function(SessionStateLoading value) loading,
    required TResult Function(SessionStateError value) error,
    required TResult Function(SessionStateUser value) merchant,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SessionStateInit value)? init,
    TResult? Function(SessionStateLoading value)? loading,
    TResult? Function(SessionStateError value)? error,
    TResult? Function(SessionStateUser value)? merchant,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SessionStateInit value)? init,
    TResult Function(SessionStateLoading value)? loading,
    TResult Function(SessionStateError value)? error,
    TResult Function(SessionStateUser value)? merchant,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class SessionStateInit implements SessionState {
  const factory SessionStateInit() = _$SessionStateInitImpl;
}

/// @nodoc
abstract class _$$SessionStateLoadingImplCopyWith<$Res> {
  factory _$$SessionStateLoadingImplCopyWith(_$SessionStateLoadingImpl value,
          $Res Function(_$SessionStateLoadingImpl) then) =
      __$$SessionStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SessionStateLoadingImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$SessionStateLoadingImpl>
    implements _$$SessionStateLoadingImplCopyWith<$Res> {
  __$$SessionStateLoadingImplCopyWithImpl(_$SessionStateLoadingImpl _value,
      $Res Function(_$SessionStateLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SessionStateLoadingImpl implements SessionStateLoading {
  const _$SessionStateLoadingImpl();

  @override
  String toString() {
    return 'SessionState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(MerchantInfo user) merchant,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(MerchantInfo user)? merchant,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(MerchantInfo user)? merchant,
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
    required TResult Function(SessionStateInit value) init,
    required TResult Function(SessionStateLoading value) loading,
    required TResult Function(SessionStateError value) error,
    required TResult Function(SessionStateUser value) merchant,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SessionStateInit value)? init,
    TResult? Function(SessionStateLoading value)? loading,
    TResult? Function(SessionStateError value)? error,
    TResult? Function(SessionStateUser value)? merchant,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SessionStateInit value)? init,
    TResult Function(SessionStateLoading value)? loading,
    TResult Function(SessionStateError value)? error,
    TResult Function(SessionStateUser value)? merchant,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SessionStateLoading implements SessionState {
  const factory SessionStateLoading() = _$SessionStateLoadingImpl;
}

/// @nodoc
abstract class _$$SessionStateErrorImplCopyWith<$Res> {
  factory _$$SessionStateErrorImplCopyWith(_$SessionStateErrorImpl value,
          $Res Function(_$SessionStateErrorImpl) then) =
      __$$SessionStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SessionStateErrorImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$SessionStateErrorImpl>
    implements _$$SessionStateErrorImplCopyWith<$Res> {
  __$$SessionStateErrorImplCopyWithImpl(_$SessionStateErrorImpl _value,
      $Res Function(_$SessionStateErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SessionStateErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SessionStateErrorImpl implements SessionStateError {
  const _$SessionStateErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SessionState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionStateErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionStateErrorImplCopyWith<_$SessionStateErrorImpl> get copyWith =>
      __$$SessionStateErrorImplCopyWithImpl<_$SessionStateErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(MerchantInfo user) merchant,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(MerchantInfo user)? merchant,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(MerchantInfo user)? merchant,
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
    required TResult Function(SessionStateInit value) init,
    required TResult Function(SessionStateLoading value) loading,
    required TResult Function(SessionStateError value) error,
    required TResult Function(SessionStateUser value) merchant,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SessionStateInit value)? init,
    TResult? Function(SessionStateLoading value)? loading,
    TResult? Function(SessionStateError value)? error,
    TResult? Function(SessionStateUser value)? merchant,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SessionStateInit value)? init,
    TResult Function(SessionStateLoading value)? loading,
    TResult Function(SessionStateError value)? error,
    TResult Function(SessionStateUser value)? merchant,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SessionStateError implements SessionState {
  const factory SessionStateError(final String message) =
      _$SessionStateErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$SessionStateErrorImplCopyWith<_$SessionStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SessionStateUserImplCopyWith<$Res> {
  factory _$$SessionStateUserImplCopyWith(_$SessionStateUserImpl value,
          $Res Function(_$SessionStateUserImpl) then) =
      __$$SessionStateUserImplCopyWithImpl<$Res>;
  @useResult
  $Res call({MerchantInfo user});
}

/// @nodoc
class __$$SessionStateUserImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$SessionStateUserImpl>
    implements _$$SessionStateUserImplCopyWith<$Res> {
  __$$SessionStateUserImplCopyWithImpl(_$SessionStateUserImpl _value,
      $Res Function(_$SessionStateUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$SessionStateUserImpl(
      null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as MerchantInfo,
    ));
  }
}

/// @nodoc

class _$SessionStateUserImpl implements SessionStateUser {
  const _$SessionStateUserImpl(this.user);

  @override
  final MerchantInfo user;

  @override
  String toString() {
    return 'SessionState.merchant(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionStateUserImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionStateUserImplCopyWith<_$SessionStateUserImpl> get copyWith =>
      __$$SessionStateUserImplCopyWithImpl<_$SessionStateUserImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(MerchantInfo user) merchant,
  }) {
    return merchant(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(MerchantInfo user)? merchant,
  }) {
    return merchant?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(MerchantInfo user)? merchant,
    required TResult orElse(),
  }) {
    if (merchant != null) {
      return merchant(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SessionStateInit value) init,
    required TResult Function(SessionStateLoading value) loading,
    required TResult Function(SessionStateError value) error,
    required TResult Function(SessionStateUser value) merchant,
  }) {
    return merchant(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SessionStateInit value)? init,
    TResult? Function(SessionStateLoading value)? loading,
    TResult? Function(SessionStateError value)? error,
    TResult? Function(SessionStateUser value)? merchant,
  }) {
    return merchant?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SessionStateInit value)? init,
    TResult Function(SessionStateLoading value)? loading,
    TResult Function(SessionStateError value)? error,
    TResult Function(SessionStateUser value)? merchant,
    required TResult orElse(),
  }) {
    if (merchant != null) {
      return merchant(this);
    }
    return orElse();
  }
}

abstract class SessionStateUser implements SessionState {
  const factory SessionStateUser(final MerchantInfo user) =
      _$SessionStateUserImpl;

  MerchantInfo get user;
  @JsonKey(ignore: true)
  _$$SessionStateUserImplCopyWith<_$SessionStateUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
