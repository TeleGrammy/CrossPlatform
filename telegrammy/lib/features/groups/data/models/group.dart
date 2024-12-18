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
