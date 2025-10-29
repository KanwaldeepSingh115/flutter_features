// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemoApiModel _$DemoApiModelFromJson(Map<String, dynamic> json) => DemoApiModel(
  page: (json['page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
  data:
      (json['data'] as List<dynamic>)
          .map((e) => DataApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  support: SupportApiModel.fromJson(json['support'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DemoApiModelToJson(DemoApiModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'per_page': instance.perPage,
      'total': instance.total,
      'total_pages': instance.totalPages,
      'data': instance.data,
      'support': instance.support,
    };

DataApiModel _$DataApiModelFromJson(Map<String, dynamic> json) => DataApiModel(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  avatar: json['avatar'] as String,
);

Map<String, dynamic> _$DataApiModelToJson(DataApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar': instance.avatar,
    };

SupportApiModel _$SupportApiModelFromJson(Map<String, dynamic> json) =>
    SupportApiModel(url: json['url'] as String, text: json['text'] as String);

Map<String, dynamic> _$SupportApiModelToJson(SupportApiModel instance) =>
    <String, dynamic>{'url': instance.url, 'text': instance.text};
