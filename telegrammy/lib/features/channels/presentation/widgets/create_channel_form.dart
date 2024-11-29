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
    required this.adminController,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController channelNameController;
  final TextEditingController channelDescriptionController;
  final TextEditingController adminController;
  final Function(Channel) onSubmit;

  @override
  State<CreateChannelForm> createState() => _CreateChannelFormState();
}

class _CreateChannelFormState extends State<CreateChannelForm> {
  bool isChannelPublic = true;
  List<String> admins = []; //should add this user id

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

          //Privacy Setting Radio Buttons
          Row(
            children: [
              Text(
                'Privacy Setting:',
                style: textStyle16,
              ),
              Radio<bool>(
                key: Key('publicChannelRadio'),
                value: true,
                groupValue: isChannelPublic,
                onChanged: (value) {
                  setState(() {
                    isChannelPublic = value ?? true;
                    print(isChannelPublic);
                  });
                },
              ),
              Text(
                'Public',
                style: textStyle16,
              ),
              Radio<bool>(
                key: Key('privateChannelRadio'),
                value: false,
                groupValue: isChannelPublic,
                onChanged: (value) {
                  setState(() {
                    isChannelPublic = value ?? false;
                    print(isChannelPublic);
                  });
                },
              ),
              Text(
                'Private',
                style: textStyle16,
              ),
            ],
          ),
          SizedBox(height: 16),

          //Text Field to Add Admins
          Column(
            children: [
              CustomTextField(
                inputFieldKey: Key('adminField'),
                controller: widget.adminController,
                hintText: 'Add Admin (Username)',
                obsecureText: false,
                validator: (value) => null,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (widget.adminController.text.isNotEmpty &&
                        !admins.contains(widget.adminController.text))
                      setState(() {
                        admins.add(widget.adminController.text);
                      });
                  },
                  child: Icon(Icons.add))
            ],
          ),
          SizedBox(height: 8),

          // Displaying added admins as Chips
          Wrap(
            key: Key('adminAddedWrapper'),
            spacing: 8.0,
            children: admins.map((admin) {
              return Chip(
                key: Key('addedAdmin$admin'),
                label: Text(admin),
                deleteIcon: Icon(Icons.delete),
                onDeleted: () {
                  setState(() {
                    admins.remove(admin);
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 20),

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
            },
            child: RoundedButton(
              onPressed: () {
                if (widget.formKey.currentState?.validate() ?? false) {
                  var newChannel = Channel(
                    name: widget.channelNameController.text,
                    adminsId: admins,
                    description: widget.channelDescriptionController.text,
                    isChannelPublic: isChannelPublic,
                    createdAt: DateTime.now(),
                    posts: [],
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
