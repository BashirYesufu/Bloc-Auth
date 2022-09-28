import 'package:bloc_auth/auth/form_submission_status.dart';
import 'package:bloc_auth/auth/login/login_event.dart';
import 'package:bloc_auth/auth/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc(this.authRepository): super(LoginState()) {
    on<LoginUsernameChanged>((event, emit) async* {
      yield state.copyWith(username: event.username);
    });
  }


  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginUsernameChanged) {
      yield state.copyWith(username: event.username);
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formSubmissionStatus: FormSubmitting());
      try{
        await authRepository.login();
        yield state.copyWith(formSubmissionStatus: FormSubmissionSuccess());
      } catch(e) {
        yield state.copyWith(formSubmissionStatus: FormSubmissionFailed(e as Exception));
      }
    }
  }
}