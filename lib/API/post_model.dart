class Post {
  final String email;
  final String password;

  Post({required this.email, required this.password});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(email: json['email'], password: json['password']);
  }
}

