import 'package:flutter/material.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/settings_box.dart';

class BasicInfoList extends StatelessWidget {
  final profileInfo;
  const BasicInfoList({required this.profileInfo});
  @override
  Widget build(BuildContext context) {
    return SettingsBox(
      children: [
        ListTile(
          key: const ValueKey('UsernameTile'),
          title: Text(
              profileInfo.username != null ? '@${profileInfo.username}' : ""),
          subtitle: Text('Username'),
        ),
        ListTile(
          key: const ValueKey('EmailTile'),
          title: Text(profileInfo.email),
          subtitle: Text('email'),
        ),
        ListTile(
          key: const ValueKey('PhoneNumberTile'),
          title: Text(profileInfo.phoneNumber ?? ""),
          subtitle: Text('phone number'),
        ),
        ListTile(
          key: const ValueKey('BioTile'),
          title: Text(profileInfo.bio ?? ""),
          subtitle: Text('Bio'),
        ),
      ],
    );
  }
}
