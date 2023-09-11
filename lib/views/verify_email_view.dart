
import 'package:deepnotes/services/auth/bloc/auth_bloc.dart';
import 'package:deepnotes/services/auth/bloc/auth_events.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Verify Email'), backgroundColor:  Color.fromARGB(255, 43, 43, 43),),
      body: SingleChildScrollView(
        child: Column( children: [
          
          
             const Text(" We've sent you a Email Verification. Please Verify your Email."),
             
          
          
            TextButton(onPressed: () {
          
              context.read<AuthBloc>().add(const AuthEventSendEmailVerifiaction());
                  
                  
          
            }, child: const Text ('Send Again')),
      
            TextButton(onPressed: () async{
                  context.read<AuthBloc>().add(const AuthEventLogout());
            }, child: const Text('Now Login')),
          
          
          ],),
      ),
    );
  }
}