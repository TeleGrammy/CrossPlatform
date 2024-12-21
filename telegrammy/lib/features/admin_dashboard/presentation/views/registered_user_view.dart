import 'package:flutter/material.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/registered_users_model.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/widgets/admin_board_bar.dart';

class UserDetailView extends StatelessWidget {
  final RegisteredUsersData user;

  const UserDetailView({Key? key, required this.user}) : super(key: key);

  // Helper function to handle null values with a fancy placeholder
  String displayValue(String? value, {String placeholder = "Not Available"}) {
    return value != null && value.isNotEmpty ? value : placeholder;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminboardAppBar(
        titleBar: user.username,
        key: const ValueKey('Single_Registered_Users_appbar'),
        signn:'1'
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
                  backgroundImage:
                      user.picture != null && user.picture!.isNotEmpty
                          ? NetworkImage(user.picture!) as ImageProvider
                          : AssetImage('assets/images/logo.png'),
                  child: user.picture == null || user.picture!.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
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
                    _buildInfoRow(
                      context,
                      "Name",
                      displayValue(user.username),
                    ),
                    _buildInfoRow(
                      context,
                      "Screen Name",
                      displayValue(user.screenName),
                    ),
                    _buildInfoRow(
                      context,
                      "Email",
                      displayValue(user.email),
                    ),
                    _buildInfoRow(
                      context,
                      "Phone",
                      displayValue(user.phone),
                    ),
                    _buildInfoRow(
                      context,
                      "Bio",
                      displayValue(user.bio),
                    ),
                    _buildInfoRow(
                      context,
                      "Status",
                      displayValue(user.status),
                      valueColor: user.status == "banned"
                          ? Colors.red
                          : Colors.green,
                    ),
                    _buildInfoRow(
                      context,
                      "Banned",
                      user.status == "banned" ? "Yes" : "No",
                      valueColor: user.status == "banned"
                          ? Colors.red
                          : Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for consistent styling
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
}
