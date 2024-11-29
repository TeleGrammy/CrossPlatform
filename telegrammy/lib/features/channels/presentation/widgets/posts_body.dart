import 'package:flutter/material.dart';
import 'package:telegrammy/cores/models/post_model.dart';
import 'package:telegrammy/features/channels/presentation/widgets/add_comment_button.dart';

String userId = '1';

class PostsBody extends StatelessWidget {
  final List<Post> posts;
  final ScrollController scrollController;
  final Post? selectedPost;
  final Function(Post post) onPostSwipe;
  final Function(Post post) onPostTap;

  const PostsBody(
      {super.key,
      required this.posts,
      required this.selectedPost,
      required this.onPostSwipe,
      required this.onPostTap,
      required this.scrollController});

  void _scrollToPost(Post post) {
    final index = posts.indexOf(post);
    if (index != -1) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent -
            index * 72.0, // Adjust height
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: posts.length,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        final post = posts[index];
        final isSelected = post == selectedPost;
        final isSentByUser = post.authorId == userId;

        return GestureDetector(
          onHorizontalDragEnd: (details) {
            // Swipe right detected
            onPostSwipe(post);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected
                  ? const Color.fromARGB(255, 179, 223, 174)
                  : const Color.fromARGB(0, 255, 255, 255),
            ),
            child: AnimatedPadding(
              duration: Duration(milliseconds: 300), // Animation duration
              curve: Curves.easeInOut, // Animation curve
              padding: isSelected
                  ? (isSentByUser
                      ? EdgeInsets.only(right: 50, top: 4, bottom: 4)
                      : EdgeInsets.only(left: 50, top: 4, bottom: 4))
                  : const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: isSentByUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => onPostTap(post),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: (isSentByUser
                            ? Colors.blue[100]
                            : Colors.grey[200]),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft:
                              isSentByUser ? Radius.circular(12) : Radius.zero,
                          bottomRight:
                              isSentByUser ? Radius.zero : Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (post.repliedTo != null)
                            GestureDetector(
                              onTap: () => _scrollToPost(post.repliedTo!),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                margin: EdgeInsets.only(bottom: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  post.repliedTo!.content,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          Text(
                            post.content,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Sent at ${post.createdAt.toString()}',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 12.0,
                            ),
                          ),
                          if (post.threadsAllowed)
                            Column(
                              children: [
                                Divider(),
                                AddCommentButton(),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
