import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // Import the image package
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';
import 'package:telegrammy/features/profile/presentation/view_models/story_cubit/story_cubit.dart';
import 'dart:typed_data'; // For Uint8List
import 'package:http_parser/http_parser.dart'; // For specifying content type in web
class CreateStoryPage extends StatefulWidget {
  @override
  _CreateStoryPageState createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageUrl; // This will store the image preview
 String? _preview_imageUrl; // This will store the image preview
  final TextEditingController _captionController = TextEditingController();

  // Pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? selectedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedFile != null) {
           Uint8List fileBytes = await selectedFile.readAsBytes();
      // final fileName = selectedFile.name;

      // // Construct FormData
      // final formData = FormData.fromMap({
      //   "picture": MultipartFile.fromBytes(
      //     fileBytes,
      //     filename: fileName,
      //     contentType: MediaType("image", "jpeg"), // Adjust based on file type
      //   ),
      // });
        final compressedImage = await _compressImage(fileBytes);
      final base64Image = base64Encode(compressedImage); // Encode to Base64

      setState(() {
        _imageUrl =fileBytes; // Update the image preview
        _preview_imageUrl=base64Image;
      });
    }
  }

  // Capture an image with the camera
  Future<void> _captureImageWithCamera() async {
    final XFile? capturedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (capturedFile != null) {
      final bytes = await capturedFile.readAsBytes();
      final compressedImage = await _compressImage(bytes);
      final base64Image = base64Encode(compressedImage); // Encode to Base64
      setState(() {
        _imageUrl = bytes; // Update the image preview
        _preview_imageUrl=base64Image;
      });
    }
  }

  // Compress the image
  Future<Uint8List> _compressImage(Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize the image (for example, resize it to 800x800)
    img.Image resizedImage = img.copyResize(image, width: 800);

    // Encode the resized image to JPEG with 85% quality
    final compressedBytes =
        Uint8List.fromList(img.encodeJpg(resizedImage, quality: 85));

    return compressedBytes; // Return the compressed image bytes
  }

  // Post the story (Base64 image and caption)
  void _postStory() {
    final story = StoryCreation(
      content: _captionController.text, // Caption
      media: _imageUrl, // Base64 encoded image (can be null)
    );
    print(_captionController.text);
    // print(_imageUrl);

    // Call API to send the story data to the backend
    context.read<StoriesCubit>().updateStory(story);

    // Show success dialog after story is posted
    _showSuccessDialog();
  }

  // Show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success", style: TextStyle(color: Colors.green)),
          content: Text("Story uploaded successfully!"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GeneralAppBar(
        titleBar: 'Create Story',
        key: const ValueKey('CreatingUserStoryAppBar'),
      ),
      backgroundColor: Colors.black, // Set background color to black
      body: Column(
        children: [
          Expanded(
            child: _imageUrl == null
                ? Center(
                    child: Text("No image selected",
                        style: textStyle17.copyWith(
                            fontWeight: FontWeight.w400,
                            color: tileInfoHintColor)))
                : Image.memory(
                    base64Decode(
                        _preview_imageUrl!), // Display the Base64 image preview
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            key: const ValueKey('AddStoryCaptionField'),
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _captionController,
              decoration: InputDecoration(
                labelText: 'Add a caption...',
                labelStyle: TextStyle(
                    color: Colors.white), // Change label text color to white
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white), // Change border color to white
                ),
              ),
              style:
                  TextStyle(color: Colors.white), // Change text color to white
            ),
          ),
          Row(
            key: const ValueKey('StoryOptionsRow'),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.image,
                    color: Colors.white), // Change icon color to white
                onPressed: _pickImageFromGallery,
              ),
              IconButton(
                icon: Icon(Icons.camera_alt,
                    color: Colors.white), // Change icon color to white
                onPressed: _captureImageWithCamera,
              ),
              IconButton(
                icon: Icon(Icons.send,
                    color: Colors.white), // Change icon color to white
                onPressed: _postStory,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
