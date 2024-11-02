import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:telegrammy/features/Home/presentation/views/home_view.dart';
// import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
// import 'package:telegrammy/features/auth/presentation/views/login_view.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
// import 'package:telegrammy/cores/services/service_locator.dart';
// import 'package:telegrammy/cores/services/token_storage_service.dart';
// import 'package:telegrammy/features/auth/presentation/view_models/cubit/signup_cubit.dart';
// import 'package:telegrammy/features/auth/presentation/views/account_verification_view/account_verification_view.dart';
// import 'package:telegrammy/features/auth/presentation/views/reset_password.dart';
// import 'package:telegrammy/features/auth/presentation/views/signup_view/signup_view.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart';
import 'package:telegrammy/features/profile/presentation/views/profile_privacy_view.dart';
import 'package:telegrammy/features/profile/presentation/views/stories_view.dart';
import 'package:telegrammy/features/profile/presentation/views/privacy_allowable.dart';
// class AppRoutes {
//   static GoRouter goRouter = GoRouter(
//     redirect: (context, state) async {
//       // final bool isLoggedin = await isLoggedIn();
//       // final bool isVerified = await isCaptchaVerified();

//       // // If the user has logged in and tries to access sign-up or login, send them to the home page
//       // if (isLoggedin && state.uri.toString() == '/signup') {
//       //   return '/'; // Redirect to home
//       // }

//       // // If the user has signedup but not verified and tries to access sign-up, send them to the verification page
//       // if (!isLoggedin && state.uri.toString() == '/signup' && isVerified) {
//       //   return '/email-verification'; // Redirect to home
//       // }

//       // // If the user is not authenticated and tries to access home, send them to the login/signup page
//       // if (!isLoggedin && !isVerified && state.uri.toString() == '/') {
//       //   return '/signup'; // Redirect to sign-up or login
//       // }

//       // Return null to indicate no redirection needed
//       return null;
//     },
//     routes: [
//       // GoRoute(
//       //   name: RouteNames.signUp,
//       //   path: '/signup',
//       //   builder: (context, state) => BlocProvider(
//       //     create: (context) => SignUpCubit(),
//       //     child: const SignUpView(),
//       //   ),
//       // ),
//       // GoRoute(
//       //     name: RouteNames.login,
//       //     path: '/login',
//       //     builder: (context, state) => BlocProvider(
//       //           create: (context) => LoginCubit(),
//       //           child: LoginView(),
//       //         )),
//       // GoRoute(
//       //   name: RouteNames.emailVerification,
//       //   path: '/email-verification',
//       //   builder: (context, state) {
//       //     // Retrieve the email from the query parameters
//       //     final email = state.uri.queryParameters['email'];
//       //     return BlocProvider(
//       //       create: (context) => SignUpCubit(),
//       //       child: AccountVerificationView(email: email!),
//       //     );
//       //   },
//       // ),
//       // GoRoute(
//       //   name: RouteNames.home,
//       //   path: '/',
//       //   builder: (context, state) => HomeView(),
//       // ),
//       // GoRoute(
//       //   name: RouteNames.resetPassword,
//       //   path: '/reset-password',
//       //   builder: (context, state) => ForgotPasswordScreen(),
//       // ),
//  GoRoute(
//        name: RouteNames.profilePrivacyPage,
//         path: '/privacy',
//         builder: (context, state) => MultiBlocProvider(
//           providers: [
//             BlocProvider(create: (_) => PrivacySettingsCubit()),
//             BlocProvider(create: (_) => SecurityCubit()),
//           ],
//           child: PrivacyView(),
//         ),
//       ),
//             GoRoute(
//         name: RouteNames.storiesPage,
//         path: '/',
//         builder: (context, state) => StoriesView(),
//       ),
     
//     ],
//   );
// }

// // Future<bool> isLoggedIn() async {
// //   String? token = await getit.get<TokenStorageService>().getToken();
// //   if (token != null && token.isNotEmpty) {
// //     return true;
// //   } else {
// //     return false;
// //   }
// // }

// // Future<bool> isCaptchaVerified() async {
// //   String? token = await getit.get<TokenStorageService>().getCaptchaToken();
// //   if (token != null && token.isNotEmpty) {
// //     return true;
// //   } else {
// //     return false;
// //   }
// // }
class AppRoutes {
  static GoRouter goRouter = GoRouter(
    routes: [
      GoRoute(
        name: RouteNames.profilePrivacyPage,
        path: '/',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => PrivacySettingsCubit()),
            BlocProvider(create: (_) => SecurityCubit()),
          ],
          child: PrivacyView(),
        ),
      ),
      GoRoute(
        name: RouteNames.storiesPage,
        path: '/stories',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => PrivacySettingsCubit()),
            BlocProvider(create: (_) => SecurityCubit()),
          ],
          child: StoriesView(),
        ),
      ),
     GoRoute(
        name: RouteNames.privacyAllowablePage,
        path: '/privacy-allowable',
        builder: (context, state) {
          // Retrieve parameters from the state
          final title = state.extra?.toString().split(',').first ?? 'Default Title'; // Safely extract title
          final optionKey = state.extra?.toString().split(',').last ?? 'Default Option'; // Safely extract optionKey

          return BlocProvider.value(
            value: context.read<PrivacySettingsCubit>(), // Use the existing instance
            child: PrivacyAllowablePage(
              title: title,
              optionKey: optionKey,
            ),
          );
        },
      ),

      // Other routes...
    ],
  );
}