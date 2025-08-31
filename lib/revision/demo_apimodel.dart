// NEWS API MODEL

class NewsApiModel {
  final String status;
  final int totalResults;
  final List<Article> articles;

  NewsApiModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsApiModel.fromJson(Map<String, dynamic> json) {
    return NewsApiModel(
      status: json['status'] ?? '',
      totalResults: json['totalResults'] ?? 0,
      articles: (json['articles'] as List<dynamic>)
          .map((e) => Article.fromJson(e))
          .toList(),
    );
  }
}

class Article {
  final Source source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final String publishedAt;
  final String? content;

  Article({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      author: json['author'],
      title: json['title'] ?? '',
      description: json['description'],
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'],
    );
  }
}

class Source {
  final String? id;
  final String name;

  Source({this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}

//My Practice

// class DataApiModel {
//   final int id;
//   final String email;
//   final String first_name;
//   final String last_name;
//   final String avatar;

//   DataApiModel({
//     required this.id,
//     required this.email,
//     required this.first_name,
//     required this.last_name,
//     required this.avatar,
//   });

//   factory DataApiModel.fromJson(Map<String, dynamic> json) {
//     return DataApiModel(
//       id: json['id'],
//       email: json['email'],
//       first_name: json['first_name'],
//       last_name: json['last_name'],
//       avatar: json['avatar'],
//     );
//   }
// }

// class SupportApiModel {
//   final String url;
//   final String text;

//   SupportApiModel({required this.url, required this.text});

//   factory SupportApiModel.fromJson(Map<String, dynamic> json) {
//     return SupportApiModel(url: json['url'], text: json['text']);
//   }
// }

// class DemoApimodel {
//   final int page;
//   final int per_page;
//   final int total;
//   final int total_pages;
//   final DataApiModel dataModel;
//   final SupportApiModel supportModel;

//   DemoApimodel({
//     required this.page,
//     required this.per_page,
//     required this.total,
//     required this.total_pages,
//     required this.dataModel,
//     required this.supportModel,
//   });

//   factory DemoApimodel.fromJson(Map<String, dynamic> json) {
//     return DemoApimodel(
//       page: json['page'],
//       per_page: json['per_page'],
//       total: json['total'],
//       total_pages: json['total_pages'],
//       dataModel: DataApiModel.fromJson(json['data']),
//       supportModel: SupportApiModel.fromJson(json['support']),
//     );
//   }
// }
