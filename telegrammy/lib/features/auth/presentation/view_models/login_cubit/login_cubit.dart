import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/auth/data/repos/auth_repo_implemention.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  Future<void> signinWithGoogleCubit() async {
    //   StreamSubscription? uriLinkStreamSubscription;
    //   uriLinkStreamSubscription = uriLinkStream.listen((Uri? uri) {
    //     if (uri != null &&
    //         uri.scheme == 'http' &&
    //         uri.host == 'localhost' &&
    //         uri.port == 8080) {
    //       print('Redirected to app with URI: $uri');
    //       // Handle successful sign-in here
    //       uriLinkStreamSubscription
    //           ?.cancel(); // Cancel the subscription once handled
    //     }
    //   });

    final result = await getit.get<AuthRepoImplemention>().signInWithGoogle();
    print(result);
    result.fold((failure) {
      emit(LoginError(message: failure.errorMessage));
    }, (data) {
      emit(LoginSucess());
    });
  }

  Future<void> signInUser(userData) async {
    final result = await getit.get<AuthRepoImplemention>().signInUser(userData);
    result.fold((errorMessage) {
      emit(LoginError(message: errorMessage));
    }, (data) {
      emit(LoginSucess());
    });
  }

  Future<void> signinWithFacebookCubit() async {
    final result = await getit.get<AuthRepoImplemention>().signInWithFacebook();
    result.fold((failure) {
      emit(LoginError(message: failure.errorMessage));
    }, (data) {
      emit(LoginSucess());
    });
  }

  Future<void> signinWithGithubCubit() async {
    final result = await getit.get<AuthRepoImplemention>().signInWithGitHub();
    result.fold((failure) {
      emit(LoginError(message: failure.errorMessage));
    }, (data) {
      emit(LoginSucess());
    });
  }

  Future<void> forgetPassword(email) async {
    final result =
        await getit.get<AuthRepoImplemention>().forgetPassword(email);
    result.fold((failure) {
      emit(LoginError(message: failure.errorMessage));
    }, (data) {
      emit(LoginSucess());
    });
  }
}
