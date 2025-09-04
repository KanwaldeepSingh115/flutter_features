class DataApiModel1 {
  final int id;
  final String email;
  final String first_name;
  final String last_name;
  final String avatar;

  DataApiModel1({
    required this.id,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.avatar,
  });

  factory DataApiModel1.fromJson(Map<String, dynamic> json) {
    return DataApiModel1(
      id: json['id'],
      email: json['email'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      avatar: json['avatar'],
    );
  }
}

class SupportApiModel1 {
  final String url;
  final String text;

  SupportApiModel1({required this.url, required this.text});

  factory SupportApiModel1.fromJson(Map<String, dynamic> json) {
    return SupportApiModel1(url: json['url'], text: json['text']);
  }
}

class DemoApimodel1 {
  final int page;
  final int per_page;
  final int total;
  final int total_pages;
  final List<DataApiModel1> dataModel;
  final SupportApiModel1 supportModel;

  DemoApimodel1({
    required this.page,
    required this.per_page,
    required this.total,
    required this.total_pages,
    required this.dataModel,
    required this.supportModel,
  });

  factory DemoApimodel1.fromJson(Map<String, dynamic> json) {
    return DemoApimodel1(
      page: json['page'],
      per_page: json['per_page'],
      total: json['total'],
      total_pages: json['total_pages'],
      dataModel:
          (json['data'] as List<dynamic>)
              .map((e) => DataApiModel1.fromJson(e))
              .toList(),
      supportModel: SupportApiModel1.fromJson(json['support']),
    );
  }
}
