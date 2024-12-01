// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:telegrammy/features/profile/data/models/blocked_user_model.dart';
// import 'package:telegrammy/features/profile/presentation/view_models/blocked_users_cubit/blocked_users_cubit.dart';
// import 'package:telegrammy/features/profile/presentation/view_models/blocked_users_cubit/blocked_users_state.dart';
// import 'package:telegrammy/features/profile/presentation/widgets/security_options.dart';

// import 'widget_mock.mocks.dart';

// void main() {
//   late MockBlockedUsersCubit mockCubit;

//   setUp(() {
//     mockCubit = MockBlockedUsersCubit();
//     when(() => mockCubit.stream).thenReturn(Stream.empty());
//   });

//   Widget createTestWidget(Widget child) {
//     return MaterialApp(
//       home: BlocProvider<BlockedUsersCubit>.value(
//         value: mockCubit,
//         child: Scaffold(body: child),
//       ),
//     );
//   }

//   group('SecurityOptions Widget Tests', () {
//     testWidgets('displays loading state correctly', (WidgetTester tester) async {
//       when(() => mockCubit.state).thenReturn(BlockedUsersLoading());

//       await tester.pumpWidget(createTestWidget(SecurityOptions()));

//       // Verify loading indicator is displayed
//       expect(find.byType(CircularProgressIndicator), findsOneWidget);

//       // Verify no ListTile is present (loading state might not show ListTile)
//       expect(find.byType(ListTile), findsNothing);
//     });

//     testWidgets('displays blocked users count when loaded', (WidgetTester tester) async {
//       final mockBlockedUsers = [
//         UserData(userId: '1', userName: 'User1'),
//         UserData(userId: '2', userName: 'User2'),
//       ];
//       when(() => mockCubit.state).thenReturn(BlockedUsersLoaded(blockedUsers: mockBlockedUsers));

//       await tester.pumpWidget(createTestWidget(SecurityOptions()));

//       // Verify "Blocked Users" title
//       expect(find.text('Blocked Users'), findsOneWidget);

//       // Verify blocked user count
//       expect(find.text('${mockBlockedUsers.length}'), findsOneWidget);
//     });

//     // Simpler test for "0" count using an empty list
//     testWidgets('displays zero count when no blocked users exist', (WidgetTester tester) async {
//       when(() => mockCubit.state).thenReturn(BlockedUsersLoaded(blockedUsers: []));

//       await tester.pumpWidget(createTestWidget(SecurityOptions()));

//       // Verify "Blocked Users" title
//       expect(find.text('Blocked Users'), findsOneWidget);

//       // Verify zero count
//       expect(find.text('0'), findsOneWidget);
//     });

//     // **Testing Navigation (Alternative Approach):**
//     // While directly testing GoRouter navigation within the widget test might be challenging,
//     // we can test if the `onTap` callback for the "Blocked Users" ListTile triggers
//     // with the expected arguments. This indirectly verifies navigation intent.

//   //   testWidgets('calls onTap callback with correct arguments for Blocked Users ListTile', (WidgetTester tester) async {
//   //     final mockOnTap = MockFunction();
//   //     when(() => mockCubit.state).thenReturn(BlockedUsersLoaded(blockedUsers: []));

//   //     await tester.pumpWidget(createTestWidget(SecurityOptions(onTapBlockedUsers: mockOnTap)));

//   //     // Find the ListTile for "Blocked Users"
//   //     final blockedUsersListTile = find.text('Blocked Users').first;

//   //     // Simulate tapping the ListTile
//   //     await tester.tap(blockedUsersListTile);

//   //     // Verify that the mockOnTap callback is called with the expected argument
//   //     verify(() => mockOnTap(context: any<BuildContext>())).called(once);
//   //   });
//   // });
// }