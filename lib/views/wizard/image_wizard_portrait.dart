import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invo_mobile/widgets/keypad/keypad.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageWizardPortrait extends StatefulWidget {
  final Uint8List? initValue;
  final String2VoidFunc? onPick;
  final FormFieldValidator<String>? validator;
  ImageWizardPortrait({this.initValue, this.onPick, this.validator});
  @override
  _ImageWizardPortraitState createState() => _ImageWizardPortraitState();
}

class _ImageWizardPortraitState extends State<ImageWizardPortrait> {
  Uint8List? image;
  late String _image;
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
      if (widget.onPick != null) widget.onPick!(_image);
      image = imageBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    /*  String error = "";
    if (widget.validator != null) {
      error = widget.validator(_image);
    } */
    Orientation orientation = MediaQuery.of(context).orientation;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          width: 120,
          height: 120,
          margin: EdgeInsets.only(bottom: 8),
          child: image == null
              ? Container(
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Image.asset('assets/icons/no-image.png'),
                    // child: Text(
                    //   "Choose Logo",
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     color: Colors.white,
                    //   ),
                    //),
                  ),
                )
              : Image.memory(
                  image!,
                  fit: BoxFit.fitWidth,
                ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 140,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(37, 205, 137, 1),
                  shape: new RoundedRectangleBorder(
                      //side: BorderSide(color: Colors.white, width: 1.5),
                      borderRadius: new BorderRadius.circular(20.0)),
                ),
                onPressed: () {
                  getImageGallery();
                  // or
                  // _pickImageFromCamera();
                  // use the variables accordingly
                },
                child: Text(
                  "Pick Image",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              width: 140,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(37, 205, 137, 1),
                  shape: new RoundedRectangleBorder(
                      //side: BorderSide(color: Colors.white, width: 1.5),
                      borderRadius: new BorderRadius.circular(20.0)),
                ),
                onPressed: () {
                  getImageCamera();
                  // or
                  // _pickImageFromCamera();
                  // use the variables accordingly
                },
                child: Text(
                  "Capture Image",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
