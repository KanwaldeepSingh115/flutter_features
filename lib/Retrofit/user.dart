import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class DemoApiModel {
  final int page;
  @JsonKey(name: 'per_page')
  final int perPage;
  final int total;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  final List<DataApiModel> data;
  final SupportApiModel support;

  DemoApiModel({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.data,
    required this.support,
  });

  factory DemoApiModel.fromJson(Map<String, dynamic> json) =>
      _$DemoApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$DemoApiModelToJson(this);
}

@JsonSerializable()
class DataApiModel {
  final int id;
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String avatar;

  DataApiModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory DataApiModel.fromJson(Map<String, dynamic> json) =>
      _$DataApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$DataApiModelToJson(this);
}

@JsonSerializable()
class SupportApiModel {
  final String url;
  final String text;

  SupportApiModel({
    required this.url,
    required this.text,
  });

  factory SupportApiModel.fromJson(Map<String, dynamic> json) =>
      _$SupportApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$SupportApiModelToJson(this);
}
