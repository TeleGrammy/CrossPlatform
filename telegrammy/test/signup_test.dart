import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:telegrammy/cores/errors/Failure.dart';
import 'package:telegrammy/cores/services/auth_api_service.dart';
import 'package:telegrammy/features/auth/data/repos/auth_repo_implemention.dart';
import 'package:telegrammy/features/auth/presentation/view_models/signup_cubit/signup_cubit.dart';
import 'package:telegrammy/features/auth/presentation/views/signup_view/signup_view.dart';

// Mock Classes
class MockApiService extends Mock implements ApiService {
  final Dio dio;

  MockApiService({required this.dio});
}

class MockAuthRepository extends Mock implements AuthRepoImplemention {
  final MockApiService apiService;

  MockAuthRepository({required this.apiService});
}

void main() {
  //-----------------------Widget testing------------------------
  testWidgets('displays a message if fields are empty in the sign up form test',
      (WidgetTester tester) async {
    // Arrange: Build the widget
    await tester.pumpWidget(
      BlocProvider(
        create: (context) => SignUpCubit(),
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              child: SignUpView(),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Wait for the widget to load

    // Act: Find the sign-up button by key and tap it
    final signUpButton = find.byKey(Key('signUpButton'));
    expect(signUpButton, findsOneWidget); // Ensure button is found
    await tester.ensureVisible(signUpButton); // Ensure button is visible
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    // Assert: Check for validation error messages
    expect(find.text('Username is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Phone number is required'), findsOneWidget);
    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
  });

  testWidgets('display a message if the email is invalid test',
      (WidgetTester tester) async {
    // Arrange: Build the widget
    await tester.pumpWidget(
      BlocProvider(
        create: (context) => SignUpCubit(),
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              child: SignUpView(),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Wait for the widget to load

    // Find the email field and enter an invalid email
    await tester.enterText(find.byKey(Key('emailField')), 'invalidemail');
    await tester.pumpAndSettle(); // Wait for changes

    // Find the submit button and tap it
    final signUpButton = find.byKey(Key('signUpButton'));
    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester
        .pumpAndSettle(); // Wait for the UI update after tapping the button

    // Check if the invalid email error message is displayed
    await tester.ensureVisible(
        find.text('Enter a valid email')); // Ensure error text is visible

    expect(find.text('Enter a valid email'), findsOneWidget);
  });

  testWidgets(
    'display a message if password confirm doesn\'t match password',
    (WidgetTester tester) async {
      // Arrange: Build the widget
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => SignUpCubit(),
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                child: SignUpView(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(); // Wait for the widget to load

      // Enter password and confirm password
      await tester.enterText(find.byKey(Key('passwordField')), '12345678');
      await tester.pumpAndSettle(); // Wait for changes

      await tester.enterText(
          find.byKey(Key('confirmPasswordField')), '123456778');
      await tester.pumpAndSettle(); // Wait for changes

      // Tap the sign-up button
      final signUpButton = find.byKey(Key('signUpButton'));
      await tester.ensureVisible(signUpButton); // Ensure the button is visible
      await tester.tap(signUpButton);
      await tester
          .pumpAndSettle(); // Wait for the UI update after tapping the button

      // Ensure that the error message is visible
      await tester.ensureVisible(find.text('Passwords do not match'));

      // Assert the error message is displayed
      expect(find.text('Passwords do not match'), findsOneWidget);
    },
  );

  //-----------------------------cubit testing-----------------------------
  late SignUpCubit signUpCubit;

  setUp(() {
    signUpCubit = SignUpCubit();

    // Initialize get_it for the test
    GetIt.instance.reset(); // Clear any existing registrations

    GetIt.instance
        .registerSingleton<MockApiService>(MockApiService(dio: Dio()));

    // Register the mock repo in get_it
    GetIt.instance.registerSingleton<AuthRepoImplemention>(
        MockAuthRepository(apiService: GetIt.instance.get<MockApiService>()));

    // Register the SignUpCubit
    GetIt.instance.registerFactory<SignUpCubit>(() => SignUpCubit());

    // Get the cubit instance from get_it
    signUpCubit = GetIt.instance<SignUpCubit>();
  });

  tearDown(() {
    // Reset get_it after each test to avoid side effects
    GetIt.instance.reset();
  });

  tearDown(() {
    // Reset get_it after each test to avoid side effects
    GetIt.instance.reset();
  });

  blocTest<SignUpCubit, SignUpState>(
    'emits SignUpLoading then SignUpSuccess when signUp is successful',
    build: () {
      // Arrange: Mock the method in the AuthRepo
      when(() => GetIt.instance.get<AuthRepoImplemention>().signUpUser(any()))
          .thenAnswer((_) async => Right(null)); // Mocking the response
      return signUpCubit;
    },
    act: (cubit) async {
      // Act: Call the cubit method
      await signUpCubit.signUpUser({
        'email': 'email@example.com',
        'username': 'test1',
        'phone Number': '0112234242',
        'password': '12345678',
        'confirm password': '12345678'
      });
    },
    expect: () => [
      isA<SignUpLoading>(),
      isA<SignUpSuccess>(),
    ],
  );
  blocTest<SignUpCubit, SignUpState>(
    'should emit error when email is already signed up',
    build: () {
      when(() => GetIt.instance.get<AuthRepoImplemention>().signUpUser(any()))
          .thenAnswer((_) async =>
              Left(ServerError(errorMessage: 'this email already exists')));
      return signUpCubit;
    },
    act: (cubit) async {
      // Act: Call the cubit method
      await signUpCubit.signUpUser({
        'email': 'email@example.com',
        'username': 'test1',
        'phone Number': '0112234242',
        'password': '12345678',
        'confirm password': '12345678'
      });
    },
    expect: () => [
      isA<SignUpLoading>(),
      isA<SignUpFailure>(),
    ],
  );

  blocTest<SignUpCubit, SignUpState>(
    'should emit error if the verification code is less that 6 digits',
    build: () {
      //Arrange: Mock the method to return an error if the email is already signed up
      when(() => GetIt.instance
              .get<MockApiService>()
              .emailVerification(any(), any()))
          .thenThrow(Exception('verification code should be 6 numbers'));
      return signUpCubit;
    },
    act: (cubit) async {
      // Act: Call the cubit method
      await signUpCubit.emailVerification('rawan@gmail.com', '1234');
    },
    expect: () => [
      isA<VerificationLoading>(),
      isA<VerificationFailure>(),
    ],
  );
}
