import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/features/channels/presentation/view_models/channel_cubit/channel_cubit.dart';
import 'package:telegrammy/features/channels/presentation/widgets/change_picture_button.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/picture_circle.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';

class EditChannelSettingsView extends StatefulWidget {
  const EditChannelSettingsView(
      {super.key,
      required this.channelId,
      required this.chat,
      required this.lastSeen,
      required this.userId});
  final String channelId;
  final Chat chat;
  final String lastSeen;
  final String userId;

  @override
  State<EditChannelSettingsView> createState() =>
      _EditChannelSettingsViewState();
}

class _EditChannelSettingsViewState extends State<EditChannelSettingsView> {
  final _formKey = GlobalKey<FormState>();
  late String privacy;

  final TextEditingController channelNameController = TextEditingController();
  final TextEditingController channelDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    channelNameController.dispose();
    channelDescriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<ChannelCubit>().getChannelInfo(widget.channelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ProfileSettingsAppBar(
          key: const ValueKey('EditChannelSettingsAppBar'),
          title: 'Edit Channel Info',
          backButtonOnPressed: () {
            context.goNamed(RouteNames.channelSettings,
                extra: [widget.chat, widget.lastSeen, widget.userId]);
          },
          actions: [
            TextButton(
                key: const ValueKey('SaveChangesButton'),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await context.read<ChannelCubit>().updateChannelInfo(
                        widget.chat,
                        channelNameController.text,
                        channelDescriptionController.text,
                        privacy);
                    Future.delayed(Duration(seconds: 1));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Channel info updated successfully!')),
                    );
                    widget.chat.name = channelNameController.text;

                    context.goNamed(RouteNames.channelSettings,
                        extra: [widget.chat, widget.lastSeen, widget.userId]);
                  }
                },
                child: Text(
                  'SAVE CHANGES',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
        body:
            BlocBuilder<ChannelCubit, ChannelState>(builder: (context, state) {
          if (state is ChannelLoading || state is ChannelInitial) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ChannelFailure) {
            return Center(child: Text(state.errorMessage));
          }

          if (state is ChannelLoadedSuccess) {
            privacy = state.channelData.privacy ?? "public";
            channelNameController.text = state.channelData.name;
            channelDescriptionController.text =
                state.channelData.description ?? '';

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20),
                      PictureCircle(
                          key: const ValueKey('ChannelPictureCircle'),
                          imageUrl: state.channelData.image ?? 'default.jpg'),
                      ChangePictureButton(
                        key: const ValueKey('ChangeChannelPictureButton'),
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          GroupSettingsTextFormField(
                            valueKey: const ValueKey('ChannelNameTextField'),
                            controller: channelNameController,
                            labelText: 'Channel Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          GroupSettingsTextFormField(
                            valueKey:
                                const ValueKey('ChannelDescriptionTextField'),
                            controller: channelDescriptionController,
                            labelText: 'Channel Description',
                            validator: (value) => null,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        }));
  }
}

class GroupSettingsTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final ValueKey<String>? valueKey;
  const GroupSettingsTextFormField(
      {super.key,
      this.controller,
      this.keyboardType = TextInputType.text,
      this.labelText = "",
      this.validator,
      this.valueKey});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: valueKey,
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[400]),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // White underline when enabled
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white), // White underline when focused
        ),
      ),
      validator: validator,
    );
  }
}
