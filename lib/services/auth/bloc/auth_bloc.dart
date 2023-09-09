import 'package:bloc/bloc.dart';
import 'package:deepnotes/services/auth/auth_provider.dart';
import 'package:deepnotes/services/auth/bloc/auth_events.dart';
import 'package:deepnotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventSendEmailVerifiaction>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(exception: null, isLoading: false));
    });

    on<AuthEventForgetPassword>((event, emit) async {
      emit(const AuthStateForgetPassword(
          exception: null, hasSentEmail: false, isLoading: false));
      final email = event.email;
      if (email == null) {
        return; // user just want to go to forget state
      }

      //user acatually want to send a forget password email
      emit(const AuthStateForgetPassword(
          exception: null, hasSentEmail: false, isLoading: false));

      bool didSentEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: email);
        didSentEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSentEmail = false;
        exception = e;
      }
      emit(AuthStateForgetPassword(
          exception: exception, hasSentEmail: didSentEmail, isLoading: false));
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });

    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      ///////////////////////////////////error false
      emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
          loadingtext: 'Please wait until we log you in'));

      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(email: email, password: password);

        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventLogout>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
  }
}
