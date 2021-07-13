import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:womenCare/screens/editPregnancyInformation.dart';
import 'package:womenCare/services/firebaseAuthService.dart';
import 'package:time_machine/time_machine.dart';
import 'package:womenCare/utils/constants.dart';
import 'package:womenCare/widgets/customeDrawer.dart';

class BabyInfoPage extends StatefulWidget {
  @override
  _BabyInfoPageState createState() => _BabyInfoPageState();
}

class _BabyInfoPageState extends State<BabyInfoPage>
    with SingleTickerProviderStateMixin {
  // AnimationController _animationController;
  int currentValue;
  bool flag = true;
  bool flagLoading = true;
  int monthNum = 1;
  bool isLoading = false;
  Map<int, String> monthMap = {
    1: "First",
    2: "Second",
    3: "Third",
    4: "Fourth",
    5: "Fifth",
    6: "Sixth",
    7: "Seventh",
    8: "Eigth",
    9: "Ninth",
  };
  final CollectionReference _userCollection =
      Firestore.instance.collection('users');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 10),
    // );

    // _animationController.addListener(() => setState(() {}));
    // _animationController.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final percentage = _animationController.value * 100;
    final _size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: CustomeDrawer(),
        appBar: AppBar(
          title: Text("pregnancy information"),
          centerTitle: false,
          backgroundColor: Constants.primaryDark,
          actions: <Widget>[
            !flag && currentValue != null
                ? IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPregnancy(
                                    callBack: getUserDetails,
                                    initValue: currentValue,
                                  )));
                    })
                : Container()
          ],
        ),
        body: !flag
            ? Stack(children: [
                Container(
                  height: _size.height,
                  width: _size.width,
                  // decoration: new BoxDecoration(
                  //     gradient: new LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     Constants.gradientDark,
                  //     Constants.gradientLight,
                  //   ],
                  // )),
                  // color: COlors.gr,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              height: 180,
                              child: Card(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: double.infinity,
                                          height: 75.0,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24.0),
                                          child: LiquidLinearProgressIndicator(
                                            borderWidth: 1,
                                            borderColor: Colors.black,
                                            value: currentValue / 10,
                                            backgroundColor: Colors.white,
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.blue),
                                            borderRadius: 12.0,
                                            center: Text(
                                              'Current month ${currentValue.toString()}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color:
                                                      Colors.lightBlueAccent),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              'change month ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          DropdownButton<int>(
                                            value: monthNum,
                                            icon: Icon(Icons.arrow_downward),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: TextStyle(
                                                color: Colors.deepPurple),
                                            underline: Container(
                                              height: 2,
                                              color: Colors.deepPurpleAccent,
                                            ),
                                            onChanged: (int newValue) {
                                              setState(() {
                                                monthNum = newValue;
                                              });
                                            },
                                            items: <int>[
                                              1,
                                              2,
                                              3,
                                              4,
                                              5,
                                              6,
                                              7,
                                              8,
                                              9
                                            ].map<DropdownMenuItem<int>>(
                                                (int value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          StreamBuilder(
                              stream: Firestore.instance
                                  .collection("pregnancy")
                                  .where("month", isEqualTo: monthNum)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data.documents.length != 0
                                      ? Column(
                                          children: <Widget>[
                                            Container(
                                                width: _size.width,
                                                child: Card(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Image.network(
                                                        snapshot.data
                                                                .documents[0]
                                                            ['baby_url'],
                                                        fit: BoxFit.cover,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment: 
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              "${monthMap[monthNum]} month of pregnancy",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              snapshot.data
                                                                      .documents[0]
                                                                  ['baby_desc'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            Container(
                                                width: _size.width,
                                                child: Card(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Image.network(
                                                        snapshot.data
                                                                .documents[0]
                                                            ['food_url'],
                                                        fit: BoxFit.cover,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              "pregnancy diet for this month",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              snapshot.data
                                                                      .documents[0]
                                                                  ['food_desc'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        )
                                      : Container();
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 130),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              }),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ])
            : !flagLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        SizedBox(
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              // height: MediaQuery.of(context).size.height * .3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    // height: MediaQuery.of(context).size.height * .3,
                                    child: Column(children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.pregnant_woman,
                                            color: Colors.blue,
                                            size: 40,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .05,
                                          ),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .07,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .72,
                                                    child: Text(
                                                      "How long have you been pregnant?",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color:
                                                              Colors.grey[700]),
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
                                              await _userCollection
                                                  .where("user_id",
                                                      isEqualTo:
                                                          AuthenticationService
                                                              .prefs
                                                              .get('user_id')
                                                              .toString())
                                                  .getDocuments()
                                                  .then((value) async {
                                                print(
                                                    value.documents.toString());
                                                await _userCollection
                                                    .document(value.documents
                                                        .single.documentID)
                                                    .updateData({
                                                  "month": monthNum,
                                                  "timestamp":
                                                      DateTime.now().toString()
                                                });
                                              });
                                              await getUserDetails();
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
                          ),
                        )
                      ])
                : Center(child: CircularProgressIndicator()));
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    Map<String, dynamic> documentData;
    print("called get data on collection users");
    await _userCollection
        .where("user_id",
            isEqualTo: AuthenticationService.prefs.get('user_id').toString())
        .getDocuments()
        .then((value) {
      print(value.documents.toString());
      documentData = value.documents.single.data;
    });
    print("doc data-->" + documentData.toString());
    if (documentData['month'] != null) {
      setState(() {
        LocalDate a = LocalDate.today();
        LocalDate b =
            LocalDate.dateTime(DateTime.parse(documentData['timestamp']));
        Period diff = b.periodSince(a);
        print("moth diff ---->" + diff.months.toString());
        currentValue =
            diff.months <= 9 ? documentData['month'] + diff.months : 9;
        monthNum = currentValue;
        flag = false;
      });
    } else {
      setState(() {
        flagLoading = false;
      });
    }
    return documentData;
  }
}
