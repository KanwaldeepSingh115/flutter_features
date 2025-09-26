class QuotesModel1 {
    QuotesModel1({
        required this.next,
        required this.previous,
        required this.results,
    });

    final String? next;
    final String? previous;
    final List<Result> results;

    factory QuotesModel1.fromJson(Map<String, dynamic> json){ 
        return QuotesModel1(
            next: json["next"],
            previous: json["previous"],
            results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "next": next,
        "previous": previous,
        "results": results.map((x) => x.toJson()).toList(),
    };

}

class Result {
    Result({
        required this.quote,
        required this.author,
        required this.likes,
        required this.tags,
        required this.pk,
        required this.image,
        required this.language,
    });

    final String quote;
    final String author;
    final int likes;
    final List<String> tags;
    final int? pk;
    final String? image;
    final String? language;

    factory Result.fromJson(Map<String, dynamic> json){ 
        return Result(
            quote: json["quote"],
            author: json["author"],
            likes: json["likes"],
            tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
            pk: json["pk"],
            image: json["image"],
            language: json["language"],
        );
    }

    Map<String, dynamic> toJson() => {
        "quote": quote,
        "author": author,
        "likes": likes,
        "tags": tags.map((x) => x).toList(),
        "pk": pk,
        "image": image,
        "language": language,
    };

}




// class QuotesModel1 {
//   QuotesModel1({
//     required this.count,
//     required this.totalCount,
//     required this.page,
//     required this.totalPages,
//     required this.lastItemIndex,
//     required this.results,
//   });

//   final int count;
//   final int totalCount;
//   final int page;
//   final int totalPages;
//   final int lastItemIndex;
//   final List<Result> results;

//   factory QuotesModel1.fromJson(Map<String, dynamic> json) {
//     return QuotesModel1(
//       count: json["count"],
//       totalCount: json["totalCount"],
//       page: json["page"],
//       totalPages: json["totalPages"],
//       lastItemIndex: json["lastItemIndex"],
//       results: json["results"] == null
//           ? []
//           : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "count": count,
//         "totalCount": totalCount,
//         "page": page,
//         "totalPages": totalPages,
//         "lastItemIndex": lastItemIndex,
//         "results": results.map((x) => x.toJson()).toList(),
//       };
// }

// class Result {
//   Result({
//     required this.id,
//     required this.author,
//     required this.content,
//     required this.tags,
//     required this.authorSlug,
//     required this.length,
//     required this.dateAdded,
//     required this.dateModified,
//   });

//   final String id;
//   final String author;
//   final String content;
//   final List<String> tags;
//   final String authorSlug;
//   final int length;
//   final DateTime dateAdded;
//   final DateTime dateModified;

//   factory Result.fromJson(Map<String, dynamic> json) {
//     return Result(
//       id: json["_id"],
//       author: json["author"],
//       content: json["content"],
//       tags: json["tags"] == null ? [] : List<String>.from(json["tags"]),
//       authorSlug: json["authorSlug"],
//       length: json["length"],
//       dateAdded: DateTime.tryParse(json["dateAdded"] ?? "") ?? DateTime.now(),
//       dateModified:
//           DateTime.tryParse(json["dateModified"] ?? "") ?? DateTime.now(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "author": author,
//         "content": content,
//         "tags": tags,
//         "authorSlug": authorSlug,
//         "length": length,
//         "dateAdded":
//             "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
//         "dateModified":
//             "${dateModified.year.toString().padLeft(4, '0')}-${dateModified.month.toString().padLeft(2, '0')}-${dateModified.day.toString().padLeft(2, '0')}",
//       };
// }
