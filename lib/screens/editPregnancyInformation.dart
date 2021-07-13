import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:womenCare/services/firebaseAuthService.dart';
import 'package:time_machine/time_machine.dart';
import 'package:womenCare/utils/constants.dart';

class EditPregnancy extends StatefulWidget {
  final Function callBack;
  final int initValue;

  const EditPregnancy({Key key, this.callBack, this.initValue})
      : super(key: key);
  @override
  _EditPregnancyState createState() => _EditPregnancyState();
}

class _EditPregnancyState extends State<EditPregnancy> {
  final CollectionReference _userCollection =
      Firestore.instance.collection('users');
  bool flagLoading = true;
  int monthNum = 1;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      monthNum = widget.initValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.primaryDark,
          title: Text("Edit details"),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // height: MediaQuery.of(context).size.height * .3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        // height: MediaQuery.of(context).size.height * .3,
                        child: Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.pregnant_woman,
                                color: Colors.blue,
                                size: 40,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .05,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .07,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .72,
                                        child: Text(
                                          "How long have you been pregnant?",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.grey[700]),
                                          maxLines: 3,
                                        )),
                                  ]),
                            ],
                          ),
                          NumberPicker.integer(
                              initialValue: monthNum,
                              minValue: 1,
                              maxValue: 9,
                              onChanged: (value) {
                                setState(() {
                                  monthNum = value;
                                });
                              })
                        ]),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onPressed: !isLoading
                            ? () async {
                                try {
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
                                        .document(
                                            value.documents.single.documentID)
                                        .updateData({
                                      "month": monthNum,
                                      "timestamp": DateTime.now().toString()
                                    });
                                  });
                                  await widget.callBack();
                                  Navigator.pop(context);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  // getLastData();
                                } catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            : () {},
                        padding: EdgeInsets.all(9),
                        color: Colors.indigo,
                        child: !isLoading
                            ? Text('Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold))
                            : CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                      ),
                    ],
                  ),
                ),
              )
            ]));
  }
}
