import 'dart:io';
import 'package:flutter/material.dart';
import 'package:latres_tpm_035/helper/hive_database.dart';
import 'package:latres_tpm_035/helper/shared_preference.dart';
import '../../common_submit_button.dart';
import 'image_picker_helper.dart';

class ImagePickerSection extends StatefulWidget {
  final String username;
  final String image;
  final String password;
  final String history;
  const ImagePickerSection(
      {Key? key,
      required this.username,
      required this.image,
      required this.password,
      required this.history})
      : super(key: key);

  @override
  _ImagePickerSectionState createState() => _ImagePickerSectionState();
}

class _ImagePickerSectionState extends State<ImagePickerSection> {
  late final HiveDatabase _hive = HiveDatabase();
  String imagePath = "";

  @override
  initState() {
    super.initState();
    setState(() {
      widget.image.isEmpty ? imagePath = "" : imagePath = widget.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: _imageSection(),
        ),
        _buttonSectionGallery(),
        _buttonSectionCamera(),
      ],
    );
  }

  Widget _buttonSectionCamera() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child : CommonSubmitButton(
        labelButton: "CAMERA",
        submitCallback: (value) {
          imagePath = '';
          ImagePickerHelper()
              .getImageFromCamera((value) => _processImage(value));
        }),
    );
  }


  Widget _buttonSectionGallery() {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child : CommonSubmitButton(
        labelButton: "GALLERY",
        submitCallback: (value) {
          imagePath = '';
          ImagePickerHelper()
              .getImageFromGallery((value) => _processImage(value));
        }),
    );
  }

  Widget _imageSection() {
    if (imagePath.isEmpty) {
      return const CircleAvatar(
        radius: 80.0,
        child: Center(child: Text("NULL")),
      );
    }
    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: 80,
      child: CircleAvatar(
        radius: 40,
        backgroundImage: Image.file(
          File(imagePath),
        ).image,
      ),
    );
  }

  void _processImage(String? value) async {
    String saved = await SharedPreference.getImage();
    if (value != null) {
      setState(() {
        if (imagePath == "") {
          imagePath = value;
        }
        debugPrint(imagePath);
        SharedPreference().setImage(imagePath);
        _hive.updateImage(
            widget.username, widget.password, widget.history, imagePath);
      });
    } else {
      setState(() {
        imagePath = saved;
      });
    }
  }
}
