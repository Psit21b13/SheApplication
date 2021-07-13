import 'dart:convert';
import 'dart:io';

// import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:womenCare/services/firebaseAuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:womenCare/utils/constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController _confPasswordController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode _confPasswordFocus = FocusNode();

  final FocusNode _stateFocus = FocusNode();

  final formKey = new GlobalKey<FormState>();
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

  int cycleValue = 25;

  final CollectionReference _userCollection =
      Firestore.instance.collection('users');

  String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Mobile Number is Required";
    } else if (value.length != 10) {
      return "Mobile number must 10 digits";
    } else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final img = Hero(
      tag: 'pg',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 70.0,
      ),
    );

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Constants.primaryDark,
          title: Text('Register',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          // backgroundColor:  Constants.primaryLight,
          // automaticallyImplyLeading: true,
          // leading: IconButton(
          //   icon: Icon(Icons.keyboard_arrow_left),
          //   color: Colors.white,
          //   iconSize: 40,
          //   onPressed: () {},

          // ),
        ),
        body: Container(
          child: Center(
            child: ListView(
              padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 20.0),
              children: <Widget>[
                // Center(
                //     child: Container(
                //   child: Text('She',
                //       style: TextStyle(
                //           fontSize: 50.0,
                //           fontWeight: FontWeight.bold,
                //           color:  Constants.primaryLight)),
                // )),
                // Container(
                //   padding: EdgeInsets.fromLTRB(110.0, 0.0, 0.0, 0.0),
                //   child: Text('all about her',
                //       style: TextStyle(
                //           fontSize: 22.0,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.black45)),
                // ),
                SizedBox(height: 0.0),
                Container(
                  child: Column(children: [
                    Stack(children: [
                      Hero(
                        tag: "profile-image",
                        child: Container(
                          width: 140.0,
                          height: 140.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: (_image != null)
                                  ? FileImage(_image)
                                  : AssetImage("images/profile.jpg"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(80.0),
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
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
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
                    new Form(
                        key: formKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(height: 25.0),

                            TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: _emailFocus,
                              controller: _email,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, _emailFocus, _nameFocus);
                              },
                              decoration: InputDecoration(
                                icon:
                                    Icon(Icons.mail, color: Constants.primaryLight),
                                labelText: 'Email Address*',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: _nameFocus,
                              controller: _nameController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter name';
                                }
                                return null;
                              },
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, _nameFocus, passwordFocus);
                              },
                              decoration: InputDecoration(
                                icon: Icon(Icons.person,
                                    color: Constants.primaryLight),
                                labelText: 'Name*',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: passwordFocus,
                              controller: passwordController,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, passwordFocus, _confPasswordFocus);
                              },
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a password ';
                                } else if (value.length < 6) {
                                  return 'password should be atleast 6 characters';
                                } 
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                icon: Icon(Icons.vpn_key,
                                    color: Constants.primaryLight),
                                labelText: 'Password*',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: _confPasswordFocus,
                              controller: _confPasswordController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please re-enter password ';
                                } else if (_confPasswordController.text !=
                                    passwordController.text) {
                                  return 'paswords should match';
                                }
                                return null;
                              },
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, _confPasswordFocus, _stateFocus);
                              },
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                icon: Icon(Icons.keyboard,
                                    color: Constants.primaryLight),
                                labelText: 'confirm password *',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            // Container(
                            //   // height: MediaQuery.of(context).size.height * .3,
                            //   child: Column(children: [
                            //     InkWell(
                            //       onTap: () {
                            //         showRoundedDatePicker(
                            //           context: context,
                            //           initialDate: DateTime.now(),
                            //           firstDate:
                            //               DateTime(DateTime.now().year - 1),
                            //           lastDate: DateTime(DateTime.now().year + 1),
                            //           borderRadius: 16,
                            //         ).then((value) => {
                            //               setState(() {
                            //                 _lastDate = value;
                            //               })
                            //             });
                            //       },
                            //       child: Row(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: <Widget>[
                            //           Icon(
                            //             MdiIcons.calendar,
                            //             color: Colors.blue,
                            //             // size: 35,
                            //           ),
                            //           SizedBox(
                            //             width: MediaQuery.of(context).size.width *
                            //                 .1,
                            //           ),
                            //           Column(
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.start,
                            //               children: [
                            //                 Container(
                            //                     height: MediaQuery.of(context)
                            //                             .size
                            //                             .height *
                            //                         .07,
                            //                     width: MediaQuery.of(context)
                            //                             .size
                            //                             .width *
                            //                         .72,
                            //                     child: Text(
                            //                       "Choose day your last period started",
                            //                       style: TextStyle(
                            //                           fontSize: 17,
                            //                           color: Colors.grey[700]),
                            //                       maxLines: 2,
                            //                     )),
                            //                 SizedBox(
                            //                   height: 10,
                            //                 ),
                            //                 Text(
                            //                   "${_lastDate != null ? DateFormat.yMMMd('en_US').format(DateTime.parse(_lastDate.toString())) : DateFormat.yMMMd('en_US').format(DateTime.parse(DateTime.now().toString()))}",
                            //                   style: TextStyle(fontSize: 21),
                            //                 ),
                            //                 // DateTimePicker(
                            //                 //   initialValue:
                            //                 //       DateTime.now().toString(),
                            //                 //   firstDate: DateTime(2000),
                            //                 //   // lastDate: DateTime(2100),
                            //                 //   dateLabelText: 'Date',
                            //                 //   onChanged: (val) => print(val),
                            //                 //   validator: (val) {
                            //                 //     print(val);
                            //                 //     return null;
                            //                 //   },
                            //                 //   onSaved: (val) => print(val),
                            //                 // ),
                            //               ]),
                            //         ],
                            //       ),
                            //     ),
                            //   ]),
                            // ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            // Container(
                            //   // height: MediaQuery.of(context).size.height * .3,
                            //   child: Column(children: [
                            //     Row(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: <Widget>[
                            //         Icon(
                            //           MdiIcons.bicycle,
                            //           color: Colors.blue,
                            //           // size: 35,
                            //         ),
                            //         SizedBox(height: 20.0),
                            //         SizedBox(
                            //           width:
                            //               MediaQuery.of(context).size.width * .1,
                            //         ),
                            //         Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.center,
                            //             children: [
                            //               Container(
                            //                   height: MediaQuery.of(context)
                            //                           .size
                            //                           .height *
                            //                       .07,
                            //                   width: MediaQuery.of(context)
                            //                           .size
                            //                           .width *
                            //                       .72,
                            //                   child: Text(
                            //                     "How many days on average is your cycle?",
                            //                     style: TextStyle(
                            //                         fontSize: 17,
                            //                         color: Colors.grey[700]),
                            //                     maxLines: 2,
                            //                   )),
                            //             ]),
                            //       ],
                            //     ),
                            //     NumberPicker.integer(
                            //         initialValue: cycleValue,
                            //         minValue: 0,
                            //         maxValue: 56,
                            //         onChanged: (value) {
                            //           setState(() {
                            //             cycleValue = value;
                            //           });
                            //         })
                            //   ]),
                            // ),

                            SizedBox(height: 20.0),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                onPressed: !isLoading
                                    ? () async {
                                        try {
                                          AuthenticationService authService =
                                              AuthenticationService();
                                          if (formKey.currentState.validate()) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            // Navigator.pushNamed(context, '/dashBoard');
                                            if (_image != null) {
                                              await uploadImage();
                                              print(
                                                  "image" + _image.toString());
                                              FirebaseUser user =
                                                  await authService
                                                      .signUpWithEmail(
                                                          email: _email.text,
                                                          password:
                                                              passwordController
                                                                  .text);
                                              print(user.uid);
                                              await _userCollection.add({
                                                'user_id': user.uid,
                                                'name': _nameController.text,
                                                'url': reportImageUrl
                                              });

                                              if (user != null) {
                                                Navigator.pop(context);
                                                Fluttertoast.showToast(
                                                    msg: "Sign Up successful",
                                                    backgroundColor:
                                                        Colors.grey);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "Sign Up unsuccessful",
                                                    backgroundColor:
                                                        Colors.grey);
                                              }
                                              setState(() {
                                                isLoading = false;
                                              });
                                            } else {
                                              FirebaseUser user =
                                                  await authService
                                                      .signUpWithEmail(
                                                          email: _email.text,
                                                          password:
                                                              passwordController
                                                                  .text);
                                              print(user.uid);
                                              await _userCollection.add({
                                                'user_id': user.uid,
                                                'name': _nameController.text
                                              });

                                              if (user != null) {
                                                Navigator.pop(context);
                                                Fluttertoast.showToast(
                                                    msg: "Sign Up successful",
                                                    backgroundColor:
                                                        Colors.grey);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "Sign Up unsuccessful",
                                                    backgroundColor:
                                                        Colors.grey);
                                              }
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          }
                                        } catch (e) {

                                         
                                        
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      }
                                    : () {},
                                padding: EdgeInsets.all(9),
                                color: Constants.primaryLight,
                                child: !isLoading
                                    ? Text('Sign up',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold))
                                    : CircularProgressIndicator(),
                              ),
                            ),
                            SizedBox(height: 40.0),

                            // FlatButton(
                            //     onPressed: () {},
                            //     // onPressed: () => launch("tel://08088835000"),
                            //     child: Row(
                            //       children: <Widget>[
                            //         Icon(Icons.phone_forwarded,
                            //             size: 27, color: Colors.green),
                            //         Text.rich(
                            //           TextSpan(
                            //             text:
                            //                 '  For more information contact us:\n ',
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.bold,
                            //                 color: Colors.grey[600],
                            //                 fontSize: 15), // default text style
                            //             children: <TextSpan>[
                            //               TextSpan(
                            //                   text: " 8899676509",
                            //                   style: TextStyle(
                            //                       fontWeight: FontWeight.bold,
                            //                       color: Colors.blue)),
                            //             ],
                            //           ),
                            //         ),
                            //       ],
                            //     )),
                          ],
                        )),
                  ]),
                ),
              ],
            ),
          ),
        ));
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
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
