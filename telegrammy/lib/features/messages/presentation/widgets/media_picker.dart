import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaPickerMenu extends StatefulWidget {
  final Function(dynamic) onSelectMedia;
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

  Future<void> _pickMultipleFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      for (var file in result.files) {
        widget.onSelectMedia(file);
      }

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
          if (!kIsWeb)
            PopupMenuItem(
              value: 'camera',
              child: ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.brown),
                title: Text('camera'),
              ),
            ),
          if (!kIsWeb)
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
        ];
      },
    );
  }
}
