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
  final String contactId;
  final String chatId;
  final BlockDetails blockDetails;

  ContactData({
    required this.contactId,
    required this.chatId,
    required this.blockDetails,
  });

  // Factory to create an instance from JSON
  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      contactId: json['contactId'] ?? 'unknown',
      chatId: json['chatId'] ?? 'unknown',
      blockDetails: BlockDetails.fromJson(json['blockDetails']),
    );
  }

  @override
  String toString() => 
      "ContactData(contactId: $contactId, chatId: $chatId, blockDetails: $blockDetails)";
}

class BlockDetails {
  final String status;
  final String? date; // Use nullable String for `date` since it can be null

  BlockDetails({required this.status, this.date});

  // Factory to create an instance from JSON
  factory BlockDetails.fromJson(Map<String, dynamic> json) {
    return BlockDetails(
      status: json['status'] ?? 'unknown',
      date: json['date'], // Nullable value
    );
  }

  @override
  String toString() => "BlockDetails(status: $status, date: $date)";
}
