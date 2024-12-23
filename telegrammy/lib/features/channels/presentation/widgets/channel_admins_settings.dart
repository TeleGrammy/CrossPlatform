import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/features/channels/presentation/view_models/channel_cubit/channel_cubit.dart';
import 'package:telegrammy/features/groups/data/models/group.dart';
import '../../../../cores/routes/route_names.dart';
import '../../../profile/presentation/widgets/profile_settings/settings_box.dart';

class ChannelAdminSettings extends StatelessWidget {
  ChannelAdminSettings(
      {super.key,
      required this.channelId,
      required this.privacy,
      required this.contactsToAddFrom,
      required this.subscribersToMakeAdmins,
      required this.nonAdminSubscribers});
  final String channelId;
  final String privacy;
  final List<ContactData> contactsToAddFrom;
  final List<MemberData> subscribersToMakeAdmins;
  final List<MemberData> nonAdminSubscribers;

  final List<String> _privacyOptions = const ["public", "private"];

  @override
  Widget build(BuildContext context) {
    return SettingsBox(
      key: const ValueKey('ChannelAdminSettingsBox'),
      children: [
        ListTile(
          key: const ValueKey('ChannelPrivacyTile'),
          title: Text(privacy),
          subtitle: Text('Channel Privacy'),
          trailing: DropdownButton<String>(
            value: privacy,
            onChanged: (String? newValue) {
              context.read<ChannelCubit>().updateChannelPrivacy(newValue!);
            },
            items:
                _privacyOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        ListTile(
          key: const ValueKey('AddSubscribersTile'),
          title: Text('Add Subscribers to Channel'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () => {
            context.goNamed(RouteNames.addChannelSubscribers, extra: [
              channelId,
              contactsToAddFrom,
            ]),
          },
        ),
        ListTile(
          key: const ValueKey('RemoveSubscribersTile'),
          title: Text('Remove Subscribers from channel'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () => {
            context.goNamed(RouteNames.removeChannelSubscribers, extra: [
              channelId,
              nonAdminSubscribers,
            ]),
          },
        ),
        ListTile(
          key: const ValueKey('AddAdminsTile'),
          title: Text('Add admins to group'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () => {
            context.goNamed(RouteNames.addGroupAdmin, extra: [
              channelId,
              subscribersToMakeAdmins,
            ]),
          },
        ),
      ],
    );
  }
}
