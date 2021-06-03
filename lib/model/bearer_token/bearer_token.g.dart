// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bearer_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BearerToken _$_$_BearerTokenFromJson(Map<String, dynamic> json) {
  return _$_BearerToken(
    access: json['access'] as String,
    refresh: json['refresh'] as String,
    userStatus: json['userStatus'] as int,
  );
}

Map<String, dynamic> _$_$_BearerTokenToJson(_$_BearerToken instance) =>
    <String, dynamic>{
      'access': instance.access,
      'refresh': instance.refresh,
      'userStatus': instance.userStatus,
    };
