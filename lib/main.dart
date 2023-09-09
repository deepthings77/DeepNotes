import 'package:deepnotes/constants/routes.dart';
import 'package:deepnotes/helpers/loading/loading_screen.dart';

import 'package:deepnotes/services/auth/bloc/auth_bloc.dart';
import 'package:deepnotes/services/auth/bloc/auth_events.dart';
import 'package:deepnotes/services/auth/bloc/auth_state.dart';
import 'package:deepnotes/services/auth/firebase_auth_provider.dart';
import 'package:deepnotes/views/forget_password_view.dart';
import 'package:deepnotes/views/login_view.dart';
import 'package:deepnotes/views/notes/create_update_note_view.dart';
import 'package:deepnotes/views/notes/notes_view.dart';
import 'package:deepnotes/views/register_view.dart';
import 'package:deepnotes/views/verify_email_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingtext ?? 'Please wait for a moment');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgetPassword) {
          return const ForgetPasswordView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
