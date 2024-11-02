import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              context.goNamed(RouteNames.login);
            },
            child: Text('data')),
      ),
    );
  }
}
