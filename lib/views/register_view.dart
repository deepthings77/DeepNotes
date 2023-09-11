
import 'package:deepnotes/services/auth/auth_exceptions.dart';

import 'package:deepnotes/services/auth/bloc/auth_events.dart';
import 'package:deepnotes/services/auth/bloc/auth_state.dart';
import 'package:deepnotes/utilities/dialog/error_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth/bloc/auth_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async{
        if(state is AuthStateRegistering){
          if(state.exception is WeakPasswordAuthException){
            await   showErrorDialog(context, 'Wrong Password');
          } else if(state.exception is EmailAlreadyInUseAuthException){
             await   showErrorDialog(context, 'Email already in Use');
          } else if(state.exception is GenericAuthException){
             await   showErrorDialog(context, 'Failed to Register');
          } else if(state.exception is InvalidEamilAuthException){
             await   showErrorDialog(context, 'Invalid Email');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
            backgroundColor:  Color.fromARGB(255, 43, 43, 43),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Enter Your Email '),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  autofocus: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration:
                      const InputDecoration(hintText: 'Enter Your Password '),
                ),
                TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                  
                      context.read<AuthBloc>().add(AuthEventRegister(email,   password));
                       
                    },
                    child: const Text('Register')),
                TextButton(
                    onPressed: () {
                     context.read<AuthBloc>().add(const AuthEventLogout());
                    },
                    child: const Text('Already Registered? Login Here!'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
