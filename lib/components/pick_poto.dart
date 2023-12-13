import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PickPhoto extends StatefulWidget {
  final Color color;
  final double height;
  final ValueNotifier<File?>? onSelectImg;
  final Widget? initialImg;

  const PickPhoto({
    Key? key,
    this.height = 115,
    this.color = Colors.transparent,
    this.onSelectImg,
    this.initialImg,
  }) : super(key: key);

  @override
  State<PickPhoto> createState() => _PickPhotoState();
}

class _PickPhotoState extends State<PickPhoto> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final File img = File(image.path);
      setState(() {
        _image = img;
        widget.onSelectImg?.value = img;
        Navigator.pop(context);
      });
    } on PlatformException {
      const Text('Bir nasazlyk bar');
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void showSelectionPhotoOptions() {
    showModalBottomSheet<Widget>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      backgroundColor: const Color.fromRGBO(41, 45, 50, 1),
      builder: (_) => Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: SizedBox(
          height: 133,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
                child: const Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                  size: 56,
                ),
              ),
              Container(
                height: double.infinity,
                width: 4,
                color: Colors.black,
              ),
              GestureDetector(
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
                child: const Icon(
                  Icons.photo_camera_back,
                  color: Colors.white,
                  size: 56,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showSelectionPhotoOptions,
      child: Container(
        padding: EdgeInsets.all(_image == null && widget.initialImg == null ? 20 : 0),
        height: widget.height,
        width: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromRGBO(151, 151, 151, 1)),
        ),
        child: _image == null
            ? widget.initialImg ?? const Icon(
                Icons.photo_camera,
                color: Colors.blue,
                size: 60,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: FileImage(_image!),
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
