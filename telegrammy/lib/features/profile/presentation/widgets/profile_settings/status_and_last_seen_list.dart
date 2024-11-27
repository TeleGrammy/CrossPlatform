import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_cubit.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/settings_box.dart';

class StatusAndLastSeenList extends StatelessWidget {
  const StatusAndLastSeenList({super.key, this.status, this.lastSeen});
  final String? status;
  final DateTime? lastSeen;

  final List<String> _statusOptions = const [
    "Online",
    "Busy",
    "Away",
    "Offline",
  ];
  @override
  Widget build(BuildContext context) {
    return SettingsBox(
      children: [
        ListTile(
          key: const ValueKey('StatusTile'),
          title: Text(status ?? '-'),
          subtitle: Text('Status'),
          trailing: DropdownButton<String>(
            value: status ?? _statusOptions.first,
            onChanged: (String? newValue) {
              context.read<ProfileSettingsCubit>().updateUserStatus(newValue!);
            },
            items: _statusOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        ListTile(
          key: const ValueKey('LastSeenTile'),
          title: Text(lastSeen != null ? lastSeen.toString() : '-'),
          subtitle: Text('Last Seen'),
        ),
      ],
    );
  }
}
