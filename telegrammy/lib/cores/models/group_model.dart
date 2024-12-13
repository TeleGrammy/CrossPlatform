class Group {
  String name;
  String? description;
  String? imageUrl;
  bool isGroupPublic;

  Group(
      {required this.name,
      this.description,
      this.imageUrl,
      required this.isGroupPublic});
}
