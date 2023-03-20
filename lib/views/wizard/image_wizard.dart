import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invo_mobile/widgets/keypad/keypad.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageWizard extends StatefulWidget {
  final Uint8List? initValue;
  final String2VoidFunc? onPick;
  final FormFieldValidator<String>? validator;
  ImageWizard({this.initValue, this.onPick, this.validator});
  @override
  _ImageWizardState createState() => _ImageWizardState();
}

class _ImageWizardState extends State<ImageWizard> {
  late Uint8List? image;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(37, 205, 137, 1)),
                    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ))),
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
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(37, 205, 137, 1)),
                    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ))),
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

// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:invo_mobile/widgets/keypad/keypad.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';

// class ImageWizard extends StatefulWidget {
//   final Uint8List initValue;
//   final String2VoidFunc onPick;
//   final FormFieldValidator<String> validator;
//   ImageWizard({this.initValue, this.onPick, this.validator});
//   @override
//   _ImageWizardState createState() => _ImageWizardState();
// }

// class _ImageWizardState extends State<ImageWizard> {
//   Uint8List image;
//   String _image;
//   @override
//   void initState() {
//     super.initState();
//     image = widget.initValue;
//     //widget.validator("");
//   }

//   Future getImageCamera() async {
//     File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
//     print("FILE SIZE BEFORE: " + imageFile.lengthSync().toString());
//     var result = await FlutterImageCompress.compressAndGetFile(
//       imageFile.path,
//       imageFile.path,
//       quality: 40,
//     );

//     // await CompressImage.compress(
//     //     imageSrc: imageFile.path,
//     //     desiredQuality: 40); //desiredQuality ranges from 0 to 100
//     print("FILE SIZE  AFTER: " + imageFile.lengthSync().toString());
//     setImage(imageFile);
//   }

//   Future getImageGallery() async {
//     File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
//     setImage(imageFile);
//   }

//   void setImage(File imageFile) {
//     if (imageFile == null) return;
//     setState(() {
//       Uint8List imageBytes = imageFile.readAsBytesSync();
//       _image = base64Encode(imageBytes);
//       if (widget.onPick != null) widget.onPick(_image);
//       image = imageBytes;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     /*  String error = "";
//     if (widget.validator != null) {
//       error = widget.validator(_image);
//     } */
//     Orientation orientation = MediaQuery.of(context).orientation;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.white,
//               width: 1,
//             ),
//           ),
//           width: 120,
//           height: 120,
//           margin: EdgeInsets.only(bottom: 8),
//           child: image == null
//               ? Container(
//                   padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
//                   decoration: BoxDecoration(
//                     color: Colors.white10,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Choose Image",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 )
//               : Image.memory(
//                   image,
//                   fit: BoxFit.fitWidth,
//                 ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               margin: EdgeInsets.only(right: 8),
//               width: 140,
//               child: ElevatedButton(
//                 color: Colors.white24,
//                 onPressed: () {
//                   getImageGallery();
//                   // or
//                   // _pickImageFromCamera();
//                   // use the variables accordingly
//                 },
//                 child: Text(
//                   "Pick Image",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//                 shape: new RoundedRectangleBorder(
//                     side: BorderSide(color: Colors.white, width: 1.5),
//                     borderRadius: new BorderRadius.circular(8.0)),
//               ),
//             ),
//             Container(
//               width: 140,
//               child: ElevatedButton(
//                 onPressed: () {
//                   getImageCamera();
//                   // or
//                   // _pickImageFromCamera();
//                   // use the variables accordingly
//                 },
//                 color: Colors.white24,
//                 child: Text(
//                   "Capture Image",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//                 shape: new RoundedRectangleBorder(
//                     side: BorderSide(color: Colors.white, width: 1.5),
//                     borderRadius: new BorderRadius.circular(8.0)),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
