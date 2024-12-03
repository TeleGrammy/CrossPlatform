import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/profile/presentation/views/blocked_users_view.dart';
import 'package:telegrammy/features/profile/presentation/view_models/blocked_users_cubit/blocked_users_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/blocked_users_cubit/blocked_users_state.dart';

class SecurityOptions extends StatefulWidget {
  @override
  _SecurityOptionsState createState() => _SecurityOptionsState();
}

class _SecurityOptionsState extends State<SecurityOptions> {
  @override
  void initState() {
    super.initState();
    // Load blocked users when the widget is initialized
    context.read<BlockedUsersCubit>().loadBlockedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlockedUsersCubit, BlockedUsersState>(
      builder: (context, state) {
        int blockedUsersCount = 0; // Default count

        if (state is BlockedUsersLoaded) {
          // Get the count of blocked users from the state
          blockedUsersCount = state.blockedUsers.length;
        } else if (state is BlockedUsersError) {
          // Handle error state (optional)
          blockedUsersCount = 0;
        }

        return Column(
          children: [
            Container(
              key: const ValueKey('SecurityOptions'),
              color: primaryColor, // Set the background color for the tile
              child: ListTile(
                leading: Icon(Icons.block, color: Colors.red),
                title: Text(
                  'Blocked Users',
                  style: textStyle17.copyWith(fontWeight: FontWeight.w400),
                ),
                trailing: Row(
                  mainAxisSize:
                      MainAxisSize.min, // Keep trailing elements constrained
                  children: [
                    Text(
                      '$blockedUsersCount',
                      style: textStyle17.copyWith(
                        fontWeight: FontWeight.w400,
                        color: tileInfoHintColor,
                      ), // Display blocked users count
                    ),
                    SizedBox(
                        width:
                            8), // Add some space between the count and the icon
                    Icon(Icons.arrow_forward,
                        color:
                            tileForwardArrowColor), // Arrow icon for navigation
                  ],
                ),
                onTap: () {
                  print('Blocked users pressed');
                  // Navigate to blocked users page
                  context.pushNamed(RouteNames.blockingView);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
