import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/BLOC/events.dart';
import 'package:flutter_practice/BLOC/states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final user = _auth.currentUser;
      if (user != null) {
        emit(Authenticated(user.uid));
      } else {
        emit(UnAuthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthLoading());

      try {
        final userCred = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(Authenticated(userCred.user!.uid));
      } catch (e) {
        emit(UnAuthenticated(message: e.toString()));
      }
    });

    on<LoggedOut>((event, emit) async {
      await _auth.signOut();
      emit(UnAuthenticated());
    });
  }
}
