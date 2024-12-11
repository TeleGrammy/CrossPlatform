import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../cores/constants/app_colors.dart';
import '../../../../../cores/routes/route_names.dart';

class CreateGroupView extends StatelessWidget {
  const CreateGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const ValueKey('CreateGroupBackButton'),
          onPressed: () => context.goNamed(RouteNames.chats),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text('Create Group'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
