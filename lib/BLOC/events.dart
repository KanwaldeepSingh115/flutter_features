abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String email;
  final String password;
  LoggedIn(this.email, this.password);
}

class LoggedOut extends AuthEvent{}
