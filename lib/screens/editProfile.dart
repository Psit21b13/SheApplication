import 'dart:io';
// import 'package:ashva_fitness_example/constants/const.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:womenCare/services/firebaseAuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:uuid/uuid.dart';
import 'package:womenCare/utils/constants.dart';

class EditProfilePage extends StatefulWidget {
  static const String routeName = "/EditProfilePage";
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

//edit InkWell
class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _phone = new TextEditingController();
  final TextEditingController _email = new TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  File _image;
  bool isImageCaptured = false;
  File _image1; //front
  File _image2; //ba
  String reportImageUrl;

  bool isImageCropped;
  bool isFrontImageCropped;
  bool isRearImageCropped;
  bool isReferenceNullorEmpty;
  bool isSignatureLoaded = false;

  bool isFront = false;
  bool isRear = false;
  bool isLoading = false;
  bool dontSet = false;

  final CollectionReference _userCollection =
      Firestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Constants.primaryDark,
          title:
              Text("Edit your profile", style: TextStyle(color: Colors.white)),

          // actions: <Widget>[
          //   IconButton(
          //       icon: Icon(
          //         Icons.cancel,
          //         color: Colors.white,
          //       ),
          //       onPressed: () {
          //         print("pop profile");
          //         Navigator.pop(context);
          //       })
          // ],
        ),
        // extendBodyBehindAppBar: true,
        body: Stack(children: [
          Stack(children: [
            Container(
              decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //   colors: [
                  //     Color(0xffbc4e9c),
                  //     Constants.primaryDark,
                  //   ],
                  //   begin: FractionalOffset.topLeft,
                  //   end: FractionalOffset.bottomRight,
                  // )
                  ),
            ),
            Container(
              // padding: EdgeInsets.only(top: 70,bottom: 70),
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("users")
                      .where("user_id",
                          isEqualTo: AuthenticationService.prefs.get('user_id'))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _name.text =
                          snapshot.data.documents[0]['name'] != null && !dontSet
                              ? snapshot.data.documents[0]['name']
                              : _name.text;
                      return ListView(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 5.0, top: 50, left: 10, right: 10),
                              child: Align(
                                  child: Column(children: <Widget>[
                                Center(
                                  child: Card(
                                    color: Colors.pinkAccent,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 35.0),
                                            child: Theme(
                                              data: new ThemeData(
                                                primaryColor: Colors.white30,
                                                primaryColorDark:
                                                    Colors.white10,
                                                accentColor: Colors.white10,
                                              ),
                                              child: Stack(children: [
                                                Hero(
                                                  tag: "profile-image",
                                                  child: Container(
                                                    width: 140.0,
                                                    height: 140.0,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: (_image != null)
                                                            ? FileImage(_image)
                                                            : snapshot.data.documents[
                                                                            0][
                                                                        'url'] !=
                                                                    null
                                                                ? NetworkImage(
                                                                    snapshot.data
                                                                            .documents[0]
                                                                        ['url'])
                                                                : AssetImage(
                                                                    "images/profile.jpg"),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80.0),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 5.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    bottom: 5,
                                                    left: 5,
                                                    child: Stack(children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          40.0)),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 8,
                                                        top: 8,
                                                        child: InkWell(
                                                          onTap: () {
                                                            getImage();
                                                          },
                                                          child: Icon(
                                                            Icons.camera_alt,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      )
                                                    ]))
                                              ]),
                                            ),
                                          ),
                                          // name code
                                          SizedBox(height: 25.0),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                30, 0, 30, 0),
                                            child: TextFormField(
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                              controller: _name,
                                              textInputAction:
                                                  TextInputAction.next,
                                              focusNode: _nameFocus,
                                              onFieldSubmitted: (term) {
                                                _fieldFocusChange(context,
                                                    _nameFocus, _phoneFocus);
                                              },
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                    color: Colors.white70),
                                                labelStyle: TextStyle(
                                                    color: Colors.white70),

                                                // icon: Icon(Icons.person, color: Constants.primaryDark),
                                                labelText: 'First Name',
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        10, 10, 10, 10),
                                                // border: OutlineInputBorder(
                                                //   borderSide: BorderSide(color: Colors.white10),
                                                //   borderRadius: BorderRadius.circular(5),
                                                // ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),

                                          //email code
                                          SizedBox(height: 22.0),

                                          _buildButtons(context)
                                        ]),
                                  ),
                                ),
                              ])),
                            )
                          ]);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ]),
        ]));
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 16.0),
      child: InkWell(
        splashColor: Constants.primaryDark,
        onTap: !isLoading
            ? () async {
                print("inside on tap");
                setState(() {
                  dontSet = true;
                });
                if (_image == null && _name.text.length != 0) {
                  setState(() {
                    isLoading = true;
                  });
                  await _userCollection
                      .where("user_id",
                          isEqualTo: AuthenticationService.prefs
                              .get('user_id')
                              .toString())
                      .getDocuments()
                      .then((value) async {
                    print(value.documents.toString());
                    await _userCollection
                        .document(value.documents.single.documentID)
                        .updateData({'name': _name.text});
                  });

                  setState(() {
                    isLoading = false;
                  });
                }
                if (_name.text.length == 0) {
                  Fluttertoast.showToast(
                      msg: "name can't be empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                if (_image != null && _name.text.length != 0) {
                  setState(() {
                    isLoading = true;
                  });
                  await uploadImage();
                  print("title" + _name.text);
                  print("image" + _image.toString());

                  await _userCollection
                      .where("user_id",
                          isEqualTo: AuthenticationService.prefs
                              .get('user_id')
                              .toString())
                      .getDocuments()
                      .then((value) async {
                    print(value.documents.toString());
                    await _userCollection
                        .document(value.documents.single.documentID)
                        .updateData(
                            {'url': reportImageUrl, 'name': _name.text});
                  });

                  setState(() {
                    isLoading = false;
                  });
                }
                setState(() {
                  dontSet = false;
                });
                // Navigator.pop(context);
              }
            : () {},
        child: Container(
          height: 46.0,
          width: MediaQuery.of(context).size.width * .7,
          decoration: BoxDecoration(
            color: Constants.primaryLight,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 2.0,
              ),
            ],
            borderRadius: new BorderRadius.circular(30.0),
          ),
          child: Center(
            child: !isLoading
                ? Text(
                    "SAVE CHANGES",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      //  fontFamily: 'Montserrat',
                    ),
                  )
                : CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
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

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) async {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
