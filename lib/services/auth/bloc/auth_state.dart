import 'package:deepnotes/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingtext;
  const AuthState(
      {required this.isLoading, this.loadingtext = 'Please wait a moment'});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn({required this.user, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering({required this.exception, required isLoading})
      : super(isLoading: isLoading);
}

class AuthStateForgetPassword extends AuthState{
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgetPassword({required this.exception, required this.hasSentEmail , required bool isLoading}) : super(isLoading: isLoading);

}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;

  const AuthStateLoggedOut(
      {required this.exception, required bool isLoading, String? loadingtext})
      : super(isLoading: isLoading, loadingtext: loadingtext);

  @override
  List<Object?> get props => [exception, isLoading];
}
