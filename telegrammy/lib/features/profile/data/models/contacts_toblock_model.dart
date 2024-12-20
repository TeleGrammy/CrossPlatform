// class ContactsResponse {
//   final String status;
//   final List<ContactData> contacts;

//   ContactsResponse({required this.status, required this.contacts});

//   // Factory to create an instance from JSON
//   factory ContactsResponse.fromJson(Map<String, dynamic> json) {
//     return ContactsResponse(
//       status: json['status'] ?? 'unknown',
//       contacts: (json['data']['contacts'] as List<dynamic>)
//           .map((contactJson) => ContactData.fromJson(contactJson))
//           .toList(),
//     );
//   }

//   @override
//   String toString() => "ContactsResponse(status: $status, contacts: $contacts)";
// }

// class ContactData {
//   final String contactId;
//   final String chatId;
//   final BlockDetails blockDetails;

//   ContactData({
//     required this.contactId,
//     required this.chatId,
//     required this.blockDetails,
//   });

//   // Factory to create an instance from JSON
//   factory ContactData.fromJson(Map<String, dynamic> json) {
//     return ContactData(
//       contactId: json['contactId'] ?? 'unknown',
//       chatId: json['chatId'] ?? 'unknown',
//       blockDetails: BlockDetails.fromJson(json['blockDetails']),
//     );
//   }

//   @override
//   String toString() => 
//       "ContactData(contactId: $contactId, chatId: $chatId, blockDetails: $blockDetails)";
// }

// class BlockDetails {
//   final String status;
//   final String? date; // Use nullable String for `date` since it can be null

//   BlockDetails({required this.status, this.date});

//   // Factory to create an instance from JSON
//   factory BlockDetails.fromJson(Map<String, dynamic> json) {
//     return BlockDetails(
//       status: json['status'] ?? 'unknown',
//       date: json['date'], // Nullable value
//     );
//   }

//   @override
//   String toString() => "BlockDetails(status: $status, date: $date)";
// }

class ContactsResponse {
  final String status;
  final List<ContactData> contacts;

  ContactsResponse({required this.status, required this.contacts});

  // Factory to create an instance from JSON
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
  final String chatId;
  final String id;
  final bool addedByMe;
  final BlockDetails blockDetails;
  final ContactInfo contactInfo;

  ContactData({
    required this.chatId,
    required this.id,
    required this.addedByMe,
    required this.blockDetails,
    required this.contactInfo,
  });

  // Factory to create an instance from JSON
  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      chatId: json['chatId'] ?? 'unknown',
      id: json['_id'] ?? 'unknown',
      addedByMe: json['addedByMe'] ?? false,
      blockDetails: BlockDetails.fromJson(json['blockDetails']),
      contactInfo: ContactInfo.fromJson(json['contactId']),
    );
  }

  @override
  String toString() =>
      "ContactData(chatId: $chatId, id: $id, addedByMe: $addedByMe, blockDetails: $blockDetails, contactInfo: $contactInfo)";
}

class BlockDetails {
  final String status;
  final String? date;

  BlockDetails({required this.status, this.date});

  // Factory to create an instance from JSON
  factory BlockDetails.fromJson(Map<String, dynamic> json) {
    return BlockDetails(
      status: json['status'] ?? 'unknown',
      date: json['date'], // Nullable
    );
  }

  @override
  String toString() => "BlockDetails(status: $status, date: $date)";
}

class ContactInfo {
  final String id;
  final String username;
  final String email;
  final String screenName;
  final String pictureUrl;
  final String phone;

  ContactInfo({
    required this.id,
    required this.username,
    required this.email,
    required this.screenName,
    required this.pictureUrl,
    required this.phone,
  });

  // Factory to create an instance from JSON
  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      id: json['_id'] ?? 'unknown',
      username: json['username'] ?? 'unknown',
      email: json['email'] ?? 'unknown',
      screenName: json['screenName'] ?? 'unknown',
      pictureUrl: json['picture'] ?? 'unknown',
      phone: json['phone'] ?? 'unknown',
    );
  }

  @override
  String toString() =>
      "ContactInfo(id: $id, username: $username, email: $email, screenName: $screenName, pictureUrl: $pictureUrl, phone: $phone)";
}
