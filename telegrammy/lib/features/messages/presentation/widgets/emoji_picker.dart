import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:telegrammy/cores/services/service_locator.dart';

class EmojiPicker extends StatefulWidget {
  final Function(String) onEmojiSelected;
  final Function(String) onStickerSelected;
  final Function(String) onGifSelected;

  EmojiPicker({
    required this.onEmojiSelected,
    required this.onStickerSelected,
    required this.onGifSelected,
  });

  @override
  State<EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> {
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

  List<dynamic> stickers = [];

  List<dynamic> gifs = [];

  Future<void> getStickers() async {
    const String baseUrl = "https://api.giphy.com/v1/stickers/trending";
    const String apiKey = "3gTweeyemeToX1szdaqH7oLKCBRZjtbd";
    final Map<String, dynamic> queryParams = {"api_key": apiKey, "limit": 30};
    try {
      final dio = getit.get<Dio>();
      final response = await dio.get(baseUrl, queryParameters: queryParams);

      if (response.statusCode == 200) {
        // Successful response
        print("Data: ${response.data['data']}");
        setState(() {
          stickers = response.data['data'];
        });
        print("Pagination: ${response.data['pagination']}");
        print("Meta: ${response.data['meta']}");
      } else {
        print("Failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle errors
      print("Error: $e");
    }
  }

  Future<void> getGIFs() async {
    const String baseUrl = "https://api.giphy.com/v1/gifs/trending";
    const String apiKey = "3gTweeyemeToX1szdaqH7oLKCBRZjtbd";
    final Map<String, dynamic> queryParams = {"api_key": apiKey, "limit": 30};
    try {
      final dio = getit.get<Dio>();
      final response = await dio.get(baseUrl, queryParameters: queryParams);

      if (response.statusCode == 200) {
        // Successful response
        print("Data: ${response.data['data']}");
        setState(() {
          gifs = response.data['data'];
        });
        print("Pagination: ${response.data['pagination']}");
        print("Meta: ${response.data['meta']}");
      } else {
        print("Failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle errors
      print("Error: $e");
    }
  }

  @override
  void initState() {
    getGIFs();
    getStickers();
    super.initState();
  }

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
                gifs.isEmpty
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loading while GIFs are being fetched
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: gifs.length,
                        itemBuilder: (context, index) {
                          final gif = gifs[index];
                          final gifUrl = gif['images']['original']
                              ['url']; // Get the original GIF URL

                          return GestureDetector(
                            onTap: () {
                              widget.onGifSelected(gifUrl);
                              print('Selected GIF URL: $gifUrl');
                            },
                            child: Image.network(
                              gifUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image);
                              },
                            ),
                          );
                        },
                      ),
                stickers.isEmpty
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loading while GIFs are being fetched
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: stickers.length,
                        itemBuilder: (context, index) {
                          final sticker = stickers[index];
                          final stickerUrl = sticker['images']['original']
                              ['url']; // Get the original GIF URL

                          return GestureDetector(
                            onTap: () {
                              widget.onStickerSelected(stickerUrl);
                              print('Selected Sticker URL: $stickerUrl');
                            },
                            child: Image.network(
                              stickerUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image);
                              },
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
                      onTap: () => widget.onEmojiSelected(emojis[index]),
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
