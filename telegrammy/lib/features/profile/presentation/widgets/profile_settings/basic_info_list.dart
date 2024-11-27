import 'package:flutter/material.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/settings_box.dart';

class BasicInfoList extends StatelessWidget {
  final user;
  const BasicInfoList({required this.user});
  @override
  Widget build(BuildContext context) {
    return SettingsBox(
      children: [
        ListTile(
          key: const ValueKey('UsernameTile'),
          title: Text(user.username != null ? '@${user.username}' : ""),
          subtitle: Text('Username'),
        ),
        ListTile(
          key: const ValueKey('EmailTile'),
          title: Text(user.email),
          subtitle: Text('email'),
        ),
        ListTile(
          key: const ValueKey('PhoneNumberTile'),
          title: Text(user.phoneNumber ?? ""),
          subtitle: Text('phone number'),
        ),
        ListTile(
          key: const ValueKey('BioTile'),
          title: Text(user.bio ?? ""),
          subtitle: Text('Bio'),
        ),
      ],
    );
  }
}
