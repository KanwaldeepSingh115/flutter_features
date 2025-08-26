class DataModel {
  final int id;
  final String email;
  final String first_name;
  final String last_name;
  final String avatar;

  DataModel({
    required this.id,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.avatar,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'],
      email: json['email'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      avatar: json['avatar'],
    );
  }
}

class SupportModel {
  final String url;
  final String text;

  SupportModel({required this.url, required this.text});

  factory SupportModel.fromJson(Map<String, dynamic> json) {
    return SupportModel(url: json['url'], text: json['text']);
  }
}

class GetModel {
  final DataModel mydata;
  final SupportModel support;

  GetModel({required this.mydata, required this.support});

  factory GetModel.fromJson(Map<String, dynamic> json) {
    return GetModel(
      mydata: DataModel.fromJson(json['data']),
      support: SupportModel.fromJson(json['support']),
    );
  }
}
