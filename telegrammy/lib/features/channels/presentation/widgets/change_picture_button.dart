import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/features/channels/presentation/view_models/channel_cubit/channel_cubit.dart';
import '../../../../../cores/styles/styles.dart';

class ChangePictureButton extends StatelessWidget {
  const ChangePictureButton({super.key});

  Future<void> _showOptions(BuildContext context, ChannelCubit cubit) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              key: const ValueKey('UpdateChannelPictureButton'),
              leading: Icon(Icons.photo_camera),
              title: Text('Update channel Picture'),
              onTap: () {
                Navigator.pop(context);
                cubit.updateChannelPicture();
              },
            ),
            ListTile(
              key: const ValueKey('DeleteChannelPictureButton'),
              leading: Icon(Icons.delete),
              title: Text('Delete Channel Picture'),
              onTap: () {
                Navigator.pop(context);
                cubit.deleteChannelPicture();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final channelCubit = context.read<ChannelCubit>();

    return TextButton(
        key: const ValueKey('ChangePictureButton'),
        onPressed: () => _showOptions(context, channelCubit),
        child: Text('Change Channel Picture', style: textStyle17));
  }
}
