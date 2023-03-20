import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invo_mobile/widgets/keypad/keypad.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class ImageGetter extends StatefulWidget {
  final Uint8List? initValue;
  final String2VoidFunc onPick;
  final FormFieldValidator<String> validator;
  ImageGetter({this.initValue, required this.onPick, required this.validator});
  @override
  _ImageGetterState createState() => _ImageGetterState();
}

class _ImageGetterState extends State<ImageGetter> {
  Uint8List? image;
  String? _image;
  @override
  void initState() {
    super.initState();
    image = widget.initValue;
    //widget.validator("");
  }

  Future getImageCamera() async {
    final ImagePicker _picker = ImagePicker();

    XFile? imageFile = await _picker.pickImage(source: ImageSource.camera);
    var result = await FlutterImageCompress.compressAndGetFile(
      imageFile!.path,
      imageFile.path,
      quality: 40,
    );

    // await CompressImage.compress(
    //     imageSrc: imageFile.path,
    //     desiredQuality: 40); //desiredQuality ranges from 0 to 100
    setImage(imageFile);
  }

  Future getImageGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    setImage(imageFile!);
  }

  void setImage(XFile imageFile) {
    if (imageFile == null) return;
    setState(() async {
      Uint8List imageBytes = await imageFile.readAsBytes();
      _image = base64Encode(imageBytes);
      if (widget.onPick != null) widget.onPick(_image!);
      image = imageBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? error = "";
    if (widget.validator != null) {
      error = widget.validator(_image);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          height: 170,
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: image == null
              ? Center()
              : Image.memory(
                  image!,
                  fit: BoxFit.fitWidth,
                ),
        ),
        error == null
            ? SizedBox(
                height: 0,
              )
            : Text(
                error,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.red[600],
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                getImageGallery();
                // or
                // _pickImageFromCamera();
                // use the variables accordingly
              },
              child: Text(AppLocalizations.of(context)!.translate('Pick Image')),
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () {
                getImageCamera();
                // or
                // _pickImageFromCamera();
                // use the variables accordingly
              },
              child: Text(AppLocalizations.of(context)!.translate('Capture Image')),
            ),
          ],
        ),
      ],
    );
  }
}
