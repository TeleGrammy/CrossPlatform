import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/services/channel_socket.dart';
import 'package:telegrammy/features/groups/data/models/group.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';
import '../../../../cores/routes/route_names.dart';
import '../../../../cores/services/service_locator.dart';

class AddChannelSubscribersView extends StatefulWidget {
  AddChannelSubscribersView(
      {required this.channelId, required this.contactsToAddFrom});
  final String channelId;
  final List<ContactData> contactsToAddFrom;
  @override
  _AddChannelSubscribersViewState createState() =>
      _AddChannelSubscribersViewState();
}

class _AddChannelSubscribersViewState extends State<AddChannelSubscribersView> {
  @override
  void initState() {
    super.initState();
    getit.get<ChannelSocketService>().connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileSettingsAppBar(
        backButtonOnPressed: () => context.goNamed(RouteNames.channelSettings),
        title: 'Add subscribers to channel',
        key: const ValueKey('AddChannelSubscribersAppBar'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            key: const ValueKey('SubscribersToAdd'),
            child: widget.contactsToAddFrom.isNotEmpty
                ? ListView.builder(
                    itemCount: widget.contactsToAddFrom.length,
                    itemBuilder: (context, index) {
                      final contact = widget.contactsToAddFrom[index];
                      final isBlocked = contact.blockDetails == "not_blocked";

                      return ListTile(
                        key: ValueKey('userToAdd_$index'),
                        tileColor: primaryColor,
                        leading: CircleAvatar(
                          backgroundImage: contact.picture != null
                              ? NetworkImage(contact.picture!)
                              : null,
                          radius: 20,
                        ),
                        title: Text(
                          key: ValueKey('username_$index'),
                          contact.username,
                          style: TextStyle(color: tileInfoHintColor),
                        ),
                        trailing: IconButton(
                          key: ValueKey('AddSubscriberButton_$index'),
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            getit.get<ChannelSocketService>().addSubscribers({
                              "channelId": widget.channelId,
                              "subscriberIds": [contact.userId]
                            });
                            setState(() {
                              widget.contactsToAddFrom.remove(contact);
                            });
                          },
                        ),
                      );
                    },
                  )
                : Center(
                    key: const ValueKey('NoContactsToAddText'),
                    child: Text(
                      'No contacts available to add.',
                      style: TextStyle(color: tileInfoHintColor),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
