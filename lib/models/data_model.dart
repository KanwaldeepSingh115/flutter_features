class DataModel {
  Map<String, dynamic> setUserInfo(
    String id,
    String name,
    String email,
    int age,
  ) {
    Map<String, dynamic> userInfo = {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
    };
    return userInfo;
  }
}
