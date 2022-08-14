import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  // UserImagePicker(this.imagePickFn);
  UserImagePicker(this.pickImage, this.pickedImage);
  // final void Function(File pickedImage) imagePickFn;
  VoidCallback pickImage;
  File? pickedImage;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  // void _pickImage() async {
  //   final pickedImageFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 50,
  //     maxWidth: 150,
  //   );
  //   setState(() {
  //     if (pickedImageFile != null) _pickedImage = File(pickedImageFile.path);
  //   });
  //   if (pickedImageFile != null) widget.pickImage = File(pickedImageFile.path);
  //   print('PICKED ${widget.pickImage}');
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: widget.pickedImage != null
              ? FileImage(widget.pickedImage!)
              : null,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 28.0),
          child: FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: widget.pickImage,
            icon: const Icon(Icons.image),
            label: Text(
              'add_image'.tr,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
