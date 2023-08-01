// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_workout/features/data/account_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(File pickedImage)? onImagePicked;

  const ImagePickerWidget({Key? key, this.onImagePicked}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _pickImage();
      },
      child: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
    );
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      widget.onImagePicked?.call(File(pickedImage.path));
      // Call the setImageFile method from ProfilAcc to update the imageFile property
      final profilAcc = Provider.of<ProfilAcc>(context, listen: false);
      profilAcc.setImageFile(File(pickedImage.path));
    }
  }
}
