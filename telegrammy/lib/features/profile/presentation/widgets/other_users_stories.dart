import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/features/profile/presentation/view_models/story_cubit/story_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/story_cubit/story_state.dart';

class ScrollableUserStoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OthersStoriesCubit(  ), // Trigger fetch on widget init
      child: BlocBuilder<OthersStoriesCubit, OthersStoryState>(
        builder: (context, state) {
          if (state is OthersStoryLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is OthersStoryLoaded) {
            final userStories = state.usersStoriesModel.userStories;

            return Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: userStories.length,
                itemBuilder: (context, index) {
                  final userStory = userStories[index];
                  return GestureDetector(
                    onTap: () {
                      print('Pressed on user ${userStory.id}');
                 context.goNamed(
  RouteNames.otherUserStoryPage,
  extra: {
    'userStories': userStory.stories,
    'userName': userStory.profile.username,
    'userAvatar': userStory.profile.picture,
  },
);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: StoryCircle(
                        picture: userStory.profile.picture,
                        storyCount: userStory.stories.length,
                        userName: userStory.profile.username ?? "User",
                      ),
                    ),
                  );
                },
              ),
            );
          }

          if (state is OthersStoryError) {
            return Center(child: Text("Error loading stories"));
          }

          return Center(child: Text("No data available"));
        },
      ),
    );
  }
}


// Story Circle Widget
class StoryCircle extends StatelessWidget {
  final String? picture; // URL or empty
  final int storyCount;
  final String userName;

  const StoryCircle({
    Key? key,
    required this.picture,
    required this.storyCount,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider avatar = picture!=null
        ? NetworkImage(picture!)
        : AssetImage('assets/images/logo.png');

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer circular border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: avatar,
              ),
            ),
            Positioned(
              bottom: 4,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.blue,
                child: Text(
                  storyCount.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          userName,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
