import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:womenCare/utils/constants.dart';
import 'package:womenCare/utils/customer_app_theme.dart';
import 'package:womenCare/models/reportModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportListView extends StatefulWidget {
  const ReportListView(
      {Key key,
      this.tranData,
      this.animationController,
      this.animation,
      this.callback,
      this.doc})
      : super(key: key);

  final Animation<dynamic> animation;
  final AnimationController animationController;
  final VoidCallback callback;
  final Report tranData;
  final DocumentSnapshot doc;

  @override
  _ReportListViewState createState() => _ReportListViewState();
}

class _ReportListViewState extends State<ReportListView> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () => {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              color: CustomerAppTheme.buildLightTheme()
                                  .backgroundColor,
                              child: Row(
                                children: <Widget>[
                                  Padding(padding: const EdgeInsets.all(8)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
                                    child: Material(
                                      elevation: 10,
                                      shape: CircleBorder(),
                                      child: Container(
                                        height: 60,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Constants.primaryDark,
                                          shape: BoxShape.circle,
                                        ),
                                        child: _buildProfileImage(
                                            context, widget.tranData.url),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 20, bottom: 30),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .35,
                                                  child: Text(
                                                    widget.tranData.name,
                                                    style: TextStyle(
                                                        inherit: true,
                                                        // fontFamily: 'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16.0),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: 90,
                                                  child: Text(
                                                      widget.tranData.date,
                                                      style: TextStyle(
                                                          inherit: true,
                                                          // fontFamily:
                                                          //     'Montserrat',
                                                          fontSize: 14.0,
                                                          color:
                                                              Colors.black54)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          top: 17,
                                          bottom: 30,
                                          right: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "",
                                            style: TextStyle(
                                                inherit: true,
                                                // fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16.0),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("",
                                                  style: TextStyle(
                                                      inherit: true,
                                                      //  fontFamily: 'Montserrat',
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black)),
                                              Text("",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      inherit: true,
                                                      // fontFamily: 'Montserrat',
                                                      fontSize: 14.0,
                                                      color: Colors.black54)),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  !isLoading
                                      ? IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Confirm"),
                                                  content: Text(
                                                      "Are you sure you want to delete this prescription?"),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text("Cancel"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text("Confirm"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        deleteItem();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.blue,
                                              )),
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteItem() async {
    setState(() {
      isLoading = true;
    });
    await Firestore.instance
        .collection("prescriptions")
        .document(widget.doc.documentID)
        .delete();
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildProfileImage(context, String url) {
    return Center(
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                    backgroundColor: Colors.transparent,
                    child: PhotoView(
                      backgroundDecoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      imageProvider: NetworkImage(url),
                    ),
                  ));
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(0.0),
            border: Border.all(
              color: Colors.grey,
              width: .5,
            ),
          ),
        ),
      ),
    );
  }
}
