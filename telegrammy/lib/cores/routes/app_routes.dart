import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/helpers/routes_helper.dart';
import 'package:telegrammy/features/Home/presentation/views/home_view.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:telegrammy/features/auth/presentation/views/login_view.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/features/auth/presentation/view_models/signup_cubit/signup_cubit.dart';
import 'package:telegrammy/features/auth/presentation/views/account_verification_view/account_verification_view.dart';
import 'package:telegrammy/features/auth/presentation/views/resetpassword_view/reset_password.dart';
import 'package:telegrammy/features/auth/presentation/views/resetpassword_view/verify_otp.dart';
import 'package:telegrammy/features/auth/presentation/views/signup_view/signup_view.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart';
import 'package:telegrammy/features/profile/presentation/views/creating_user_story_view.dart';
import 'package:telegrammy/features/profile/presentation/views/profile_privacy_view.dart';
import 'package:telegrammy/features/profile/presentation/views/stories_view.dart';
import 'package:telegrammy/features/profile/presentation/views/privacy_allowable.dart';
import 'package:telegrammy/features/profile/presentation/view_models/story_cubit/story_cubit.dart';
import 'package:telegrammy/features/profile/presentation/views/user_story_view.dart';


class AppRoutes {
  static GoRouter goRouter = GoRouter(
    redirect: (context, state) async {
      RoutesHelper helper = RoutesHelper();
      final bool isLoggedin = await helper.isLoggedIn();
      final bool issignedUp = await helper.isSignedUp();

      if (isLoggedin && state.uri.toString() == '/') {
        return '/home'; // Redirect to the app main screen
      }

      if (!isLoggedin && issignedUp) {
        return '/email-verification';
      }

      if (!isLoggedin && !issignedUp && state.uri.toString() == '/home') {
        return '/'; // Redirect to sign-up or login
      }
      
      return null; // No redirection needed
    },
    routes: [
      GoRoute(
        name: RouteNames.signUp,
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => SignUpCubit(),
          child: const SignUpView(),
        ),
      ),
      GoRoute(
        name: RouteNames.emailVerification,
        path: '/email-verification',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => SignUpCubit(),
            child: AccountVerificationView(),
          );
        },
      ),
      GoRoute(
        name: RouteNames.login,
        path: '/login',
        builder: (context, state) => BlocProvider(
          create: (context) => LoginCubit(),
          child: LoginView(),
        ),
      ),
      GoRoute(
        name: RouteNames.home,
        path: '/home',
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
      GoRoute(
        name: RouteNames.profilePrivacyPage,
        path: '/profile_privacy',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PrivacySettingsCubit(
               
              ),
            ),
          ],
          child: PrivacyView(),
        ),
      ),
     GoRoute(
  name: RouteNames.privacyAllowablePage,
  path: '/privacy-allowable',
  builder: (context, state) {
    final params = state.extra as Map<String, dynamic>?; // Safe extraction of parameters
    final title = params?['title'] as String? ?? 'Default Title'; // Default title if null
    final optionKey = params?['optionKey'] as String? ?? 'defaultOptionKey'; // Default option key if null

    return MultiBlocProvider(
      providers: [
        BlocProvider<PrivacySettingsCubit>(
          create: (context) => PrivacySettingsCubit(),
        ),
        // Add more BlocProviders here if needed
      ],
      child: PrivacyAllowablePage(
        title: title,
        optionKey: optionKey,
      ),
    );
  },
),
     GoRoute(
  name: RouteNames.userStoryPage,
  path: '/user-stories-page',
  builder: (context, state) {
    return BlocProvider(
      create: (context) => StoriesCubit(), // Ensure you provide the appropriate Bloc/Cubit
      child: UserStoryView(), // Your StoriesView widget
    );
  },
),
GoRoute(
  name: RouteNames.storiesPage,
  path: '/stories-page',
  builder: (context, state) {
    return BlocProvider(
      create: (context) => StoriesCubit(), // Ensure you provide the appropriate Bloc/Cubit
      child: StoriesView(), // Your StoriesView widget
    );
  },
),
GoRoute(
  name: RouteNames.createStoryPage,
  path: '/create-stories-page',
  builder: (context, state) {
    return BlocProvider(
      create: (context) => StoriesCubit(), // Ensure you provide the appropriate Bloc/Cubit
      child: CreateStoryPage(), // Your StoriesView widget
    );
  },
),
    ],
  );
}