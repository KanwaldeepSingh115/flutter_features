import 'package:intl/intl.dart';

class FirestoreTestModel {
  Map<String, dynamic> setUserData(
    String id,
    String title,
    String description,
  ) {
    final formattedDateTime = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now());

    Map<String, dynamic> userData = {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': formattedDateTime,
    };
    return userData;
  }
}
