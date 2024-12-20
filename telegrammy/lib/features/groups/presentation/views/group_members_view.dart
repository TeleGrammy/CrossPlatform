import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import '../../../../cores/routes/route_names.dart';
import '../../../../cores/services/groups_socket.dart';
import '../../../../cores/services/service_locator.dart';
import '../../../../cores/styles/styles.dart';
import '../../../messages/data/models/contacts.dart';
import '../../data/models/group.dart';

class GroupMembersView extends StatefulWidget {
  GroupMembersView(
      {required this.groupId,
      required this.members,
      required this.chat,
      required this.lastSeen});
  final String groupId;
  final List<MemberData> members;
  Chat chat;
  String lastSeen;
  @override
  _GroupMembersViewState createState() => _GroupMembersViewState();
}

class _GroupMembersViewState extends State<GroupMembersView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<MemberData> _filteredMembers = [];

  @override
  void initState() {
    super.initState();
    getit.get<GroupSocketService>().connectToGroupServer();
    _filteredMembers = widget.members;
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _filteredMembers = widget.members; // Reset to all members
      _searchController.clear();
    });
  }

  void _filterMembers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMembers = widget.members;
      } else {
        _filteredMembers = widget.members
            .where((member) =>
                member.username.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: _filterMembers,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search members...',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: tileInfoHintColor),
              )
            : Text('Group members',
                style: textStyle17.copyWith(fontWeight: FontWeight.w600)),
        key: const ValueKey('GroupMembersAppBar'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _stopSearch,
            )
          else
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _startSearch,
            ),
        ],
        leading: IconButton(
          key: const ValueKey('ViewGroupMembersBackButton'),
          onPressed: () => context.goNamed(RouteNames.groupSettings,
              extra: [widget.chat, widget.lastSeen]),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            key: const ValueKey('GroupMembers'),
            child: _filteredMembers.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredMembers.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredMembers[index];

                      return ListTile(
                        key: ValueKey('GroupMember_$index'),
                        tileColor: primaryColor,
                        leading: CircleAvatar(
                          backgroundImage: contact.picture != null
                              ? NetworkImage(contact.picture!)
                              : null,
                          radius: 20,
                        ),
                        title: Text(
                          key: ValueKey('username_$index'),
                          contact.username,
                          style: TextStyle(color: tileInfoHintColor),
                        ),
                      );
                    },
                  )
                : Center(
                    key: const ValueKey('NoMembersText'),
                    child: Text(
                      'No Members yet.',
                      style: TextStyle(color: tileInfoHintColor),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
