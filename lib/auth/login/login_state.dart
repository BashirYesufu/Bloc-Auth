import '../form_submission_status.dart';

class LoginState {
  final String username;
  bool get isValidUserName => username.length > 3;

  final String password;
  bool get isValidPassword => password.length > 6;
  final FormSubmissionStatus formSubmissionStatus;

  LoginState({
    this.username = '',
    this.password = '',
    this.formSubmissionStatus = const InitialFormStatus(),
});

  LoginState copyWith({
    String? username,
   String? password,
    FormSubmissionStatus? formSubmissionStatus,
}) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      formSubmissionStatus: formSubmissionStatus ?? this.formSubmissionStatus,
    );
  }
}