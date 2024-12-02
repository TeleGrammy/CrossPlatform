import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:telegrammy/features/messages/presentation/widgets/audio_player_widget.dart';

import 'audio_player_widget.mocks.dart';

@GenerateMocks([AudioPlayer])
void main() {
  group('AudioPlayerWidget Tests', () {
    late MockAudioPlayer mockAudioPlayer;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
    });

    testWidgets('toggles play/pause and updates isPlaying state', (WidgetTester tester) async {

      const testAudioUrl = 'https://example.com/audio.mp3';
      // Arrange
      when(mockAudioPlayer.play(UrlSource(testAudioUrl))).thenAnswer((_) async => {});
      when(mockAudioPlayer.pause()).thenAnswer((_) async => {});

      // Build the widget with the mock player
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AudioPlayerWidget(audioUrl: testAudioUrl,audioPlayer: mockAudioPlayer,),
          ),
        ),
      );

      // Get the play/pause button
      final playPauseButton = find.byKey(const Key('play_pause_button'));
      final playStatusText = find.byKey(const Key('play_status_text'));
      expect(playPauseButton, findsOneWidget);
      expect(playStatusText, findsOneWidget);

      // // Assert initial state
      expect(find.text('Paused'), findsOneWidget);
      expect(find.text('Playing...'), findsNothing);

      // Act: Simulate play button press
      await tester.tap(playPauseButton);
      await tester.pump(); // Rebuild UI
      // // // Assert: State should change to playing
      expect(find.text('Playing...'), findsOneWidget);
      expect(find.text('Paused'), findsNothing);
      // verify(mockAudioPlayer.play(UrlSource(testAudioUrl))).called(1);

      // Act: Simulate pause button press 
      await tester.tap(playPauseButton);
      await tester.pump(); // Rebuild UI

      // // Assert: State should change to paused
      expect(find.text('Paused'), findsOneWidget);
      expect(find.text('Playing...'), findsNothing);
      verify(mockAudioPlayer.pause()).called(1);
    });
  });
}
