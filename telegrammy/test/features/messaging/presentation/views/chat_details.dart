import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';
import 'package:telegrammy/features/messages/presentation/views/chat_details.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_details_body.dart';

// class MockMessage extends Mock implements Message {}
// @GenerateMocks([ChatDetails(participantNames:'john')], customMocks: [MockSpec<ChatDetails>(as: #MyMockChatDetails)])

// class MockOnMessageTap extends Mock {
//   void call(Message message);
// }

void main() {
  group('ChatDetails Widget Tests', () {
    testWidgets('renders ChatAppBar when no message is selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChatDetails(participantNames: 'John Doe'),
        ),
      );
      // Find the specific message bubble by key
      final messageFinder = find
          .byKey(const Key('message_1')); // Assuming the first message

      // Ensure the widget is found
      expect(messageFinder, findsOneWidget);

      // Tap on the message bubble
      await tester.tap(messageFinder);
      await tester.pumpAndSettle();

      // Verify the state has updated correctly
      final state = tester
          .state<ChatDetailsState>(find.byType(ChatDetails)); // Access state
      expect(state.selectedMessage, isNotNull);
      expect(state.selectedMessage!.text, 'Hello');
      // // Verify ChatAppbar is displayed
      // expect(find.byKey(const Key('chatAppBar')), findsOneWidget);

      // // Verify SelectedMessageAppbar is NOT displayed
      // expect(find.byKey(const Key('selectedMessageAppBar')), findsNothing);
    });

    testWidgets('Test tapping on a message calls onMessageTap callback',
        (WidgetTester tester) async {
      // Build the widget.

      final messageFinder = find.byKey(Key('message_1'));
      expect(messageFinder, findsOneWidget);
      await tester.tap(messageFinder);
      await tester.pumpAndSettle();
    });

    // testWidgets('sends a new message using BottomBar',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: ChatDetails(participantNames: 'John Doe'),
    //     ),
    //   );

    //   // Enter text into the input field
    //   final textFieldFinder = find.byType(TextField);
    //   await tester.enterText(textFieldFinder, 'Hello, world!');
    //   await tester.pump();

    //   // Simulate the send button tap
    //   final sendButtonFinder =
    //       find.byType(IconButton); // Adjust based on your BottomBar
    //   await tester.tap(sendButtonFinder);
    //   await tester.pump();

    //   expect(messages.last.text, 'Hello, world!');
    // });

    // testWidgets('clears replied message on ReplyPreview cancel',
    //     (WidgetTester tester) async {
    //   final mockMessage = MockMessage();

    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: ChatDetails(participantNames: 'John Doe'),
    //     ),
    //   );

    //   // Simulate replying to a message
    //   final state =
    //       tester.state<ChatDetailsState>(find.byType(ChatDetailsState));
    //   state.onMessageSwipe(mockMessage);
    //   await tester.pumpAndSettle();

    //   // Verify ReplyPreview is displayed
    //   expect(find.byKey(const Key('replyPreview')), findsOneWidget);

    //   // Tap the cancel button in ReplyPreview
    //   final cancelButtonFinder =
    //       find.byType(IconButton); // Adjust based on ReplyPreview
    //   await tester.tap(cancelButtonFinder);
    //   await tester.pump();

    //   // Verify ReplyPreview is no longer displayed
    //   expect(find.byKey(const Key('replyPreview')), findsNothing);
    // });
  });
}
