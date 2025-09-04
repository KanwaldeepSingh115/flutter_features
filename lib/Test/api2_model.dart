class DataApiModel2 {
  final int id;
  final String email;
  final String first_name;
  final String last_name;
  final String avatar;

  DataApiModel2({
    required this.id,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.avatar,
  });

  factory DataApiModel2.fromJson(Map<String, dynamic> json) {
    return DataApiModel2(
      id: json['id'],
      email: json['email'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      avatar: json['avatar'],
    );
  }
}

class SupportApiModel2 {
  final String url;
  final String text;

  SupportApiModel2({required this.url, required this.text});

  factory SupportApiModel2.fromJson(Map<String, dynamic> json) {
    return SupportApiModel2(url: json['url'], text: json['text']);
  }
}

class DemoApimodel2 {
  final DataApiModel2 dataModel;
  final SupportApiModel2 supportModel;

  DemoApimodel2({required this.dataModel, required this.supportModel});

  factory DemoApimodel2.fromJson(Map<String, dynamic> json) {
    return DemoApimodel2(
      dataModel: DataApiModel2.fromJson(json['data']),

      supportModel: SupportApiModel2.fromJson(json['support']),
    );
  }
}
