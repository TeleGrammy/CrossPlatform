import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/models/post_model.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/features/channels/presentation/view_models/channel_cubit/channel_cubit.dart';
import 'package:telegrammy/features/channels/presentation/widgets/channel_bottom_bar.dart';
import 'package:telegrammy/features/channels/presentation/widgets/posts_body.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_appbar.dart';

String userId = '1';

class ChannelView extends StatefulWidget {
  final String ChannelId;
  ChannelView({super.key, this.ChannelId = 'blah'});

  @override
  State<ChannelView> createState() => _ChannelViewState();
}

class _ChannelViewState extends State<ChannelView> {
  ScrollController scrollController = ScrollController();

  Post? _selectedPost; 
  Post? _repliedPost;
  Post? _editedPost;
  bool isPinned=false;
  void _onPostTap(Post Post) {
    setState(() {
      _selectedPost = Post;
    });
  }

  void _onPostSwipe(Post post) {
    setState(() {
      _repliedPost = post;
    });
  }

  void onPostSend(Post post) {
    if (post.attachments != null || post.content.trim().isNotEmpty) {
      context.read<ChannelCubit>().addPost(post, null);
    }
  }

  void onPostEdit(Post post, String newContent) {
    if (post.attachments != null || post.content.trim().isNotEmpty) {
      context.read<ChannelCubit>().addPost(post, null);
    }
  }

  void _clearReply() {
    setState(() {
      _repliedPost = null;
      _editedPost = null;
    });
  }

  void _onClickEdit() {
    setState(() {
      _editedPost = _selectedPost;
      _repliedPost = _selectedPost!.repliedTo;
      _selectedPost = null;
    });
  }

  void _onClickDelete() {
    setState(() {});
  }
void onClickPin() {
    setState(() {});
    print('post pinned');
  }
  void onClickUnpin() {
      print('post unpinned');
  }

  @override
  void initState() {
    super.initState();
    context.read<ChannelCubit>().getChannelPosts(widget.ChannelId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelCubit, ChannelState>(
      builder: (context, state) {
        print(state);
        if (state is getChannelPostsSuccess) {
          return Scaffold(
              appBar:
                  (_selectedPost != null && _selectedPost!.authorId == userId)
                      ? SelectedMessageAppbar(
                          onMessageUnTap: () {
                            setState(() {
                              _selectedPost = null;
                            });
                          },
                          onClickEdit: _onClickEdit,
                          onClickDelete:_onClickDelete,
                          onClickPin:onClickPin,
                          onClickUnpin:onClickUnpin,

                     isPinned: isPinned,

                        )
                      : AppBar(
                          leading: Icon(Icons.arrow_back),
                          title: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.channel.name,
                                style: textStyle20.copyWith(
                                    fontWeight: FontWeight.w900),
                              ),
                              IconButton(
                                onPressed: () {
                                  //show pop up for searching & setting (for admins) | mute (for subcribers)
                                },
                                icon: Icon(Icons.more_vert),
                              ),
                            ],
                          ),
                        ),
              body: Column(
                children: [
                    
                  Expanded(
                    child: PostsBody(
                      posts: state.channel.posts,
                      selectedPost: _selectedPost,
                      onPostSwipe: _onPostSwipe,
                      onPostTap: _onPostTap,
                      scrollController: scrollController,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ChannelBottomBar(
                              onSend: onPostSend,
                              onEdit: onPostEdit,
                              isAdmin: state.isAdmin,
                              isJoined: state.isJoined)),
                    ],
                  ),
                ],
              ));
        }
        if (state is getChannelPostsFailure) {
          return (Text('Error occured:${state.errorMessage}'));
        }
        return Scaffold();
      },
    );
  }
}
