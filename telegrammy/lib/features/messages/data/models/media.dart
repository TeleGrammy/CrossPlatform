class Media {
  final String? mediaUrl;
  final String? mediaKey;

  const Media({ this.mediaKey, this.mediaUrl});

  factory Media.fromJson(Map<String, dynamic> json){
    return Media(mediaKey: json['signedUrl'], mediaUrl: json['mediaKey']);
  }
}