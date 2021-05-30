// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'quest_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

QuestModel _$QuestModelFromJson(Map<String, dynamic> json) {
  return _QuestModel.fromJson(json);
}

/// @nodoc
class _$QuestModelTearOff {
  const _$QuestModelTearOff();

  _QuestModel call(
      {required String category,
      required int priority,
      required Location location,
      required String title,
      required String description,
      required String price,
      required int adType}) {
    return _QuestModel(
      category: category,
      priority: priority,
      location: location,
      title: title,
      description: description,
      price: price,
      adType: adType,
    );
  }

  QuestModel fromJson(Map<String, Object> json) {
    return QuestModel.fromJson(json);
  }
}

/// @nodoc
const $QuestModel = _$QuestModelTearOff();

/// @nodoc
mixin _$QuestModel {
  String get category => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  Location get location => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get price => throw _privateConstructorUsedError;
  int get adType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestModelCopyWith<QuestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestModelCopyWith<$Res> {
  factory $QuestModelCopyWith(
          QuestModel value, $Res Function(QuestModel) then) =
      _$QuestModelCopyWithImpl<$Res>;
  $Res call(
      {String category,
      int priority,
      Location location,
      String title,
      String description,
      String price,
      int adType});
}

/// @nodoc
class _$QuestModelCopyWithImpl<$Res> implements $QuestModelCopyWith<$Res> {
  _$QuestModelCopyWithImpl(this._value, this._then);

  final QuestModel _value;
  // ignore: unused_field
  final $Res Function(QuestModel) _then;

  @override
  $Res call({
    Object? category = freezed,
    Object? priority = freezed,
    Object? location = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? adType = freezed,
  }) {
    return _then(_value.copyWith(
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      priority: priority == freezed
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Location,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      adType: adType == freezed
          ? _value.adType
          : adType // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$QuestModelCopyWith<$Res> implements $QuestModelCopyWith<$Res> {
  factory _$QuestModelCopyWith(
          _QuestModel value, $Res Function(_QuestModel) then) =
      __$QuestModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String category,
      int priority,
      Location location,
      String title,
      String description,
      String price,
      int adType});
}

/// @nodoc
class __$QuestModelCopyWithImpl<$Res> extends _$QuestModelCopyWithImpl<$Res>
    implements _$QuestModelCopyWith<$Res> {
  __$QuestModelCopyWithImpl(
      _QuestModel _value, $Res Function(_QuestModel) _then)
      : super(_value, (v) => _then(v as _QuestModel));

  @override
  _QuestModel get _value => super._value as _QuestModel;

  @override
  $Res call({
    Object? category = freezed,
    Object? priority = freezed,
    Object? location = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? adType = freezed,
  }) {
    return _then(_QuestModel(
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      priority: priority == freezed
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Location,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      adType: adType == freezed
          ? _value.adType
          : adType // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_QuestModel implements _QuestModel {
  const _$_QuestModel(
      {required this.category,
      required this.priority,
      required this.location,
      required this.title,
      required this.description,
      required this.price,
      required this.adType});

  factory _$_QuestModel.fromJson(Map<String, dynamic> json) =>
      _$_$_QuestModelFromJson(json);

  @override
  final String category;
  @override
  final int priority;
  @override
  final Location location;
  @override
  final String title;
  @override
  final String description;
  @override
  final String price;
  @override
  final int adType;

  @override
  String toString() {
    return 'QuestModel(category: $category, priority: $priority, location: $location, title: $title, description: $description, price: $price, adType: $adType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _QuestModel &&
            (identical(other.category, category) ||
                const DeepCollectionEquality()
                    .equals(other.category, category)) &&
            (identical(other.priority, priority) ||
                const DeepCollectionEquality()
                    .equals(other.priority, priority)) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality()
                    .equals(other.location, location)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.adType, adType) ||
                const DeepCollectionEquality().equals(other.adType, adType)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(category) ^
      const DeepCollectionEquality().hash(priority) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(adType);

  @JsonKey(ignore: true)
  @override
  _$QuestModelCopyWith<_QuestModel> get copyWith =>
      __$QuestModelCopyWithImpl<_QuestModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_QuestModelToJson(this);
  }
}

abstract class _QuestModel implements QuestModel {
  const factory _QuestModel(
      {required String category,
      required int priority,
      required Location location,
      required String title,
      required String description,
      required String price,
      required int adType}) = _$_QuestModel;

  factory _QuestModel.fromJson(Map<String, dynamic> json) =
      _$_QuestModel.fromJson;

  @override
  String get category => throw _privateConstructorUsedError;
  @override
  int get priority => throw _privateConstructorUsedError;
  @override
  Location get location => throw _privateConstructorUsedError;
  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get description => throw _privateConstructorUsedError;
  @override
  String get price => throw _privateConstructorUsedError;
  @override
  int get adType => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$QuestModelCopyWith<_QuestModel> get copyWith =>
      throw _privateConstructorUsedError;
}
