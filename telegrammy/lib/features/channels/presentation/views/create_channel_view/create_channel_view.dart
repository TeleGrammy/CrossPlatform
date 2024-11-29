import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/models/channel_model.dart';
import 'package:telegrammy/features/channels/presentation/view_models/channel_cubit/channel_cubit.dart';
import 'package:telegrammy/features/channels/presentation/widgets/create_channel_form.dart';

class CreateChannelView extends StatelessWidget {
  CreateChannelView({super.key});

  final formKey = GlobalKey<FormState>();
  final channelNameController = TextEditingController();
  final channelDescriptionController = TextEditingController();
  final adminController = TextEditingController();
  
  final Function(Channel) onSubmit = (Channel newChannel) {
    //call the cubit function to create channel here
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Channel'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                BlocProvider(
                  create: (context) => ChannelCubit(),
                  child: CreateChannelForm(
                      formKey: formKey,
                      channelNameController: channelNameController,
                      channelDescriptionController:
                          channelDescriptionController,
                      adminController: adminController,
                      onSubmit: onSubmit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
