import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:telegrammy/cores/widgets/custom_text_field.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:telegrammy/features/auth/presentation/widgets/form_login.dart';

import 'sign_in_using_soial_media.mocks.dart';

// import 'login_cubit_test.mocks.dart';

void main() {
  group('FormLogin Widget Test', () {
    late MockLoginCubit mockLoginCubit;

    setUp(() {
      mockLoginCubit = MockLoginCubit();
      when(mockLoginCubit.stream).thenAnswer((_) => Stream.empty());
    });

    Future<void> pumpLoginForm(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<LoginCubit>(
            create: (_) => mockLoginCubit,
            child: const Scaffold(
              body: FormLogin(),
            ),
          ),
        ),
      );
    }

    testWidgets('should validate and call signInUser on valid input',
        (WidgetTester tester) async {
      await pumpLoginForm(tester);

      // Enter valid email and password
      await tester.enterText(
          find.byType(CustomTextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(CustomTextField).at(1), 'password123');

      // Tap on the login button
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();

      // Verify that signInUser was called with the correct data
      verify(mockLoginCubit.signInUser({
        'UUID': 'test@example.com',
        'password': 'password123',
      })).called(1);
    });

    testWidgets('should show error message for invalid email',
        (WidgetTester tester) async {
      await pumpLoginForm(tester);

      // Enter invalid email and valid password
      await tester.enterText(
          find.byType(CustomTextField).at(0), 'invalid_email');
      await tester.enterText(find.byType(CustomTextField).at(1), 'password123');

      // Tap on the login button
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();

      // Verify that error message is displayed
      expect(find.text('Please enter a valid email'), findsOneWidget);
      verifyNever(mockLoginCubit.signInUser(any));
    });

    testWidgets('should show error message for short password',
        (WidgetTester tester) async {
      await pumpLoginForm(tester);

      // Enter valid email and short password
      await tester.enterText(
          find.byType(CustomTextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(CustomTextField).at(1), '123');

      // Tap on the login button
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();

      // Verify that error message is displayed
      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
      verifyNever(mockLoginCubit.signInUser(any));
    });
  });
}
