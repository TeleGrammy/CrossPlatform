
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:telegrammy/features/messages/presentation/views/chat_details.dart';
import 'package:telegrammy/features/messages/presentation/views/forward_to_page.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_bottom_bar.dart';

import 'selected_messagebar_button.mocks.dart';
class mockRoutes {
  final goRouter = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SelectedMessageBottomBar(onReply: () => {}),
    ),
    GoRoute(
      name: 'forwardToPage',
      path: '/forwardToPage',
      builder: (context, state) => ForwardToPage(),
    )
  ]);
}
// class MockChatDetails extends Mock implements ChatDetails{}
@GenerateMocks([ChatDetails])


void main(){
  testWidgets('click on relpy button', (WidgetTester tester)async{
    bool replied=false;
    await tester.pumpWidget(MaterialApp(
      home: SelectedMessageBottomBar(onReply: ()=>replied=true),
    ));

    // MockChatDetails mockChatDetails=MockChatDetails();
    // final chatDetailsState =
    //       tester.state<ChatDetailsState>(find.byType(ChatDetails));

    // when(chatDetailsState.onReply).thenReturn((){});

    await tester.tap(find.byKey(Key('reply_message_button')));

    expect(replied, true);
  });
  testWidgets('click forward button', (WidgetTester tester)async{

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: mockRoutes().goRouter,
    ));

    await tester.tap(find.byKey(Key('forward_message_button')));

    await tester.pumpAndSettle();

    expect(find.byKey(Key('contactsList')), findsOneWidget);
  });
}