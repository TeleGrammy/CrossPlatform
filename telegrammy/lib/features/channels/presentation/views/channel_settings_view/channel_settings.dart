import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/services/channel_socket.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/widgets/rounded_button.dart';
import 'package:telegrammy/features/channels/presentation/view_models/channel_cubit/channel_cubit.dart';
import 'package:telegrammy/features/channels/presentation/widgets/channel_admins_settings.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/settings_box.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/picture_circle.dart';
import '../../../../../cores/styles/styles.dart';

class ChannelSettingsView extends StatefulWidget {
  ChannelSettingsView(
      {super.key,
      required this.chat,
      required this.lastSeen,
      required this.userId}) {
    channelId = chat.channelId!;
  }
  final ChatView chat;
  final String lastSeen;
  late String channelId;
  final String userId;

  @override
  State<ChannelSettingsView> createState() => _ChannelSettingsViewState();
}

class _ChannelSettingsViewState extends State<ChannelSettingsView> {
  bool isAdmin = true; //TODO: use this to enable/disable admin functions

  @override
  void initState() {
    super.initState();
    context.read<ChannelCubit>().getChannelInfo(widget.channelId);
    getit.get<ChannelSocketService>().connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: const ValueKey('channelSettingsAppBar'),
        leading: IconButton(
          onPressed: () {
            context.goNamed(
              RouteNames.chatWrapper,
              extra: [widget.chat, widget.lastSeen],
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Channel Settings'),
        backgroundColor: primaryColor,
        actions: [
          if (isAdmin)
            IconButton(
              key: const ValueKey('EditChannelInfoButton'),
              icon: Icon(Icons.edit),
              color: Colors.white,
              onPressed: () => context.pushNamed(RouteNames.editChannelSettings,
                  extra: [
                    widget.channelId,
                    widget.chat,
                    widget.lastSeen,
                    widget.userId
                  ]),
            ),
        ],
      ),
      body: BlocBuilder<ChannelCubit, ChannelState>(
        builder: (context, state) {
          if (state is ChannelLoading || state is ChannelInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ChannelFailure) {
            return Center(child: Text(state.errorMessage));
          } else if (state is ChannelLoadedSuccess) {
            return SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20),
                        PictureCircle(
                            key: const ValueKey('ChannelPictureCircle'),
                            imageUrl: state.channelData.image ?? 'default.jpg'),
                        SizedBox(height: 20),
                        Text(
                          key: const ValueKey('ChannelName'),
                          state.channelData.name,
                          style: textStyle30,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        SettingsBox(
                          key: const ValueKey('ChannelDescription'),
                          children: [
                            ListTile(
                              key: const ValueKey('ChannelDescriptionTile'),
                              title: Text(state.channelData.description ?? '-'),
                              subtitle: Text('Description'),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        SettingsBox(
                          children: [
                            ListTile(
                                key: const ValueKey('ViewSubscribesTile'),
                                title: Text('View channel subscribes'),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  context.goNamed(
                                      RouteNames.viewChannelSubscribers,
                                      extra: [
                                        widget.channelId,
                                        state.subscribers
                                      ]);
                                }),
                          ],
                        ),
                        SizedBox(height: 20),
                        (!isAdmin)
                            ? SizedBox.shrink()
                            : ChannelAdminSettings(
                                channelId: widget.channelId,
                                privacy: state.channelData.privacy,
                                contactsToAddFrom: [],
                                subscribersToMakeAdmins: [],
                                nonAdminSubscribers: [],
                                // contactsToAddFrom:
                                //     state.contactsExcludingsubscribers!,
                                // subscribersToMakeAdmins:
                                //     state.nonAdminsubscribers!,
                                // nonAdminSubscribers: state.nonAdminsubscribers!,
                              ),
                        SizedBox(height: 20),
                        RoundedButton(
                          key: const ValueKey('LeaveChannelButton'),
                          onPressed: () {
                            getit
                                .get<ChannelSocketService>()
                                .removeParticipant({
                              "channelId": widget.channelId,
                              "subscriberId": widget.userId,
                            });
                            context.goNamed(RouteNames.chats);
                          },
                          buttonTitle: 'Leave Channel',
                          buttonKey: const ValueKey('LeaveChannelButton'),
                        ),
                        (isAdmin)
                            ? RoundedButton(
                                key: const ValueKey('DeleteChannelButton'),
                                onPressed: () {
                                  getit
                                      .get<ChannelSocketService>()
                                      .removeChannel(
                                          {"channelId": widget.channelId});
                                  context.goNamed(RouteNames.chats);
                                },
                                buttonTitle: 'Delete Channel',
                                buttonKey:
                                    const ValueKey('DeleteChannelButton'),
                                backgroundColor: Colors.red[900]!,
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  )),
            );
          }
          return Center(child: Text('-'));
        },
      ),
    );
  }
}
