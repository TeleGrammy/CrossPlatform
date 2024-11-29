import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:telegrammy/cores/models/channel_model.dart';
import 'package:telegrammy/cores/models/post_model.dart';

part 'channel_state.dart';

class ChannelCubit extends Cubit<ChannelState> {
  ChannelCubit() : super(ChannelInitial());

  List<Post> posts = [
    Post(
        channelId: '',
        content: 'post1',
        authorId: '2',
        createdAt: null,
        threadsAllowed: true),
    Post(
        channelId: '',
        content: 'post2',
        authorId: '2',
        createdAt: null,
        threadsAllowed: true),
    Post(
        channelId: '',
        content: 'post3',
        authorId: '1',
        createdAt: null,
        threadsAllowed: true),
  ];

  Future<void> getChannelPosts(String channelName) async {
    Channel channel = Channel(
        isChannelPublic: true,
        name: '<<my Channel>>',
        description: '',
        adminsId: ['2'],
        createdAt: DateTime.now(),
        posts: posts);
    emit(getChannelPostsSuccess(
        isAdmin: true, isJoined: false, channel: channel));
  }

  Future<void> addPost(Post post, String? ChannelId) async {
    posts.add(post);

    Channel channel = Channel(
        isChannelPublic: true,
        name: '<<my Channel>>',
        description: '',
        adminsId: ['1', '2'],
        createdAt: DateTime.now(),
        posts: posts);

    emit(getChannelPostsSuccess(
        isAdmin: true, isJoined: false, channel: channel));
  }
}
