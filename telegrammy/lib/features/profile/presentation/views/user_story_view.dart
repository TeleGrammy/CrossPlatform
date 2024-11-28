// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Import the intl package
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:telegrammy/cores/widgets/app_bar.dart';
// import 'package:telegrammy/features/profile/presentation/view_models/story_cubit/story_cubit.dart';
// import 'package:telegrammy/features/profile/presentation/view_models/story_cubit/story_state.dart';
// import 'package:story_view/story_view.dart';
// import 'package:video_player/video_player.dart';
// import 'package:telegrammy/cores/styles/styles.dart';
// import 'package:telegrammy/cores/constants/app_colors.dart';

// class UserStoryView extends StatefulWidget {
//   @override
//   _UserStoryViewState createState() => _UserStoryViewState();
// }

// class _UserStoryViewState extends State<UserStoryView> {
//   final StoryController storyController = StoryController();

//   // Create a VideoPlayerController map to manage video instances
//   Map<String, VideoPlayerController> videoControllers = {};

//   @override
//   void dispose() {
//     // Dispose of all video controllers when the widget is disposed
//     videoControllers.forEach((key, controller) {
//       controller.dispose();
//     });
//     storyController.dispose();
//     super.dispose();
//   }

//   // Method to delete a story using the StoriesCubit
//   void _deleteStory(String storyId) {
//     print(storyId);
//     context.read<StoriesCubit>().deleteStory(storyId);
//   }

//   // Method to show the list of viewers in a dialog
//   void _showViewersDialog(Map<String, DateTime> viewers) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Viewers', style: TextStyle(fontWeight: FontWeight.bold)),
//           content: Container(
//             height: 300,
//             width: 300,
//             child: ListView.builder(
//               itemCount: viewers.keys.length,
//               itemBuilder: (context, index) {
//                 String viewer = viewers.keys.elementAt(index); // Get viewer name or ID
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundImage: NetworkImage(viewer), // Assuming viewer is URL or ID for avatar
//                   ),
//                   title: Text(viewer), // You may adjust based on your data structure
//                 );
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Method to format and show the expiration date
//  String _formatExpirationDate(DateTime expirationDateTime) {
//   return DateFormat('yyyy-MM-dd HH:mm:ss').format(expirationDateTime); // Format to desired string
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: GeneralAppBar("My Status"),
//       backgroundColor: secondaryColor,
//       body: BlocBuilder<StoriesCubit, StoryState>(
//         builder: (context, state) {
//           if (state is StoryLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is StoryError) {
//             return Center(child: Text("Error: ${state.message}"));
//           } else if (state is StoryLoaded) {
//             if (state.storyResponse.data.isEmpty) {
//               return Center(
//                   child: Text("No stories available", style: textStyle17.copyWith(fontWeight: FontWeight.w500)));
//             }

//             return Stack(
//               children: [
//                 StoryView(
//                   storyItems: state.storyResponse.data.map((story) {
//                     // Handle each story (image, video, or text)
//                     if (story.media != null) {
//                       // If it's an image
//                       if (story.media!.endsWith('.jpg') ||
//                           story.media!.endsWith('.jpeg') ||
//                           story.media!.endsWith('.png') ||
//                           story.media!.endsWith('.gif')) {
//                         return StoryItem.pageImage(
//                           url: story.media!,
//                           controller: storyController,
//                           caption: Text(story.content),
//                         );
//                       }
//                       // If it's a video
//                       // if (story.media!.endsWith('.mp4') || story.media!.endsWith('.mov')) {
//                       //   return StoryItem.pageVideo(
//                       //     url: story.media!,
//                       //     controller: storyController,
//                       //     caption: Text(story.content ?? "No Content"),
//                       //   );
//                       // }
//                     }
//                     // Default: Text story
//                     return StoryItem.text(
//                       title: story.content,
//                       backgroundColor: const Color.fromARGB(255, 224, 129, 129),
//                     );
//                   }).toList(),
//                   controller: storyController,
//                   onStoryShow: (storyItem, index) {
//                     print("Showing story at index: $index, Story: $storyItem");
//                   },
//                   onComplete: () {
//                     print("Completed viewing all stories.");
//                   },
//                 ),
//                 // Add the delete button outside the StoryView but on top of the stories
//                 Positioned(
//                   top: 10,
//                   right: 10,
//                   child: IconButton(
//                     icon: Icon(
//                       Icons.delete,
//                       color: Colors.red,
//                       size: 30,
//                     ),
//                     onPressed: () {
//                       // Delete the story using its ID
//                       _deleteStory(state.storyResponse.data[0].id); // Adjust the index if needed
//                     },
//                   ),
//                 ),
//                 // Add the eye icon and viewers count at the bottom
//                 Positioned(
//                   bottom: 20,
//                   left: 20,
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.remove_red_eye,
//                         color: Colors.white,
//                       ),
//                       SizedBox(width: 5),
//                       GestureDetector(
//                         onTap: () {
//                           // Get the viewers from the current story and show the dialog
//                           Map<String, DateTime>? viewers = state.storyResponse.data[0].viewers; // Assuming each story has a Map<String, DateTime> of viewers
//                           _showViewersDialog(viewers!);
//                         },
//                         child: Text(
//                           '${state.storyResponse.data[0].viewersCount} Viewers', // Display viewers count
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Add the expiration time at the bottom of the screen (or wherever you prefer)
//                 Positioned(
//                   bottom: 50,
//                   left: 20,
//                   child: Text(
//                     'Expires at: ${_formatExpirationDate(state.storyResponse.data[0].expiresAt )}',
//                     style: TextStyle(color: Colors.white, fontSize: 14),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return Center(child: Text("No stories available", style: textStyle17.copyWith(fontWeight: FontWeight.w400, color: tileInfoHintColor)));
//           }
//         },
//       ),
//     );
//   }
// }
