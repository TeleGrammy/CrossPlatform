import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/presentation/view_models/contacts_cubit/contacts_cubit.dart';
import 'package:telegrammy/features/messages/presentation/views/chats_view.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

import 'contacts_view_test.mocks.dart';

@GenerateMocks([ContactsCubit],
    customMocks: [MockSpec<ContactsCubit>(as: #MyMockContactsCubit)])

// class MockContactsCubit extends Mock implements ContactsCubit {}
// class MockContactsCubit extends MockCubit<ContactsState> implements ContactsCubit {}
// class AStateFake extends Fake implements ContactsState {}

void main() {
  late MyMockContactsCubit mockContactsCubit;

  // setUpAll(() {
  //   mocktail.registerFallbackValue(AStateFake());
  // });
  setUp(() {
    mockContactsCubit = MyMockContactsCubit();
    when(mockContactsCubit.stream).thenAnswer((_) => Stream.empty());
    // mocktail.when(() => mockContactsCubit.state).thenReturn(ContactsInitial());
    // // Default behavior: return ContactsInitial state
    // when(mockContactsCubit.state).thenReturn(ContactsInitial());
  });

  Widget createTestableWidget() {
    return MaterialApp(
      home: BlocProvider<ContactsCubit>(
        create: (_) => mockContactsCubit,
        child: const ContactsScreen(),
      ),
    );
  }

  testWidgets(
      'displays CircularProgressIndicator when state is ContactsLoading',
      (WidgetTester tester) async {
    when(mockContactsCubit.state).thenReturn(ContactsLoading());

    await tester.pumpWidget(createTestableWidget());

    expect(find.byKey(const Key('loading_contancts')), findsOneWidget);
  });

  testWidgets('displays contacts list when state is ContactsSuccess',
      (WidgetTester tester) async {
    final mockContacts = [
      Contact(
          id: '1',
          participants: [
            Participant(
                id: '2',
                user: User(id: '1', username: 'john'),
                joinedAt: 'joinedAt',
                draftMessage: 'draftMessage')
          ],
          isGroup: false,
          createdAt: '2023-01-01',
          isChannel: false),
    ];

    when(mockContactsCubit.state)
        .thenReturn(ContactsSuccess(contactsExcludingMembers: mockContacts));

    await tester.pumpWidget(createTestableWidget());

    expect(find.byKey(const Key('contactsList')), findsOneWidget);
    expect(find.byKey(const Key('contactItem_0')), findsOneWidget);
  });

  testWidgets('displays error message when state is ContactsFailure',
      (WidgetTester tester) async {
    when(mockContactsCubit.state).thenReturn(ContactsFailture());

    await tester.pumpWidget(createTestableWidget());

    expect(find.byKey(const Key('Contacts_error')), findsOneWidget);
  });

  testWidgets('displays no contacts message when state is default',
      (WidgetTester tester) async {
    when(mockContactsCubit.state).thenReturn(ContactsInitial());

    await tester.pumpWidget(createTestableWidget());

    expect(find.byKey(const Key('Contacts_initial')), findsOneWidget);
  });
}
