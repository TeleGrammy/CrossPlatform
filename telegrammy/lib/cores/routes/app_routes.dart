import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/features/Home/presentation/views/home_view.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:telegrammy/features/auth/presentation/views/login_view.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:telegrammy/features/auth/presentation/view_models/cubit/signup_cubit.dart';
import 'package:telegrammy/features/auth/presentation/views/account_verification_view/account_verification_view.dart';
import 'package:telegrammy/features/auth/presentation/views/resetpassword_view/reset_password.dart';
import 'package:telegrammy/features/auth/presentation/views/resetpassword_view/verify_otp.dart';
import 'package:telegrammy/features/auth/presentation/views/signup_view/signup_view.dart';

class AppRoutes {
  static GoRouter goRouter = GoRouter(
    redirect: (context, state) async {
      // final bool isLoggedin = await isLoggedIn();
      // final bool isVerified = await isCaptchaVerified();

      // // If the user has logged in and tries to access sign-up or login, send them to the home page
      // if (isLoggedin && state.uri.toString() == '/signup') {
      //   return '/'; // Redirect to home
      // }

      // // If the user has signedup but not verified and tries to access sign-up, send them to the verification page
      // if (!isLoggedin && state.uri.toString() == '/signup' && isVerified) {
      //   return '/email-verification'; // Redirect to home
      // }

      // // If the user is not authenticated and tries to access home, send them to the login/signup page
      // if (!isLoggedin && !isVerified && state.uri.toString() == '/') {
      //   return '/signup'; // Redirect to sign-up or login
      // }

      // Return null to indicate no redirection needed
      return null;
    },
    routes: [
      GoRoute(
        name: RouteNames.signUp,
        path: '/signup',
        builder: (context, state) => BlocProvider(
          create: (context) => SignUpCubit(),
          child: const SignUpView(),
        ),
      ),
      GoRoute(
          name: RouteNames.login,
          path: '/login',
          builder: (context, state) => BlocProvider(
                create: (context) => LoginCubit(),
                child: LoginView(),
              )),
      GoRoute(
        name: RouteNames.emailVerification,
        path: '/email-verification',
        builder: (context, state) {
          // Retrieve the email from the query parameters
          final email = state.uri.queryParameters['email'];
          return BlocProvider(
            create: (context) => SignUpCubit(),
            child: AccountVerificationView(email: email!),
          );
        },
      ),
      GoRoute(
        name: RouteNames.home,
        path: '/',
        builder: (context, state) => HomeView(),
      ),
      GoRoute(
        name: RouteNames.resetPassword,
        path: '/reset-password',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        name: RouteNames.verifyOTP,
        path: '/verify-otp',
        builder: (context, state) => OTPVerificationPage(),
      ),
    ],
  );
}

Future<bool> isLoggedIn() async {
  String? token = await getit.get<TokenStorageService>().getToken();
  if (token != null && token.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

Future<bool> isCaptchaVerified() async {
  String? token = await getit.get<TokenStorageService>().getCaptchaToken();
  if (token != null && token.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}
