import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:telegrammy/cores/models/channel_model.dart';
import 'package:telegrammy/cores/models/post_model.dart';
import 'package:telegrammy/features/channels/data/repos/channel_repo_implementation.dart';

part 'channel_state.dart';

class ChannelCubit extends Cubit<ChannelState> {
  ChannelCubit() : super(ChannelInitial());
  ChannelsRepoImplementaion repoImplementaion = ChannelsRepoImplementaion();

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

  Future<void> createChannel(Channel newChannel) async {
    emit(ChannelCreateLoading());
    final result = await repoImplementaion.createChannel(newChannel);
    result.fold((failre) {
      print('Cubit:error signing up user ${failre.errorMessage}');
      emit(ChannelCreateFailure(errorMessage: failre.errorMessage));
    }, (data) {
      print('Cubit:user signed up successfully');
      emit(ChannelCreateSuccess());
    });
  }
}
