import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../cores/styles/styles.dart';
import '../view_models/group_cubit.dart';

class ChangePictureButton extends StatelessWidget {
  const ChangePictureButton({super.key});

  Future<void> _showOptions(BuildContext context, GroupCubit cubit) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              key: const ValueKey('UpdateGroupPictureButton'),
              leading: Icon(Icons.photo_camera),
              title: Text('Update Group Picture'),
              onTap: () {
                Navigator.pop(context);
                cubit.updateGroupPicture();
              },
            ),
            ListTile(
              key: const ValueKey('DeleteGroupPictureButton'),
              leading: Icon(Icons.delete),
              title: Text('Delete Group Picture'),
              onTap: () {
                Navigator.pop(context);
                cubit.deleteGroupPicture();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupCubit = context.read<GroupCubit>();

    return TextButton(
        key: const ValueKey('ChangePictureButton'),
        onPressed: () => _showOptions(context, groupCubit),
        child: Text('Change Group Picture', style: textStyle17));
  }
}
