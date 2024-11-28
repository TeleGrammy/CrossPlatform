import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:telegrammy/features/auth/presentation/widgets/customSigninButton.dart';
import 'package:telegrammy/features/auth/presentation/widgets/signin_using_social_media_accounts.dart';

import 'sign_in_using_soial_media.mocks.dart';

// Generate a mock class for LoginCubit
@GenerateMocks([LoginCubit])
// import 'login_cubit_test.mocks.dart';

void main() {
  late MockLoginCubit mockLoginCubit;

  setUp(() {
    mockLoginCubit = MockLoginCubit();
    when(mockLoginCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<LoginCubit>.value(
        value: mockLoginCubit,
        child: const Scaffold(
          body: SignInUsingSocialMediaAccounts(),
        ),
      ),
    );
  }

  group('SignInUsingSocialMediaAccounts', () {
    testWidgets(
        'should call signinWithGoogleCubit when Google button is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(mockLoginCubit.signinWithGoogleCubit()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byIcon(FontAwesomeIcons.google));
      await tester.pumpAndSettle();

      // Assert
      verify(mockLoginCubit.signinWithGoogleCubit()).called(1);
    });

    testWidgets(
        'should call signinWithGithubCubit when GitHub button is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(mockLoginCubit.signinWithGithubCubit()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byIcon(FontAwesomeIcons.github));
      await tester.pumpAndSettle();

      // Assert
      verify(mockLoginCubit.signinWithGithubCubit()).called(1);
    });
  });
}
