import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/view_model/admin_dashboard/admin_dashboard_cubit.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/view_model/admin_dashboard/admin_dashboard_state.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/views/registered_user_view.dart';


class RegisteredUsersView extends StatefulWidget {
  @override
  _RegisteredUsersViewState createState() => _RegisteredUsersViewState();
}

class _RegisteredUsersViewState extends State<RegisteredUsersView> {
  late RegisteredUsersCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = RegisteredUsersCubit();
    _cubit.loadRegisteredUsers(); // Call to load registered users
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: Scaffold(
        appBar: GeneralAppBar(
          titleBar: 'Registered Users',
          key: const ValueKey('Registered_Users'),
        ),
        body: BlocBuilder<RegisteredUsersCubit, RegisteredUsersState>(
          builder: (context, state) {
            if (state is RegisteredUsersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RegisteredUsersError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            } else if (state is RegisteredUsersLoaded) {
              return ListView.builder(
                key: const ValueKey('Registered_UsersList'),
                itemCount: state.registeredUsers.length,
                itemBuilder: (context, index) {
                  final user = state.registeredUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.picture),
                      onBackgroundImageError: (_, __) =>
                          const Icon(Icons.person, color: Colors.grey),
                    ),
                    title: Text(
                      user.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user.screenName),
                    trailing: IconButton(
                      icon: const Icon(Icons.block, color: Colors.red),
                      onPressed: () {
                        _cubit.updateUserStatus(user.id, !user.isBanned);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(user.isBanned
                              ? 'User unbanned successfully'
                              : 'User banned successfully'),
                        ));
                      },
                    ),
                    onTap: () {
                      context.goNamed(RouteNames.singleRegeisterUserPage, extra: user );
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}