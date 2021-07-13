import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:womenCare/screens/editProfile.dart';
import 'package:womenCare/screens/loginPage.dart';
import 'package:womenCare/services/firebaseAuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:womenCare/utils/constants.dart';

class CustomeDrawer extends StatefulWidget {
  @override
  _CustomeDrawerState createState() => _CustomeDrawerState();
}

class _CustomeDrawerState extends State<CustomeDrawer> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          StreamBuilder(
              stream: Firestore.instance
                  .collection("users")
                  .where("user_id",
                      isEqualTo: AuthenticationService.prefs.get('user_id'))
                  .snapshots(),
              builder: (context, snapshot) {
                return UserAccountsDrawerHeader(
                    currentAccountPicture: AuthenticationService.prefs
                                .getBool('login_status') &&
                            snapshot.hasData &&
                            snapshot.data.documents[0]['url'] != null
                        ? Hero(
                            tag: "profile-image",
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                  "${snapshot.data.documents[0]['url']}"),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: AssetImage("images/profile.jpg"),
                          ),
                    decoration: BoxDecoration(color: Constants.primaryLight),
                    accountName:
                        AuthenticationService.prefs.getBool('login_status') &&
                                snapshot.hasData &&
                                snapshot.data.documents[0]['name'] != null
                            ? Text(snapshot.data.documents[0]['name'])
                            : Text("user"),
                    accountEmail:
                        AuthenticationService.prefs.getBool('login_status')
                            ? Text(AuthenticationService.prefs.get('email'))
                            : Text("register to make use of all features"));
              }),
          InkWell(
            onTap: () {
              if (!AuthenticationService.prefs.get('login_status')) {
                Fluttertoast.showToast(
                    msg: "Please Sign Up", backgroundColor: Colors.grey);
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()));
              }
            },
            splashColor: Colors.black12,
            child: ListTile(
              leading: Icon(MdiIcons.accountEdit),
              title: Text("Edit profile"),
            ),
          ),
          InkWell(
            onTap: !isLoading
                ? () async {
                    // FirebaseAuth.instance.currentUser() == null ? then not logged in
                    setState(() {
                      isLoading = true;
                    });
                    await AuthenticationService.prefs
                        .setBool('login_status', false);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                : () {},
            splashColor: Colors.black12,
            child: ListTile(
              leading: Icon(MdiIcons.logout),
              title: !isLoading
                  ? Text("Logout")
                  : Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator())),
            ),
          )
        ],
      ),
    );
  }
}
