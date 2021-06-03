// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_QuestModel _$_$_QuestModelFromJson(Map<String, dynamic> json) {
  return _$_QuestModel(
    category: json['category'] as String,
    priority: json['priority'] as int,
    location: Location.fromJson(json['location'] as Map<String, dynamic>),
    title: json['title'] as String,
    description: json['description'] as String,
    price: json['price'] as String,
    adType: json['adType'] as int,
  );
}

Map<String, dynamic> _$_$_QuestModelToJson(_$_QuestModel instance) =>
    <String, dynamic>{
      'category': instance.category,
      'priority': instance.priority,
      'location': instance.location,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'adType': instance.adType,
    };
