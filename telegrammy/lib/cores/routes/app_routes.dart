import 'dart:io';

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
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_cubit.dart';
import 'package:telegrammy/features/profile/presentation/views/profile_privacy_view.dart';
import 'package:telegrammy/features/profile/presentation/views/profile_settings/story_view.dart';
import 'package:telegrammy/features/profile/presentation/views/stories_view.dart';
import 'package:telegrammy/features/profile/presentation/views/privacy_allowable.dart';
import 'package:telegrammy/features/profile/presentation/view_models/story_cubit/story_cubit.dart';
import 'package:telegrammy/features/profile/presentation/views/user_story_view.dart';

import 'package:telegrammy/features/profile/presentation/views/profile_settings/profile_info_view.dart';
import 'package:telegrammy/features/profile/presentation/views/profile_settings/edit_profile_info_view.dart';

import '../../features/profile/presentation/views/profile_settings/stories_page.dart';

class AppRoutes {
  static GoRouter goRouter = GoRouter(
    // redirect: (context, state) async {
    //   RoutesHelper helper = RoutesHelper();
    //   final bool isLoggedin = await helper.isLoggedIn();
    //   final bool issignedUp = await helper.isSignedUp();

    //   // If the user has logged in and tries to access sign-up or login, send them to the home page
    //   if (isLoggedin && state.uri.toString() == '/') {
    //     return '/home'; //redirect to the app main screen
    //   }

    //   // If the user has signedup but not verified send them to the verification page
    //   if (!isLoggedin && issignedUp) {
    //     return '/email-verification';
    //   }

    //   // If the user is not authenticated and tries to access home, send them to the login/signup page
    //   if (!isLoggedin && !issignedUp && state.uri.toString() == '/home') {
    //     return '/'; // Redirect to sign-up or login
    //   }

    //   // Return null to indicate no redirection needed
    //   return null;
    // },
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
        builder: (context, state) => BlocProvider(
          create: (context) => LoginCubit(),
          child: ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        name: RouteNames.sentResetPasswordSuccessfully,
        path: '/sentResetPasswordSuccessfully',
        builder: (context, state) => CheckEmailScreen(),
      ),
      GoRoute(
        name: 'socialAuthLoading',
        path: '/social-auth-loading',
        builder: (context, state) {
          // Extract the accessToken from the query parameters
          final accessToken = state.uri.queryParameters['accessToken'];
          // print(accessToken);
          return HomeView();
        },
      ),
      GoRoute(
        name: RouteNames.profilePrivacyPage,
        path: '/profile_privacy',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PrivacySettingsCubit(),
            ),
          ],
          child: PrivacyView(),
        ),
      ),
      GoRoute(
        name: RouteNames.privacyAllowablePage,
        path: '/privacy-allowable',
        builder: (context, state) {
          final params = state.extra
              as Map<String, dynamic>?; // Safe extraction of parameters
          final title = params?['title'] as String? ??
              'Default Title'; // Default title if null
          final optionKey = params?['optionKey'] as String? ??
              'defaultOptionKey'; // Default option key if null

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
            create: (context) =>
                StoriesCubit(), // Ensure you provide the appropriate Bloc/Cubit
            child: UserStoryView(), // Your StoriesView widget
          );
        },
      ),
      GoRoute(
        name: RouteNames.storiesPage,
        path: '/stories-page',
        builder: (context, state) {
          return BlocProvider(
            create: (context) =>
                StoriesCubit(), // Ensure you provide the appropriate Bloc/Cubit
            child: StoriesView(), // Your StoriesView widget
          );
        },
      ),
      GoRoute(
        name: RouteNames.createStoryPage,
        path: '/create-stories-page',
        builder: (context, state) {
          return BlocProvider(
            create: (context) =>
                StoriesCubit(), // Ensure you provide the appropriate Bloc/Cubit
            child: CreateStoryPage(), // Your StoriesView widget
          );
        },
      ),
      GoRoute(
        name: RouteNames.profileInfo,
        path: '/profile-info',
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileSettingsCubit(),
          child: ProfileInfoView(),
        ),
      ),
      GoRoute(
        name: RouteNames.editProfileInfo,
        path: '/edit-profile-info',
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileSettingsCubit(),
          child: EditProfileInfoView(),
        ),
      ),
      GoRoute(
        name: RouteNames.stories,
        path: '/storiesPage',
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileSettingsCubit(),
          child: StoriesPage(),
        ),
      ),
      GoRoute(
        name: RouteNames.storyView,
        path: '/storyView',
        builder: (context, state) {
          final image = state.extra as File;
          return StoryView(image: image);
        },
      ),
    ],
  );
}
