import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
// import 'package:telegrammy/cores/routes/route_names.dart';
// import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/view_model/admin_dashboard/groups_dashboard_cubit.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/view_model/admin_dashboard/groups_dashboard_state.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/widgets/admin_board_bar.dart';

class GroupsView extends StatefulWidget {
  @override
  _GroupsViewState createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  late RegisteredGroupsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = RegisteredGroupsCubit();
    _cubit.loadRegisteredGroups(); // Load the groups data
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: Scaffold(
        appBar: AdminboardAppBar(
          titleBar: 'Groups Management',
          key: const ValueKey('Groups_Management'),
          signn:'0'
        ),
        body: BlocBuilder<RegisteredGroupsCubit, RegisteredGroupsState>(
          builder: (context, state) {
            if (state is RegisteredGroupsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RegisteredGroupsError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            } else if (state is RegisteredGroupsLoaded) {
              return ListView.builder(
                key: const ValueKey('Groups_List'),
                itemCount: state.registeredGroups.length,
                itemBuilder: (context, index) {
                  final group = state.registeredGroups[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: group.image != null && group.image!.isNotEmpty
                          ? NetworkImage(group.image!) as ImageProvider
                          : AssetImage('assets/images/logo.png'),
                      child: (group.image == null || group.image!.isEmpty)
                          ? const Icon(Icons.group, color: Colors.grey)
                          : null,
                    ),
                    title: Text(
                      group.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(group.description ?? 'No description available'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Text(group.groupPermissions.applyFilter?'Filter is applied':'Filter is not applied', // Display the current user status
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: group.groupPermissions.applyFilter
                                  ? Colors.green
                                  : Colors .red, // Dynamic color based on status
                            )),
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () {
                            if (!group.groupPermissions.applyFilter ) {
                              _cubit.filterMediaGroup(true, group.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('filter is applied  successfully')),
                              );
                            }
                          },
                        ),
                        // IconButton(
                        //   icon: const Icon(Icons.cancel, color: Colors.orange),
                        //   onPressed: () {
                        //     if (group.status != 'inactive') {
                        //       _cubit.filterMediaGroup(false, group.id);
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(content: Text('Group deactivated successfully')),
                        //       );
                        //     }
                        //   },
                        // ),
                        IconButton(
                          icon: const Icon(Icons.block, color: Colors.red),
                          onPressed: () {
                           if (group.groupPermissions.applyFilter ) {
                              _cubit.filterMediaGroup(false, group.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('filter is not applied  successfully')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      context.goNamed(RouteNames.singleRegeisterGroupPage, extra: group);
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'Please wait...',
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
