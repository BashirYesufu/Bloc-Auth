import 'package:bloc_auth/auth/auth_repository.dart';
import 'package:bloc_auth/auth/form_submission_status.dart';
import 'package:bloc_auth/auth/login/login_bloc.dart';
import 'package:bloc_auth/auth/login/login_event.dart';
import 'package:bloc_auth/auth/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(context.read<AuthRepository>()),
        child: _loginForm(),
      ),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final status = state.formSubmissionStatus;
        if (status is FormSubmissionFailed) {
          _showSnackBar(context, status.exception.toString());
        } else if (status is FormSubmissionSuccess) {
          _showSnackBar(context, 'Login successful');
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_nameField(), _passwordField(), _loginButton()],
          ),
        ),
      ),
    );
  }

  Widget _nameField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) => TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Username',
        ),
        validator: (value) => state.isValidUserName ? null : 'Username must be 3 characters or more',
        onChanged: (value) => context
            .read<LoginBloc>()
            .add(LoginUsernameChanged(username: value)),
      ),
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.security),
            hintText: 'Password',
          ),
          validator: (value) =>
              state.isValidPassword ? null : 'Password must be 6 characters or more',
          onChanged: (value) => context
              .read<LoginBloc>()
              .add(LoginPasswordChanged(password: value)),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) => state.formSubmissionStatus is FormSubmitting
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  context.read<LoginBloc>().add(LoginSubmitted());
                }
              },
              child: Text('Login'),
            ),
    );
  }

  void _showSnackBar(BuildContext context, String messsage) {
    final snackBar = SnackBar(content: Text(messsage));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
