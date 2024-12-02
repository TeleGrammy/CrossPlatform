// import 'package:flutter/material.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:telegrammy/features/messages/presentation/data/messages.dart';
// import 'package:telegrammy/features/messages/presentation/widgets/bottom_bar.dart';

// import 'bottom_bar_test.mocks.dart';
// @GenerateMocks([FlutterSoundRecorder])

// @GenerateMocks([TextEditingController])

// void main() {
//   group('BottomBar Widget Tests', () {
//     late MockFlutterSoundRecorder mockRecorder;
//     late MockTextEditingController mockTextController;

//     setUp(() {
//       mockRecorder = MockFlutterSoundRecorder();
//       mockTextController = MockTextEditingController();
//     });

//     testWidgets('Initial state has emoticon icon, placeholder text, and send icon',
//         (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: BottomBar(
//                 onSend:(p0) {
                  
//                 },
//                 onEdit: (p0, p1) {
                  
//                 },
//                 onSendAudio: (p0) {
                  
//                 },
//             ),
//           ),
//         ),
//       );

//       // Assert initial state
//       expect(find.byKey(const Key('emoji_button')), findsOneWidget);
//       expect(find.byKey(const Key('message_input_field')), findsOneWidget);
//     });

//     testWidgets(
//         'Clicking record button changes state to recording (delete icon, recording text, stop icon)',
//         (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body:BottomBar(
//                 onSend:(p0) {
                  
//                 },
//                 onEdit: (p0, p1) {
                  
//                 },
//                 onSendAudio: (p0) {
                  
//                 },
//             ),
//           ),
//         ),
//       );

//       // Initial state: verify send_or_record_button is in send mode
//       final recordButton = find.byKey(const Key('send_or_record_button'));
//       expect(find.byIcon(Icons.mic), findsOneWidget);

//       // Act: Tap the record button
//       await tester.tap(recordButton);
//       await tester.pump();

//       // Assert recording state
//       expect(find.byIcon(Icons.delete), findsOneWidget);
//       expect(find.text('Recording...'), findsOneWidget);
//       expect(find.byIcon(Icons.stop), findsOneWidget);
//     });

//     testWidgets('Typing in the text field shows send icon', (WidgetTester tester) async {
//       when(mockTextController.text).thenReturn('Hello');

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: BottomBar(
//                 onSend:(p0) {
                  
//                 },
//                 onEdit: (p0, p1) {
                  
//                 },
//                 onSendAudio: (p0) {
                  
//                 },
//             ),
//           ),
//         ),
//       );

//       // Find the text field
//       final textField = find.byKey(const Key('message_input_field'));
//       await tester.enterText(textField, 'Hello');
//       await tester.pump();

//       // Assert send icon appears
//       expect(find.byIcon(Icons.send), findsOneWidget);
//     });

//     // testWidgets('onSend and onSendAudio callbacks are triggered',
//     //     (WidgetTester tester) async {
//     //   await tester.pumpWidget(
//     //     MaterialApp(
//     //       home: Scaffold(
//     //         body: BottomBar(
//     //             onSend:(p0) {
                  
//     //             },
//     //             onEdit: (p0, p1) {
                  
//     //             },
//     //             onSendAudio: (p0) {
                  
//     //             },
//     //         ),
//     //       ),
//     //     ),
//     //   );

//     //   // Act: Send a text message
//     //   final textField = find.byKey(const Key('message_input_field'));
//     //   await tester.enterText(textField, 'Test message');
//     //   await tester.pump();
//     //   await tester.tap(find.byKey(const Key('send_or_record_button')));
//     //   await tester.pump();

//     //   // Verify onSend is called
//     //   verify(mockOnSend('Test message')).called(1);

//     //   // Act: Start and stop recording
//     //   await tester.tap(find.byKey(const Key('send_or_record_button')));
//     //   await tester.pump(); // Start recording
//     //   await tester.tap(find.byKey(const Key('send_or_record_button')));
//     //   await tester.pump(); // Stop recording

//     //   // Verify onSendAudio is called
//     //   verify(mockOnSendAudio(any)).called(1);
//     // });
//   });
// }