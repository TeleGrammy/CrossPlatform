import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart' as story_view;
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';
import 'package:http/http.dart' as http;
import 'package:telegrammy/features/profile/presentation/view_models/story_cubit/story_cubit.dart'; // Import HTTP package
class OthersStoryView extends StatefulWidget {
  final List<Story> userStories;
  final String userName; // User's name
  final String userAvatar; // URL for user's avatar image

  const OthersStoryView({
    Key? key,
    required this.userStories,
    required this.userName,
    required this.userAvatar,
  }) : super(key: key);

  @override
  _OthersStoryViewState createState() => _OthersStoryViewState();
}

class _OthersStoryViewState extends State<OthersStoryView> {
  final StoryController storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          // Custom Header with Back Arrow, Avatar, and User's Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 24),
                  onPressed: () {
                    context.goNamed(RouteNames.storiesPage);
                  },
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.userAvatar),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<story_view.StoryItem>>(
              future: _mapStoriesToStoryItems(widget.userStories),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error loading stories"),
                  );
                }

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return story_view.StoryView(
                    storyItems: snapshot.data!,
                    controller: storyController,
                    onStoryShow: (storyItem, index) {
                      final storyCubit = context.read<OthersStoriesCubit>();
                      final storyId = widget.userStories[index].id; // Get the ID for the story
                      storyCubit.markStoryAsViewed(storyId); // Trigger the Cubit function
                    },
                    onComplete: () {
                      print("All stories viewed.");
                    },
                  );
                }

                return const Center(
                  child: Text("No stories available"),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}


  /// Map user stories to story items
  
Future<List<story_view.StoryItem>> _mapStoriesToStoryItems(List<Story> userStories) async {
  List<story_view.StoryItem> items = [];

  for (final story in userStories) {
    try {
      if (story.media != null) {
        // Check if the URL contains image formats like jpg, jpeg, png
        if (story.media!.contains('.jpg') ||
            story.media!.contains('.jpeg') ||
            story.media!.contains('.png')) {
          final response = await http.get(Uri.parse(story.media!));

          // If the HTTP response is successful, use the story's image
          if (response.statusCode == 200) {
            print('Successfully fetched image for story: ${story.media!}');
            items.add(story_view.StoryItem.pageImage(
              url: story.media!,
              controller: storyController,
              caption: Text(
                story.content ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ));
            continue; // Skip the fallback if image fetch succeeds
          }
        }
      }

      // Handle fallback logic for local media or default text display
      items.add(story_view.StoryItem.text(
        title: story.content ?? '',
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      // Log any errors during network requests and fallback gracefully
      print("Error during story media fetch: $e");
      items.add(story_view.StoryItem.text(
        title: story.content ?? '',
        backgroundColor: Colors.grey,
      ));
    }
  }

  return items;
}}
