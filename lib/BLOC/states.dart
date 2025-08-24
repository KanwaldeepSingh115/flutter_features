abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String uid;
  Authenticated(this.uid);
}

class UnAuthenticated extends AuthState {
  final String? message;
  UnAuthenticated({this.message});
}
