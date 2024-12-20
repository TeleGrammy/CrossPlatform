import 'package:flutter/material.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/groups_dashboard_model.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/widgets/admin_board_bar.dart';

class GroupDetailView extends StatelessWidget {
  final GroupData group;

  const GroupDetailView({Key? key, required this.group}) : super(key: key);

  // Helper function to handle null values with a fancy placeholder
  String displayValue(String? value, {String placeholder = "Not Available"}) {
    return value != null && value.isNotEmpty ? value : placeholder;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminboardAppBar(
        titleBar: group.name,
        key: const ValueKey('Single_Group_Details_Appbar'),
        signn:'2'
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: group.image != null && group.image!.isNotEmpty
                      ? NetworkImage(group.image!) as ImageProvider
                      : AssetImage('assets/images/default_group.png'),
                  child: group.image == null || group.image!.isEmpty
                      ? const Icon(Icons.group, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(context, "Name", group.name),
                    _buildInfoRow(context, "Description", displayValue(group.description)),
                    _buildInfoRow(context, "Group Type", group.groupType),
                    _buildInfoRow(context, "Owner", group.owner.username),
                    _buildInfoRow(context, "Owner Email", group.owner.email),
                    _buildInfoRow(context, "Owner Phone", group.owner.phone),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Permissions",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              _buildPermissionsList(context, group.groupPermissions),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for consistent styling of info rows
  Widget _buildInfoRow(BuildContext context, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "$label:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: valueColor ?? Colors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for permissions list
  Widget _buildPermissionsList(BuildContext context, GroupPermissions permissions) {
    final permissionsMap = {
      "Send Text Messages": permissions.sendTextMessages,
      "Add Users": permissions.addUsers,
      "Pin Messages": permissions.pinMessages,
      "Change Chat Info": permissions.changeChatInfo,
      "Apply Filter": permissions.applyFilter,
    };

    return Column(
      children: permissionsMap.entries.map((entry) {
        return ListTile(
          leading: Icon(
            entry.value ? Icons.check : Icons.close,
            color: entry.value ? Colors.green : Colors.red,
          ),
          title: Text(entry.key),
        );
      }).toList(),
    );
  }
}
