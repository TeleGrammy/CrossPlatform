import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/auth/data/repos/auth_repo_implemention.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> signinWithGoogleCubit() async {
    final result = await getit.get<AuthRepoImplemention>().signInWithGoogle();

    result.fold((failure) {
      emit(LoginError(message: failure.errorMessage));
    }, (data) {
      emit(LoginSucess());
    });
  }
}
