import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainees_flutter/blocs/auth/auth_repository.dart';
import 'package:trainees_flutter/blocs/form_submission_status.dart';
import 'package:trainees_flutter/blocs/auth/login_event.dart';
import 'package:trainees_flutter/blocs/auth/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository? authRepo;

  LoginBloc({this.authRepo}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // Email updated
    if (event is LoginEmailChanged) {
      yield state.copyWith(email: event.email);

      // Password updated
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);

      // Form submitted
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        await authRepo?.login();
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e.toString()));
      }
    }
  }
}