import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  ImageInput({
    super.key,
    required this.onPickImage,
  });

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  // Below function is used to take the pic using the camera.

  void _takePicture() async {
    final ImagePicker imagePicker = ImagePicker();
    final pickImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 500,
    );

    if (pickImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickImage.path);
    });

    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget? content = TextButton.icon(
      icon: Icon(Icons.camera),
      onPressed: _takePicture,
      label: const Text("Take Picture"),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    // Widget? content = if (_selectedImage != null) {
    //   content = Image.file(
    //     _selectedImage!,
    //     fit: BoxFit.cover,
    //     width: double.infinity,
    //     height: 300,
    //   );
    // }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: 400,
      child: content,
    );
  }
}
