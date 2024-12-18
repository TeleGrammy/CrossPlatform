import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../profile/presentation/widgets/profile_settings/settings_box.dart';
import '../view_models/group_cubit.dart';

class GroupAdminSettings extends StatelessWidget {
  const GroupAdminSettings(
      {super.key, required this.groupPrivacy, required this.groupSizeLimit});
  final String groupPrivacy;
  final int groupSizeLimit;

  final List<String> _privacyOptions = const ["Public", "Private"];
  final List<String> _sizeLimits = const ['200', '500', '1000', '200000'];

  @override
  Widget build(BuildContext context) {
    return SettingsBox(
      key: const ValueKey('GroupAdminSettingsBox'),
      children: [
        ListTile(
          key: const ValueKey('GroupPrivacyTile'),
          title: Text(groupPrivacy),
          subtitle: Text('Group Privacy'),
          trailing: DropdownButton<String>(
            value: groupPrivacy,
            onChanged: (String? newValue) {
              context.read<GroupCubit>().updateGroupPrivacy(newValue!);
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
          key: const ValueKey('GroupSizeLimitTile'),
          title: Text(groupSizeLimit.toString()),
          subtitle: Text('Group Size Limit'),
          trailing: DropdownButton<String>(
            value: groupSizeLimit.toString(),
            onChanged: (String? newValue) {
              context
                  .read<GroupCubit>()
                  .updateGroupSizeLimit(int.parse(newValue!));
            },
            items: _sizeLimits.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        ListTile(
          key: const ValueKey('AddMembersTile'),
          title: Text('Add members to group'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () => {
            //TODO: navigate to add members page
          },
        ),
        ListTile(
          key: const ValueKey('AddAdminsTile'),
          title: Text('Add admins to group'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () => {
            //TODO: navigate to add admins page
          },
        ),
      ],
    );
  }
}
