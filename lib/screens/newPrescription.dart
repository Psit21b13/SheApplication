import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:womenCare/services/firebaseAuthService.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:womenCare/utils/constants.dart';

class NewPrescription extends StatefulWidget {
  @override
  _NewPrescriptionState createState() => _NewPrescriptionState();
}

class _NewPrescriptionState extends State<NewPrescription> {
  String _selectedDate = 'Date Of Birth';
  String _selectedDate1 = 'Enter Start Date';
  String _selectedDate2 = 'Next Billing Date';
  String reportImageUrl;
  File _image; //profile
  File _image1; //front
  File _image2; //ba

  bool isImageCropped;
  bool isFrontImageCropped;
  bool isRearImageCropped;
  bool isReferenceNullorEmpty;
  bool isSignatureLoaded = false;

  bool isFront = false;
  bool isRear = false;
  bool isLoading = false;
  TextEditingController _title = TextEditingController();

  double width;
  double height;

  final CollectionReference _prescriptionsCollection =
      Firestore.instance.collection('prescriptions');

  @override
  void initState() {
    isImageCropped = false;
    isFrontImageCropped = false;
    isRearImageCropped = false;
    isReferenceNullorEmpty = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryDark,
        title: Text("Add new prescription"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height * .8,
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Text(
                    //   "Add prescription",
                    //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _title,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'title'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // textWarning
                    //     ? Text(
                    //         "please enter the title of prescription!",
                    //         style: TextStyle(
                    //             fontSize: 12,
                    //             color: Colors.red,
                    //             fontWeight: FontWeight.w500),
                    //       )
                    //     : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Pick image of prescription",
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 15),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Constants.primaryDark,
                              size: 35,
                            ),
                            onPressed: () {
                              getImage();
                            }),
                        SizedBox(
                          width: 20,
                        ),
                        _image != null
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 35,
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: height * .4,
                        width: width,
                        child: Card(
                          elevation: 10,
                          child: (_image != null)
                              ? Image.file(
                                  _image,
                                  fit: BoxFit.cover,
                                )
                              : InkWell(
                                  onTap: () {
                                    getImage();
                                  },
                                  child: Center(
                                      child: Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                    size: 40,
                                  )),
                                ),
                        ))
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 00.0),
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * .2, vertical: 12),
                    onPressed: !isLoading
                        ? () async {
                            print("title" + _title.text);
                            print("image" + _image.toString());
                            if (_image == null) {
                              Fluttertoast.showToast(
                                  msg: "please pick prescription image",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (_title.text.length == 0) {
                              Fluttertoast.showToast(
                                  msg: "please enter the title of prescription",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              await uploadImage();
                              print("title" + _title.text);
                              print("image" + _image.toString());
                              await _prescriptionsCollection.add({
                                'user_id': AuthenticationService.prefs
                                    .get('user_id')
                                    .toString(),
                                'title': _title.text,
                                'url': reportImageUrl,
                                'date': DateFormat("dd-MM-yyyy")
                                    .format(DateTime.parse(
                                        DateTime.now().toString()))
                                    .toString()
                              });
                              setState(() {
                                Navigator.pop(context);
                                isLoading = false;
                              });
                            }
                          }
                        : () {},
                    color: Constants.primaryLight,
                    child: !isLoading
                        ? Text(
                            'SUBMIT',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )
                        : CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void getImage({bool isFrontPressed, bool isRearPressed}) async {
    if (isFrontPressed == null && isRearPressed == null) {
      setState(() {
        if (_image == null) isImageCropped = false;
      });
    } else if (isFrontPressed) {
      setState(() {
        if (_image1 == null) isFrontImageCropped = false;
      });
    } else {
      setState(() {
        if (_image2 == null) isRearImageCropped = false;
      });
    }
    var image = null;

    image = await showDialog<File>(
        context: this.context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Camera",
                    style: TextStyle(color: Constants.primaryDark),
                  ),
                  onPressed: () async {
                    image =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    Navigator.pop(context, image);
                  },
                ),
                FlatButton(
                  child: Text("Gallery"),
                  onPressed: () async {
                    image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    Navigator.pop(context, image);
                  },
                )
              ],
            ));

    //var image = await ImagePicker.pickImage(source: imageSource);

    if (image == null) return;

    if (isFrontPressed == null && isRearPressed == null) {
      _image = image;

      if (_image == null) return;
    } else if (isFrontPressed) {
      _image1 = image;

      if (_image1 == null) return;
    } else {
      _image2 = image;

      if (_image2 == null) return;
    }

    if (isFrontPressed == null && isRearPressed == null) {
      print("Image size Before compress " + _image?.lengthSync().toString());
      setState(() {
        //_image = image;
        cropImage(image);
        // print('Image Path $_image');
      });
    } else if (isFrontPressed) {
      print("Image size Before compress " + _image1?.lengthSync().toString());
      setState(() {
        // _image1 = image;
        cropImage(image, isFrontPressed: isFrontPressed);
      });
    } else {
      print("Image size Before compress " + _image2?.lengthSync().toString());
      setState(() {
        //_image2 = image;
        cropImage(image, isFrontPressed: false, isRearPressed: isRearPressed);
      });
    }
    // setState(() {
    //   _image = image;
    //   cropImage(image);
    //   // print('Image Path $_image');
    // });
  }

  void cropImage(File image, {bool isFrontPressed, bool isRearPressed}) async {
    // if(_image==null) return;

    if (isFrontPressed == null && isRearPressed == null) {
      _image = image;
      if (_image == null) return;
    } else if (isFrontPressed) {
      _image1 = image;
      if (_image1 == null) return;
    } else {
      _image2 = image;
      if (_image2 == null) return;
    }
    File croppedfile = await ImageCropper.cropImage(
        sourcePath: (isFrontPressed == null && isRearPressed == null)
            ? _image.path
            : (isFrontPressed) ? _image1.path : _image2.path,
        maxWidth: 512,
        maxHeight: 512,
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Constants.primaryDark,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedfile == null) return;
    //_image = croppedfile;
    print("Image size after compress " + image?.lengthSync().toString());
    setState(() {
      if (isFrontPressed == null && isRearPressed == null) {
        _image = croppedfile;
        isImageCropped = true;

        //upload function call it here
      } else if (isFrontPressed) {
        _image1 = croppedfile;
        isFrontImageCropped = true;

        // uploadFrontImage();
        //uploadPic();
      } else {
        _image2 = croppedfile;
        isRearImageCropped = true;
        // uploadRearImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('PrescriptionPhotos')
        .child('$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String url = "";

    print("Profile Picture uploaded");
    url = await firebaseStorageRef.getDownloadURL();
    setState(() {
      reportImageUrl = url;
    });
    print("Profile Picture link-->" + reportImageUrl);

    print('Profile Picture Uploaded ---> url here' + url);
  }

  String basename(String path) {
    return Uuid().v1().trim().substring(0, 8);
  }
}
