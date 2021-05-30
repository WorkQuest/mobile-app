// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'bearer_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BearerToken _$BearerTokenFromJson(Map<String, dynamic> json) {
  return _BearerToken.fromJson(json);
}

/// @nodoc
class _$BearerTokenTearOff {
  const _$BearerTokenTearOff();

  _BearerToken call(
      {required String access,
      required String refresh,
      required int userStatus}) {
    return _BearerToken(
      access: access,
      refresh: refresh,
      userStatus: userStatus,
    );
  }

  BearerToken fromJson(Map<String, Object> json) {
    return BearerToken.fromJson(json);
  }
}

/// @nodoc
const $BearerToken = _$BearerTokenTearOff();

/// @nodoc
mixin _$BearerToken {
  String get access => throw _privateConstructorUsedError;
  String get refresh => throw _privateConstructorUsedError;
  int get userStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BearerTokenCopyWith<BearerToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BearerTokenCopyWith<$Res> {
  factory $BearerTokenCopyWith(
          BearerToken value, $Res Function(BearerToken) then) =
      _$BearerTokenCopyWithImpl<$Res>;
  $Res call({String access, String refresh, int userStatus});
}

/// @nodoc
class _$BearerTokenCopyWithImpl<$Res> implements $BearerTokenCopyWith<$Res> {
  _$BearerTokenCopyWithImpl(this._value, this._then);

  final BearerToken _value;
  // ignore: unused_field
  final $Res Function(BearerToken) _then;

  @override
  $Res call({
    Object? access = freezed,
    Object? refresh = freezed,
    Object? userStatus = freezed,
  }) {
    return _then(_value.copyWith(
      access: access == freezed
          ? _value.access
          : access // ignore: cast_nullable_to_non_nullable
              as String,
      refresh: refresh == freezed
          ? _value.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as String,
      userStatus: userStatus == freezed
          ? _value.userStatus
          : userStatus // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$BearerTokenCopyWith<$Res>
    implements $BearerTokenCopyWith<$Res> {
  factory _$BearerTokenCopyWith(
          _BearerToken value, $Res Function(_BearerToken) then) =
      __$BearerTokenCopyWithImpl<$Res>;
  @override
  $Res call({String access, String refresh, int userStatus});
}

/// @nodoc
class __$BearerTokenCopyWithImpl<$Res> extends _$BearerTokenCopyWithImpl<$Res>
    implements _$BearerTokenCopyWith<$Res> {
  __$BearerTokenCopyWithImpl(
      _BearerToken _value, $Res Function(_BearerToken) _then)
      : super(_value, (v) => _then(v as _BearerToken));

  @override
  _BearerToken get _value => super._value as _BearerToken;

  @override
  $Res call({
    Object? access = freezed,
    Object? refresh = freezed,
    Object? userStatus = freezed,
  }) {
    return _then(_BearerToken(
      access: access == freezed
          ? _value.access
          : access // ignore: cast_nullable_to_non_nullable
              as String,
      refresh: refresh == freezed
          ? _value.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as String,
      userStatus: userStatus == freezed
          ? _value.userStatus
          : userStatus // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_BearerToken implements _BearerToken {
  const _$_BearerToken(
      {required this.access, required this.refresh, required this.userStatus});

  factory _$_BearerToken.fromJson(Map<String, dynamic> json) =>
      _$_$_BearerTokenFromJson(json);

  @override
  final String access;
  @override
  final String refresh;
  @override
  final int userStatus;

  @override
  String toString() {
    return 'BearerToken(access: $access, refresh: $refresh, userStatus: $userStatus)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _BearerToken &&
            (identical(other.access, access) ||
                const DeepCollectionEquality().equals(other.access, access)) &&
            (identical(other.refresh, refresh) ||
                const DeepCollectionEquality()
                    .equals(other.refresh, refresh)) &&
            (identical(other.userStatus, userStatus) ||
                const DeepCollectionEquality()
                    .equals(other.userStatus, userStatus)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(access) ^
      const DeepCollectionEquality().hash(refresh) ^
      const DeepCollectionEquality().hash(userStatus);

  @JsonKey(ignore: true)
  @override
  _$BearerTokenCopyWith<_BearerToken> get copyWith =>
      __$BearerTokenCopyWithImpl<_BearerToken>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_BearerTokenToJson(this);
  }
}

abstract class _BearerToken implements BearerToken {
  const factory _BearerToken(
      {required String access,
      required String refresh,
      required int userStatus}) = _$_BearerToken;

  factory _BearerToken.fromJson(Map<String, dynamic> json) =
      _$_BearerToken.fromJson;

  @override
  String get access => throw _privateConstructorUsedError;
  @override
  String get refresh => throw _privateConstructorUsedError;
  @override
  int get userStatus => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$BearerTokenCopyWith<_BearerToken> get copyWith =>
      throw _privateConstructorUsedError;
}
