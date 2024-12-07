import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';
import 'package:telegrammy/features/profile/presentation/view_models/story_cubit/story_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/story_cubit/story_state.dart';
import 'package:story_view/story_view.dart';
import 'package:video_player/video_player.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:http/http.dart' as http;

class UserStoryView extends StatefulWidget {
  @override
  _UserStoryViewState createState() => _UserStoryViewState();
}

class _UserStoryViewState extends State<UserStoryView> {
  final StoryController storyController = StoryController();

  // Map to manage dynamic video instances
  Map<String, VideoPlayerController> videoControllers = {};

  @override
  void dispose() {
    // Dispose all video controllers and story controllers properly
    videoControllers.forEach((key, controller) => controller.dispose());
    storyController.dispose();
    super.dispose();
  }

  // Delete story logic
  void _deleteStory(String storyId) {
    print('Deleting story ID: $storyId');
    context.read<StoriesCubit>().deleteStory(storyId);
  }

  // Function to show viewers' list in a popup dialog
  void _showViewersDialog(Map<String, DateTime> viewers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Viewers', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Container(
            height: 300,
            child: ListView.builder(
              itemCount: viewers.keys.length,
              itemBuilder: (context, index) {
                String viewer = viewers.keys.elementAt(index);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(viewer),
                  ),
                  title: Text(viewer),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _formatExpirationDate(DateTime expirationDateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(expirationDateTime);
  }

  // Fetch image/video dynamically (pre-fetch for better performance and avoid failure)
 Future<StoryItem> _fetchMedia(String url, String content) async {
  try {
    if (url.contains('.jpg') || url.contains('.jpeg') || url.contains('.png')) {
      // Fetch only if the content is a valid image URL
      final response = await http.get(Uri.parse(url));
      print('response');
      if (response.statusCode == 200) {
        print('Successfully fetched image for story');
        return StoryItem.pageImage(
          url: url, // Pass the actual URL here, NOT MemoryImage
          controller: storyController,
          caption: Text(content),
        );
      }
    }

    return StoryItem.text(
      title: content,
      backgroundColor: Colors.grey,
    );
  } catch (e) {
    print("Error during story media fetch: $e");
    return StoryItem.text(
      title: content,
      backgroundColor: Colors.grey,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GeneralAppBar(
        titleBar: "My Status",
        key: const ValueKey('UserStoryAppBar'),
      ),
      backgroundColor: secondaryColor,
      body: BlocBuilder<StoriesCubit, StoryState>(
        builder: (context, state) {
          if (state is StoryLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is StoryError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          if (state is StoryLoaded) {
            if (state.storyResponse.data.isEmpty) {
              return Center(
                child: Text("No stories available",
                    style: textStyle17.copyWith(fontWeight: FontWeight.w500)),
              );
            }

            // Map stories dynamically to `StoryItem`
            return FutureBuilder<List<StoryItem>>(
              future: _loadStories(state.storyResponse.data),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error loading stories"));
                }

                return Stack(
                  key: const ValueKey('UserStoryStack'),
                  children: [
                    StoryView(
                      storyItems: snapshot.data ?? [],
                      controller: storyController,
                      onStoryShow: (storyItem, index) {
                        print("Currently viewing index: $index");
                      },
                      onComplete: () {
                        print("All stories have been viewed.");
                      },
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 30),
                        onPressed: () {
                          _deleteStory(state.storyResponse.data[0].id);
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Row(
                        children: [
                          Icon(Icons.remove_red_eye, color: Colors.white),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              final viewers = state.storyResponse.data[0].viewers;
                              _showViewersDialog(viewers ?? {});
                            },
                            child: Text(
                              '${state.storyResponse.data[0].viewersCount} Viewers',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 20,
                      child: Text(
                        'Expires at: ${_formatExpirationDate(state.storyResponse.data[0].expiresAt)}',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                );
              },
            );
          }

          return Center(
            child: Text("No stories available",
                style: textStyle17.copyWith(
                    fontWeight: FontWeight.w400, color: tileInfoHintColor)),
          );
        },
      ),
    );
  }

  // Dynamically load story items (handle videos/images/text dynamically)
  Future<List<StoryItem>> _loadStories(List<Story> stories) async {
    List<StoryItem> items = [];
    for (var story in stories) {
      if (story.media != null) {
        final fetchedStoryItem = await _fetchMedia(story.media!, story.content ?? '');
        items.add(fetchedStoryItem);
      } else {
        items.add(StoryItem.text(
          title: story.content ?? "No Content",
          backgroundColor: Colors.grey,
        ));
      }
    }
    return items;
  }
}
