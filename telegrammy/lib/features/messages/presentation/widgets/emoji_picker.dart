import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmojiPicker extends StatelessWidget {
  final Function(String) onEmojiSelected;
  final Function(String) onStickerSelected;
  final Function(String) onGifSelected;

  EmojiPicker({
    required this.onEmojiSelected,
    required this.onStickerSelected,
    required this.onGifSelected,
  });

  final List<String> emojis = [
    '😀',
    '😂',
    '😍',
    '😭',
    '😡',
    '😎',
    '🎉',
    '👍',
    '🔥',
    '❤️',
  ];

  final List<String> stickers = [
    'assets/images/logo.png',
    'assets/images/logo.png',
    'assets/images/logo.png',
    'assets/images/logo.png',
  ];

  final List<String> gifs = [
    'assets/images/logo.png',
    'assets/images/logo.png',
    'assets/images/logo.png',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'GIFs'),
              Tab(text: 'Stickers'),
              Tab(text: 'Emojis'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // GIFs Tab
                GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: gifs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => onGifSelected(gifs[index]),
                      child: Image.asset(
                        gifs[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                // Stickers Tab
                GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: stickers.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => onStickerSelected(stickers[index]),
                      child: Image.asset(
                        stickers[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                // Emojis Tab
                GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: emojis.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => onEmojiSelected(emojis[index]),
                      child: Center(
                        child: Text(
                          emojis[index],
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
