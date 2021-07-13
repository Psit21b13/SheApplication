import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:womenCare/services/firebaseAuthService.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:womenCare/utils/constants.dart';

class EditPeriodsDetails extends StatefulWidget {
  final Function callBack;
  final bool fromGuest;

  const EditPeriodsDetails({Key key, this.callBack, this.fromGuest = false})
      : super(key: key);
  @override
  _EditPeriodsDetailsState createState() => _EditPeriodsDetailsState();
}

class _EditPeriodsDetailsState extends State<EditPeriodsDetails> {
  DateTime _lastDate = DateTime.now();
  bool isLoading = false;
  bool isLoadingData = true;
  int cycleValue = 25;
  final CollectionReference _userCollection =
      Firestore.instance.collection('users');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLastData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Details"),
        backgroundColor: Constants.primaryDark,
      ),
      body: !isLoadingData
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height * .3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              showRoundedDatePicker(
                                context: context,
                                initialDate: widget.fromGuest
                                    ? DateTime.parse(AuthenticationService.prefs
                                        .get('last_date'))
                                    : _lastDate,
                                firstDate: DateTime(DateTime.now().year - 1),
                                lastDate:
                                    DateTime.now(),
                                borderRadius: 16,
                              ).then((value) => {
                                    setState(() {
                                      if (value != null) {
                                        _lastDate = value;
                                      }
                                    })
                                  });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  MdiIcons.calendar,
                                  color: Colors.blue,
                                  // size: 35,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .1,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .07,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .72,
                                          child: Text(
                                            "Choose day your last period started",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey[700]),
                                            maxLines: 2,
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${_lastDate != null ? DateFormat.yMMMd('en_US').format(DateTime.parse(_lastDate.toString())) : DateFormat.yMMMd('en_US').format(DateTime.parse(DateTime.now().toString()))}",
                                        style: TextStyle(fontSize: 21),
                                      ),
                                    ]),
                              ],
                            ),
                          ),
                        ]),
                  ),
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
                            MdiIcons.bicycle,
                            color: Colors.blue,
                            // size: 35,
                          ),
                          SizedBox(height: 20.0),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .1,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        .07,
                                    width:
                                        MediaQuery.of(context).size.width * .72,
                                    child: Text(
                                      "How many days on average is your cycle?",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey[700]),
                                      maxLines: 2,
                                    )),
                              ]),
                        ],
                      ),
                      NumberPicker.integer(
                          initialValue: cycleValue,
                          minValue: 0,
                          maxValue: 56,
                          onChanged: (value) {
                            setState(() {
                              cycleValue = value;
                            });
                          })
                    ]),
                  ),
                  SizedBox(height: 20.0),
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
                              if (widget.fromGuest) {
                                AuthenticationService.prefs.setString(
                                    'last_date', _lastDate.toString());
                                AuthenticationService.prefs
                                    .setInt('cycles', cycleValue);
                              } else {
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
                                    'last_date': _lastDate.toString(),
                                    'cycles': cycleValue
                                  });
                                });
                              }

                              widget.callBack();
                              setState(() {
                                isLoading = false;
                              });
                              getLastData();
                              Navigator.pop(context);
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<void> getLastData() async {
    if (widget.fromGuest) {
      setState(() {
        _lastDate =
            DateTime.parse(AuthenticationService.prefs.get('last_date'));
        cycleValue = AuthenticationService.prefs.getInt('cycles');
      });
      isLoadingData = false;
      return;
    }
    setState(() {
      isLoadingData = true;
    });
    await _userCollection
        .where("user_id",
            isEqualTo: AuthenticationService.prefs.get('user_id').toString())
        .getDocuments()
        .then((value) async {
      print(value.documents.toString());
      setState(() {
        _lastDate = DateTime.parse(value.documents.single.data['last_date']);
        cycleValue = value.documents.single.data['cycles'];
        print(cycleValue);
        isLoadingData = false;
      });
    });
  }
}
