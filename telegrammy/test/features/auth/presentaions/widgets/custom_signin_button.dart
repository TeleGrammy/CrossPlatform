// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:telegrammy/features/auth/presentation/widgets/customSigninButton.dart';

// // Create a mock class for the sign-in function using Mockito
// class MockSignInFunction extends Mock {
//   Future<void> call();
// }

// Future<void> myAsyncFunction() async {}
// void main() {
//   testWidgets('Customsigninbutton calls signinWithSocialAccount when pressed',
//       (WidgetTester tester) async {
//     // Create the mock function
//     final mockSignInFunction = MockSignInFunction();

//     // Set up the mock function to return a Future<void>
//     when(mockSignInFunction.call()).thenAnswer((_) => myAsyncFunction());

//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: Customsigninbutton(
//             icon: Icons.login,
//             signinWithSocialAccount: mockSignInFunction,
//           ),
//         ),
//       ),
//     );

//     final iconButtonFinder = find.byIcon(Icons.login);

//     await tester.tap(iconButtonFinder);

//     await tester.pump();

//     verify(mockSignInFunction.call()).called(1);
//   });
// }
