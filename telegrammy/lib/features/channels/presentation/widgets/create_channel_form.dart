import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/models/channel_model.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/widgets/custom_text_field.dart';
import 'package:telegrammy/cores/widgets/rounded_button.dart';
import 'package:telegrammy/features/channels/presentation/view_models/channel_cubit/channel_cubit.dart';

class CreateChannelForm extends StatefulWidget {
  const CreateChannelForm({
    super.key,
    required this.formKey,
    required this.channelNameController,
    required this.channelDescriptionController,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController channelNameController;
  final TextEditingController channelDescriptionController;
  final Function(Channel) onSubmit;

  @override
  State<CreateChannelForm> createState() => _CreateChannelFormState();
}

class _CreateChannelFormState extends State<CreateChannelForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Text Field for Channel Name
          CustomTextField(
            inputFieldKey: Key('channelNameField'),
            controller: widget.channelNameController,
            hintText: 'Channel Name',
            obsecureText: false,
            validator: (value) =>
                value!.isEmpty ? 'Channel Name is required' : null,
          ),
          SizedBox(height: 16),

          //Text Field for Channel Description
          CustomTextField(
            inputFieldKey: Key('channelDescriptionField'),
            controller: widget.channelDescriptionController,
            hintText: 'Channel Description',
            obsecureText: false,
            validator: (value) =>
                value!.isEmpty ? 'Channel Description is required' : null,
          ),
          SizedBox(height: 16),

          //errors message box
          BlocBuilder<ChannelCubit, ChannelState>(
            builder: (context, state) {
              if (state is ChannelCreateFailure) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: errorColor, fontSize: 16),
                  ),
                );
              }
              return const SizedBox.shrink(); // No error, return empty widget
            },
          ),

          // Custom Submit Button
          BlocListener<ChannelCubit, ChannelState>(
            listener: (context, state) {
              //if success navigate to the channel screen
              //if loading show spinner
              if (state is ChannelCreateSuccess) {
                print(
                    'channel created successfully-------------------------->');
              }
            },
            child: RoundedButton(
              onPressed: () {
                if (widget.formKey.currentState?.validate() ?? false) {
                  var newChannel = Channel(
                    name: widget.channelNameController.text,
                    description: widget.channelDescriptionController.text,
                    createdAt: DateTime.now(),
                    posts: [],
                    isChannelPublic: true,
                  );
                  widget.onSubmit(newChannel);
                }
              },
              buttonKey: Key('createChannel'),
              buttonTitle: 'Create Channel',
            ),
          ),
        ],
      ),
    );
  }
}
