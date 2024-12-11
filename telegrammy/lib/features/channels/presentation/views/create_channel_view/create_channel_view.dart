import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/models/channel_model.dart';
import 'package:telegrammy/features/channels/presentation/view_models/channel_cubit/channel_cubit.dart';
import 'package:telegrammy/features/channels/presentation/widgets/create_channel_form.dart';

import '../../../../../cores/routes/route_names.dart';

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
        leading: IconButton(
          key: const ValueKey('CreateChannelBackButton'),
          onPressed: () => context.goNamed(RouteNames.chats),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text('Create Channel'),
        backgroundColor: primaryColor,
        centerTitle: true,
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
