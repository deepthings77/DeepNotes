
import 'package:flutter/foundation.dart' show immutable;

@immutable 
abstract class  AuthEvent {
  const AuthEvent();
  
}

class AuthEventInitialize extends AuthEvent{
  const AuthEventInitialize();
}

class AuthEventSendEmailVerifiaction extends AuthEvent {
  const AuthEventSendEmailVerifiaction();
}

class AuthEventLogIn extends AuthEvent{
  final String email;
  final String password;

 const AuthEventLogIn(this.email, this.password);
}

class AuthEventRegister extends AuthEvent{
    final String email;
  final String password;

const  AuthEventRegister(this.email, this.password);
  
}

class AuthEventForgetPassword extends AuthEvent{
  final   String? email;

 const AuthEventForgetPassword({this.email});
}

class AuthEventShouldRegister extends AuthEvent{
  const AuthEventShouldRegister();
}

class AuthEventLogout extends AuthEvent{
  const AuthEventLogout();
}