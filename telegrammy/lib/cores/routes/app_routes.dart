import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/features/Home/presentation/views/home_view.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:telegrammy/features/auth/presentation/views/login_view.dart';

class AppRoutes {
  static GoRouter goRouter = GoRouter(routes: [
    GoRoute(
      name: RouteNames.home,
      path: '/',
      builder: (context, state) => HomeView(),
    ),
    GoRoute(
      name: RouteNames.login,
      path: '/login',
      builder: (context, state) => BlocProvider(
        create: (context) => LoginCubit(),
        child: LoginView(),
      ),
    )
  ]);
}
