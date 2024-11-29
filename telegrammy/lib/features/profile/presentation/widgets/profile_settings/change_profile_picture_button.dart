import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_cubit.dart';
import '../../../../../cores/styles/styles.dart';

class ChangeProfilePictureButton extends StatelessWidget {
  const ChangeProfilePictureButton({super.key});

  Future<void> _showOptions(
      BuildContext context, ProfileSettingsCubit cubit) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Update Profile Picture'),
              onTap: () {
                Navigator.pop(context);
                cubit.updateProfilePicture();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Profile Picture'),
              onTap: () {
                Navigator.pop(context);
                cubit.deleteProfilePicture();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileSettingsCubit>();

    return TextButton(
        key: const ValueKey('ChangeProfilePictureButton'),
        onPressed: () => _showOptions(context, profileCubit),
        child: Text('Change Profile Picture', style: textStyle17));
  }
}
