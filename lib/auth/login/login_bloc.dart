import 'package:bloc_auth/auth/form_submission_status.dart';
import 'package:bloc_auth/auth/login/login_event.dart';
import 'package:bloc_auth/auth/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc(this.authRepository): super(LoginState()){
    on<LoginUsernameChanged>((event, emit) => emit(state.copyWith(username: event.username)));

    on<LoginPasswordChanged>((event, emit) => emit(state.copyWith(password: event.password)));

    on<LoginSubmitted>((event, emit) async  {
      emit(state.copyWith(formSubmissionStatus: FormSubmitting()));
      emit(state.copyWith(formSubmissionStatus: await submit()));
    });
  }

  Future<FormSubmissionStatus> submit() async {
    try{
      await authRepository.login();
      return FormSubmissionSuccess();
    } catch(e) {
      return FormSubmissionFailed(e as Exception);
    }
  }
}