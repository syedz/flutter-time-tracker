import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_bloc_based.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'email_sign_in_bloc.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: _buildEmailSignInFormBlocBased(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildEmailSignInFormBlocBased(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);

    // This is using version 1.4.0 of Provider
    return StatefulProvider<EmailSignInBloc>(
      valueBuilder: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      onDispose: (context, bloc) => bloc.dispose(),
    );
  }
}
