// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:telegrammy/cores/routes/app_routes.dart';
// import 'package:telegrammy/cores/routes/routes_name.dart';
// import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
// import 'package:telegrammy/features/auth/presentation/views/login_view.dart';
// import 'package:telegrammy/features/messages/presentation/view_models/contacts_cubit/contacts_cubit.dart';
// import 'package:telegrammy/features/messages/presentation/views/contacts_view.dart';

// import '../../../messaging/presentation/views/contacts_view_test.mocks.dart';
// import '../widgets/sign_in_using_soial_media.mocks.dart';
// import 'login_view_test.mocks.dart';

// @GenerateMocks([LoginCubit,ContactsCubit],
//     customMocks: [MockSpec<LoginCubit>(as: #MyMockLoginCubit),MockSpec<ContactsCubit>(as: #MyMockCcontactsCubit)])
// class mockRoutes {}

// void main() {
//   group('LoginView Widget Test', () {
//     late MyMockLoginCubit mockLoginCubit;
//     late MyMockCcontactsCubit mockContactsCubit;

//     setUp(() {
//       mockLoginCubit = MyMockLoginCubit();
//       mockContactsCubit = MyMockCcontactsCubit();
//       when(mockLoginCubit.stream).thenAnswer((_) => Stream.fromIterable([
//             LoginInitial(), // Initial state
//             LoginSucess(), // Success state
//             LoginError(message: 'error'), // Error state
//           ]));
//       when(mockContactsCubit.stream).thenAnswer((_) => Stream.fromIterable([
//             ContactsInitial(), // Initial state/ Error state
//             ContactsFailture(),
//             ContactsLoading()
//           ]));
//     });

//     testWidgets('test success state', (WidgetTester tester) async {
//       // Future<void> signinWithGithubCubit() async {}
//       when(mockLoginCubit.signinWithGithubCubit()).thenAnswer((_) async {});
//       when(mockLoginCubit.signinWithGoogleCubit()).thenAnswer((_) async {});
//       when(mockLoginCubit.state).thenReturn(LoginInitial());
//       when(mockContactsCubit.state).thenReturn(ContactsLoading());
//       final goRouter = GoRouter(routes: [
//         GoRoute(
//           path: '/',
//           builder: (context, state) => BlocProvider<LoginCubit>(
//             create: (_) => mockLoginCubit,
//             child: const LoginView(),
//           ),
//         ),
//         GoRoute(
//           name: RouteNames.contacts,
//           path: '/contacts_view',
//           builder: (context, state) => BlocProvider<ContactsCubit>(
//             create: (_) => mockContactsCubit,
//             child: const ContactsScreen(),
//           ),
//         )
//       ]);

//       await tester.pumpWidget(MaterialApp.router(
//         routerConfig: goRouter,
//       ));

//       // when(mockLoginCubit.state).thenReturn(LoginSucess());
//       // expect(find.byKey(Key('contactsList')), findsOneWidget);
//       // when(mockLoginCubit.state).thenReturn(LoginError(message: 'error'));
//       // expect(find.text('error'), findsOneWidget);
//       await tester.pumpAndSettle();
//       expect(find.byKey(Key('contactsList')), findsOneWidget);
//       // // Wait for the LoginError state and verify
//       await tester.pumpAndSettle();
//       expect(find.text('error'), findsOneWidget);
//     });

//     // Future<void> pumpLoginView(WidgetTester tester, LoginCubit cubit) async {
//     //   await tester.pumpWidget(
//     //     MultiBlocProvider(
//     //       providers: [
//     //         BlocProvider<LoginCubit>.value(value: cubit),
//     //       ],
//     //       child: MaterialApp.router(
//     //         scaffoldMessengerKey: scaffoldMessengerKey,
//     //         routerConfig: AppRoutes.goRouter,
//     //       ),
//     //     ),
//     //   );
//     // }

//     // testWidgets('Navigates to Home screen on Login Success',
//     //     (WidgetTester tester) async {
//     //   // Mocking the stream to emit LoginSuccess state
//     //   when(mockLoginCubit.stream)
//     //       .thenAnswer((_) => Stream.fromIterable([LoginSucess()]));

//     //   await pumpLoginView(tester, mockLoginCubit);
//     //   await tester.pumpAndSettle();

//     //   // Verify that navigation to home occurred by checking for HomeView content
//     //   expect(find.text('data'), findsOneWidget);
//     // });

//     // testWidgets('Shows SnackBar with error message on Login Error',
//     //     (WidgetTester tester) async {
//     //   const errorMessage = 'Invalid credentials';

//     //   // Mocking the stream to emit LoginError state
//     //   when(mockLoginCubit.stream)
//     //       .thenAnswer((_) => Stream.fromIterable([LoginError(message: errorMessage)]));

//     //   await pumpLoginView(tester, mockLoginCubit);
//     //   await tester.pumpAndSettle();

//     //   // Verify that the SnackBar is displayed with the correct error message
//     //   expect(find.byType(SnackBar), findsOneWidget);
//     //   expect(find.text(errorMessage), findsOneWidget);
//     // });
//   });
// }
