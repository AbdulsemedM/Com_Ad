import 'dart:io';

import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/app_loading.dart';

class ImageChooserWidget extends StatefulWidget {
  final Function onImagePicked;

  const ImageChooserWidget({super.key, required this.onImagePicked});

  @override
  State<ImageChooserWidget> createState() => _ImageChooserWidgetState();
}

class _ImageChooserWidgetState extends State<ImageChooserWidget> {
  final ImagePicker picker = ImagePicker();

  XFile? _imagePicked;
  bool _displayProgress = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // dialog chooser
        context.displayDialog(
            title: 'Choose image from',
            message: '',
            pText: 'Camera',
            nText: 'Gallery',
            onNegativeClicked: () {
              _pickImage(ImageSource.gallery);
            },
            onPClicked: () {
              _pickImage(ImageSource.camera);
            });
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: _imagePicked != null
            ? Image.file(
                File(_imagePicked!.path),
                errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) =>
                    const Center(
                        child: Text('This image type is not supported')),
              )
            : _displayProgress
                ? const AppLoadingWidget()
                : const Icon(Icons.add_a_photo_outlined),
      ),
    );
  }

  void _pickImage(ImageSource imageSource) async {
    setState(() {
      _displayProgress = true;
    });

    try {
      _imagePicked = await picker.pickImage(source: imageSource);
      if (_imagePicked != null) {
        widget.onImagePicked(File(_imagePicked!.path));
      }
      _displayProgress = false;
      setState(() {});
    } catch (e) {
      context.displaySnack('Unable to pick image! Try another one');
    }
  }
}
