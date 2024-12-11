import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaPickerMenu extends StatefulWidget {
  final Function(XFile) onSelectMedia;
  const MediaPickerMenu({required this.onSelectMedia});

  @override
  State<MediaPickerMenu> createState() => _MediaPickerMenuState();
}

class _MediaPickerMenuState extends State<MediaPickerMenu> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  List<PlatformFile>? _multipleFiles;

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
      widget.onSelectMedia(_image!);
    }
  }

  // Function to take a photo using the camera
  Future<void> _takePhoto() async {
    final XFile? takenPhoto =
        await _picker.pickImage(source: ImageSource.camera);
    if (takenPhoto != null) {
      setState(() {
        _image = takenPhoto;
      });
      widget.onSelectMedia(_image!);
    }
  }

  // Function to pick multiple files
  Future<void> _pickMultipleFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      // widget.onSelectMedia(result.files!);
      setState(() {
        _multipleFiles = result.files;
      });
    }
  }

  onSelected(String Media) async {
    if (Media == 'image') {
      await _pickImageFromGallery();
    } else if (Media == 'file') {
      await _pickMultipleFiles();
    } else if (Media == 'camera') {
      await _takePhoto();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        onSelected(value);
      },
      icon: Icon(Icons.attach_file, color: Colors.black),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: 'camera',
            child: ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.brown),
              title: Text('camera'),
            ),
          ),
          PopupMenuItem(
            value: 'image',
            child: ListTile(
              leading: Icon(Icons.image, color: Colors.blue),
              title: Text('Image'),
            ),
          ),
          PopupMenuItem(
            value: 'file',
            child: ListTile(
              leading: Icon(Icons.insert_drive_file, color: Colors.green),
              title: Text('File'),
            ),
          ),
          PopupMenuItem(
            value: 'sticker',
            child: ListTile(
              leading: Icon(Icons.sticky_note_2, color: Colors.yellow),
              title: Text('Sticker'),
            ),
          ),
        ];
      },
    );
  }
}
