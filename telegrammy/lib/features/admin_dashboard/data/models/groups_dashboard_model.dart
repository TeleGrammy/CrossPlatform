class GroupDataResponse {
  final String status;
  final List<GroupData> data;

  GroupDataResponse({
    required this.status,
    required this.data,
  });

  factory GroupDataResponse.fromJson(Map<String, dynamic> json) {
    return GroupDataResponse(
      status: json['status'],
      data: (json['data'] as List)
          .map((item) => GroupData.fromJson(item))
          .toList(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'status': status,
  //     'data': data.map((item) => item.toJson()).toList(),
  //   };
  // }
}

class GroupData {
  final GroupPermissions groupPermissions;
  final String id;
  final String name;
  final String? image;
  final String? description;
  final String groupType;
  final Owner owner;

  GroupData({
    required this.groupPermissions,
    required this.id,
    required this.name,
    this.image,
    this.description,
    required this.groupType,
    required this.owner,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) {
    // print('sucess $json');
    return GroupData(
      groupPermissions:
          GroupPermissions.fromJson(json['groupPermissions']),
      id: json['_id'],
      name: json['name'],
      image: json['image']?.isNotEmpty == true ? json['image'] as String : null,
      description: json['description']?.isNotEmpty == true ? json['description'] as String : null,
      groupType: json['groupType'],
      owner: Owner.fromJson(json['owner']),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'groupPermissions': groupPermissions.toJson(),
  //     '_id': id,
  //     'name': name,
  //     'image': image,
  //     'description': description,
  //     'groupType': groupType,
  //     'owner': owner.toJson(),
  //   };
  // }
}

class GroupPermissions {
  final bool sendTextMessages;
  final bool addUsers;
  final bool pinMessages;
  final bool changeChatInfo;
  final bool applyFilter;

  GroupPermissions({
    required this.sendTextMessages,
    required this.addUsers,
    required this.pinMessages,
    required this.changeChatInfo,
    required this.applyFilter,
  });

  factory GroupPermissions.fromJson(Map<String, dynamic> json) {
    return GroupPermissions(
      sendTextMessages: json['sendTextMessages'],
      addUsers: json['addUsers'],
      pinMessages: json['pinMessages'],
      changeChatInfo: json['changeChatInfo'],
      applyFilter: json['applyFilter'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'sendTextMessages': sendTextMessages,
  //     'addUsers': addUsers,
  //     'pinMessages': pinMessages,
  //     'changeChatInfo': changeChatInfo,
  //     'applyFilter': applyFilter,
  //   };
  // }
}

class Owner {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String? screenName;

  Owner({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.screenName,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      screenName: json['screenName']?.isNotEmpty == true ? json['screenName'] as String : null,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     '_id': id,
  //     'username': username,
  //     'email': email,
  //     'phone': phone,
  //     'screenName': screenName,
  //   };
  // }
}
