

import 'package:deepnotes/services/auth/bloc/auth_bloc.dart';
import 'package:deepnotes/services/auth/bloc/auth_events.dart';
import 'package:deepnotes/services/auth/bloc/auth_state.dart';
import 'package:deepnotes/utilities/dialog/error_dialog.dart';
import 'package:deepnotes/utilities/dialog/password_reset_email_sent_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
   _controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState> (listener:(context, state) async{
      if(state is AuthStateForgetPassword){
        if(state.hasSentEmail){
          _controller.clear();
          await showPasswordResetSentDialog(context);
        }
        if(state.exception != null){
          await showErrorDialog(context, 'We could not process Your Request. Please make sure you are a registered user ');
        }
      }
    },
    child:  Scaffold(
      appBar:  AppBar(
        title:  const Text('Forget Password'),
         backgroundColor: Color.fromARGB(255, 43, 43, 43),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('If you forget your password than enter your email and we will send you a password reset Link'),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofocus: true,
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Your email address'
                  ),
              ),
              TextButton(onPressed: (){
                final email = _controller.text;
                context.read<AuthBloc>().add(AuthEventForgetPassword(email: email));
              }, child: const Text('Send me a password reset link.')),
              TextButton(onPressed: (){
                context.read<AuthBloc>().add(const AuthEventLogout(),);
        
              }, child: const Text('Back to login page.')),
            ],
        
          ),
        ),
      ),

    ),
    );
  }
}