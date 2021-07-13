import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:womenCare/models/reportModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:womenCare/screens/newPrescription.dart';
import 'package:womenCare/services/firebaseAuthService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:womenCare/utils/constants.dart';
import 'package:womenCare/utils/customer_app_theme.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:womenCare/widgets/customeDrawer.dart';
import 'package:womenCare/widgets/reportListView.dart';

class ReportPage extends StatefulWidget {
  final Map<String, dynamic> fNewBodyLocal;
  final String fUri;
  final flag;
  static const String routeName = "/transactionreportpage";

  const ReportPage({Key key, this.fNewBodyLocal, this.fUri, this.flag})
      : super(key: key);

  @override
  ReportPageState createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  AnimationController animationController;
  // List<TransactionReportdata> itemList = TransactionReportdata.customerList;

  final ScrollController _scrollController = ScrollController();
  TextEditingController _title = TextEditingController();
  // List<Report> itemList;
  int lCount;
  Future<List<Report>> futureitemList;
  List<Report> itemList;
  double width;

  // List<DocumentSnapshot> snapshot.data.documents;
  int total;
  final spinkit = SpinKitWanderingCubes(
    size: 40,
    color: Colors.blue.shade500,
  );
  final spinkitCube = SpinKitThreeBounce(
    color: Colors.blue,
    size: 20,
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    itemList = getitemList();
    // getAllReports().then((QuerySnapshot doc) {
    //   if (doc.documents.isNotEmpty) {
    //     setState(() {
    //       print("all set got all documents");
    //       snapshot.data.documents = doc.documents;
    //       total = snapshot.data.documents.length;
    //     });
    //   }
    // });
    print("user id in report page--->" +
        AuthenticationService.prefs.get('user_id').toString());
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Theme(
      data: CustomerAppTheme.buildLightTheme(),
      child: Stack(children: [
        Container(
          child: Scaffold(
            drawer: CustomeDrawer(),
            appBar: AppBar(
              title: Text("prescription Report"),
              centerTitle: false,
              backgroundColor: Constants.primaryDark,
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  // color: Constants.primaryDark,
                  // decoration: new BoxDecoration(
                  //     gradient: new LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     Constants.gradientDark,
                  //     Constants.gradientLight,
                  //   ],
                  // )),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: NestedScrollView(
                          controller: _scrollController,
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return Column(
                                    children: <Widget>[
                                      //getSearchBarUI(),
                                    ],
                                  );
                                }, childCount: 1),
                              ),
                              SliverPersistentHeader(
                                pinned: false,
                                floating: true,
                                delegate: ContestTabHeader(getFilterBarUI()),
                              ),
                            ];
                          },
                          body: Container(
                          
                            color: CustomerAppTheme.buildLightTheme()
                                .backgroundColor,
                            child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection('prescriptions')
                                  .where("user_id",
                                      isEqualTo: AuthenticationService.prefs
                                          .get('user_id')
                                          .toString())
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    itemCount: snapshot.data.documents.length,
                                    padding: const EdgeInsets.only(top: 15),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final int count =
                                          snapshot.data.documents.length > 10
                                              ? 10
                                              : snapshot.data.documents.length;
                                      final Animation<double> animation =
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(
                                                  parent: animationController,
                                                  curve: Interval(
                                                      (1 / count) * index, 1.0,
                                                      curve: Curves
                                                          .fastOutSlowIn)));
                                      animationController.forward();
                                      return ReportListView(
                                        callback: () {},
                                        tranData: Report(
                                          name: snapshot.data.documents[index]
                                              .data['title'],
                                          date: snapshot.data.documents[index]
                                              .data['date'],
                                          url: snapshot.data.documents[index]
                                              .data['url'],
                                        ),
                                        doc: snapshot.data.documents[index],
                                        animation: animation,
                                        animationController:
                                            animationController,
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator(
                                    backgroundColor: Colors.blue,
                                  ));
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 25.0, right: 10),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: Color(0xff1a2a6c),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewPrescription()));
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget getListUI() {
    return Container(
      decoration: BoxDecoration(
        color: CustomerAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, -2),
              blurRadius: 8.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 156 - 50,
            child: FutureBuilder<bool>(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  return ListView.builder(
                    itemCount: itemList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      final int count =
                          itemList.length > 10 ? 10 : itemList.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                      animationController.forward();

                      return ReportListView(
                        callback: () {},
                        tranData: itemList[index],
                        animation: animation,
                        animationController: animationController,
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget getAllocationViewList() {
    final List<Widget> tranPageViews = <Widget>[];
    for (int i = 0; i < itemList.length; i++) {
      final int count = itemList.length;
      final Animation<double> animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval((1 / count) * i, 1.0, curve: Curves.fastOutSlowIn),
        ),
      );
      tranPageViews.add(
        ReportListView(
          callback: () {},
          tranData: itemList[i],
          animation: animation,
          animationController: animationController,
        ),
      );
    }
    animationController.forward();
    return Column(
      children: tranPageViews,
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: CustomerAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {},
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor:
                        CustomerAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xfff80759),
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.search,
                      size: 22,
                      color:
                          CustomerAppTheme.buildLightTheme().backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: CustomerAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
        
          color: CustomerAppTheme.buildLightTheme().backgroundColor,
      
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 16, top: 8, bottom: 0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('prescriptions')
                              .where("user_id",
                                  isEqualTo: AuthenticationService.prefs
                                      .get('user_id')
                                      .toString())
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return Center(child: spinkitCube);
                            } else {
                              return Text(
                                'Total priscriptions :\t${snapshot.data.documents.length}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xff1a2a6c)
                                  
                                    ),
                              );
                            }
                          },
                        ))),
                Material(
                  color: Colors.transparent,
                  child: widget.flag == null
                      ? InkWell(
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.grey.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                          onTap: () {
                            // FocusScope.of(context).requestFocus(FocusNode());
                            // Navigator.push<dynamic>(
                            //   context,
                            //   MaterialPageRoute<dynamic>(
                            //       builder: (BuildContext context) =>
                            //           TransactionFilterScreen(),
                            //       fullscreenDialog: true),
                            // );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: <Widget>[
                                // Text(
                                //   'Filter',
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.bold,
                                //     fontSize: 18,
                                //     color: Colors.blue,
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Icon(Icons.sort, color: Color(0xfff80759)),
                                // ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  List<Report> getitemList() {
    return [
      Report(
          date: DateFormat("dd-MM-yyyy").format(DateTime.now()),
          name: "daily checkup",
          url:
              "https://5.imimg.com/data5/NI/BH/MY-3360774/gst-bill-2finvoice-book-500x500.jpg")
    ];
  }

  Future<QuerySnapshot> getAllReports() {
    print("called get data on collection prescriptions");
    return Firestore.instance
        .collection('prescriptions')
        .where("user_id",
            isEqualTo: AuthenticationService.prefs.get('user_id').toString())
        .getDocuments();
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );

  final Widget searchUI;

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }
}
