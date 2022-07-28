import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  // UserImagePicker(this.imagePickFn);
  UserImagePicker(this.pickImage);
  // final void Function(File pickedImage) imagePickFn;
  File? pickImage;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      if (pickedImageFile != null) _pickedImage = File(pickedImageFile.path);
    });
    if (pickedImageFile != null) widget.pickImage = File(pickedImageFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: const Text(
            'Add Image',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
