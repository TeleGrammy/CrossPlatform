// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mockito/mockito.dart';
// import 'package:telegrammy/cores/routes/app_routes.dart';
// import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';

// import '../widgets/sign_in_using_soial_media.mocks.dart';

// void main() {
//   group('LoginView Widget Test', () {
//     late MockLoginCubit mockLoginCubit;
//     final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

//     setUp(() {
//       mockLoginCubit = MockLoginCubit();
//       when(mockLoginCubit.stream).thenAnswer((_) => Stream.empty());
//     });

//     Future<void> pumpLoginView(WidgetTester tester, LoginCubit cubit) async {
//       await tester.pumpWidget(
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<LoginCubit>.value(value: cubit),
//           ],
//           child: MaterialApp.router(
//             scaffoldMessengerKey: scaffoldMessengerKey,
//             routerConfig: AppRoutes.goRouter,
//           ),
//         ),
//       );
//     }

//     testWidgets('Navigates to Home screen on Login Success',
//         (WidgetTester tester) async {
//       // Mocking the stream to emit LoginSuccess state
//       when(mockLoginCubit.stream)
//           .thenAnswer((_) => Stream.fromIterable([LoginSucess()]));

//       await pumpLoginView(tester, mockLoginCubit);
//       await tester.pumpAndSettle();

//       // Verify that navigation to home occurred by checking for HomeView content
//       expect(find.text('data'), findsOneWidget);
//     });

//     testWidgets('Shows SnackBar with error message on Login Error',
//         (WidgetTester tester) async {
//       const errorMessage = 'Invalid credentials';

//       // Mocking the stream to emit LoginError state
//       when(mockLoginCubit.stream)
//           .thenAnswer((_) => Stream.fromIterable([LoginError(message: errorMessage)]));

//       await pumpLoginView(tester, mockLoginCubit);
//       await tester.pumpAndSettle();

//       // Verify that the SnackBar is displayed with the correct error message
//       expect(find.byType(SnackBar), findsOneWidget);
//       expect(find.text(errorMessage), findsOneWidget);
//     });
//   });
// }
