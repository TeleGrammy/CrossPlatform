import 'package:flutter/material.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/presentation/widgets/audio_player_widget.dart';
import 'package:telegrammy/features/messages/presentation/widgets/video_attachment_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageAttachmentWidget extends StatelessWidget {
  final Message message;

  const MessageAttachmentWidget({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.messageType == "text") {
      return const SizedBox
          .shrink(); // Return an empty widget for text messages
    }

    print(message.mediaUrl!);
    switch (message.messageType) {
      case "image":
        return Image.network(
          message.mediaUrl!,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        );
      case "sticker":
        return Container(
          decoration: BoxDecoration(
            color: Colors.white, // White background color for the frame
            borderRadius:
                BorderRadius.circular(10.0), // Optional: Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Light shadow for effect
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                10.0), // Match the container's border radius
            child: Image.network(
              message.mediaUrl!,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        );
      case "video":
        return VideoAttachmentWidget(videoUrl: message.mediaUrl!);
      case "audio":
        return AudioPlayerWidget(audioUrl: message.mediaUrl!);
      case "file":
        return FileAttachmentWidget(fileUrl: message.mediaUrl!);
      default:
        return FileAttachmentWidget(fileUrl: message.mediaUrl!);
    }
  }
}

class FileAttachmentWidget extends StatelessWidget {
  final String fileUrl; // URL of the file
  final String fileName; // The name of the file
  final String fileSize; // The size of the file, e.g., '1.2 MB'

  FileAttachmentWidget({
    required this.fileUrl,
    this.fileName = '',
    this.fileSize = '',
  });

  void _openFile(String fileUrl) async {
    final Uri uri = Uri.parse(fileUrl);
    print('Attempting to open URL: $uri');

    // Check if the URL can be launched
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    print('URL launched successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description,
            size: 40,
            color: Colors.blue,
          ),
          SizedBox(width: 12),
          // File info (name and size)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileUrl,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  fileSize,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Button to open/download the file
          IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: () => _openFile(fileUrl),
          ),
        ],
      ),
    );
  }
}
