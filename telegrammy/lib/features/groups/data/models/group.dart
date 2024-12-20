class Group {
  final String groupId;
  String name;
  String? description;
  String? image;
  String groupPrivacy;
  int groupSizeLimit;

  Group({
    required this.groupId,
    required this.name,
    this.description,
    this.image,
    required this.groupPrivacy,
    required this.groupSizeLimit,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['_id'],
      name: json['name'],
      description: json['description'] ?? '-',
      image: json['image'] ?? null,
      groupPrivacy: json['groupType'],
      groupSizeLimit: json['groupSizeLimit'],
    );
  }
}

class ContactsResponse {
  final String status;
  final List<ContactData> contacts;

  ContactsResponse({required this.status, required this.contacts});

  factory ContactsResponse.fromJson(Map<String, dynamic> json) {
    return ContactsResponse(
      status: json['status'] ?? 'unknown',
      contacts: (json['data']['contacts'] as List<dynamic>)
          .map((contactJson) => ContactData.fromJson(contactJson))
          .toList(),
    );
  }

  @override
  String toString() => "ContactsResponse(status: $status, contacts: $contacts)";
}

class ContactData {
  final String userId;
  final String username;
  final String? phoneNumber;
  final String? picture;
  final String email;
  final String chatId;
  final String blockDetails;

  ContactData(
      {required this.userId,
      required this.chatId,
      required this.blockDetails,
      required this.email,
      this.phoneNumber,
      required this.username,
      this.picture});

  // Factory to create an instance from JSON
  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      username: json['contactId']['username'],
      email: json['contactId']['email'],
      phoneNumber: json['contactId']['phone'] ?? null,
      picture: json['contactId']['picture'] ?? null,
      userId: json['contactId']['_id'],
      chatId: json['chatId'],
      blockDetails: json['blockDetails']['status'],
    );
  }
}
