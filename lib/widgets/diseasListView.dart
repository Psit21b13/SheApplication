import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DiseasListView extends StatefulWidget {
  const DiseasListView({
    Key key,
    this.animationController,
    this.animation,
    this.url,
    this.desc,
    this.title,
  }) : super(key: key);
  final String url;
  final String desc;
  final String title;

  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  _DiseasListViewState createState() => _DiseasListViewState();
}

class _DiseasListViewState extends State<DiseasListView> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // print(date);
    // var difference = DateTime.now().difference(date);
    // DateTime uploadtime = DateTime.now().subtract(difference);
    // String datevalue = timeago.format(uploadtime, locale: 'en');
    // File _imageFile;
    // bool isLoading = false;
    //Create an instance of ScreenshotController
    // ScreenshotController screenshotController = ScreenshotController();
    // if (DateTime(date.year, date.month, date.day) ==
    //     DateTime(today.year, today.month, today.day)) {
    //   datevalue = DateFormat('HH:mm').format(date);
    // } else {
    //   datevalue = DateFormat('EEE dd yyyy').format(date);
    // }

    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      offset: const Offset(4, 4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2,
                              child: Image.network(
                                widget.url,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              color: Color(0xFFFFFFFF),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, top: 8, bottom: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  widget.title,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    widget.desc,
                                                    textAlign: TextAlign.left,
                                                    // maxLines: 8,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey
                                                            .withOpacity(0.8)),
                                                  ),
                                                )
                                                // Row(
                                                //   crossAxisAlignment:
                                                //       CrossAxisAlignment.center,
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.start,
                                                //   children: <Widget>[
                                                //     Text(
                                                //       news["desc"],
                                                //       style: TextStyle(
                                                //           fontSize: 14,
                                                //           color: Colors.grey
                                                //               .withOpacity(0.8)),
                                                //     ),
                                                //     const SizedBox(
                                                //       width: 4,
                                                //     ),
                                                //     Icon(
                                                //       FontAwesomeIcons.mapMarkerAlt,
                                                //       size: 12,
                                                //       color: Color(0xff54D3C2),
                                                //     ),
                                                //     Expanded(
                                                //       child: Text(
                                                //         '${news["desc"].substring(10)}...',maxLines: 4,
                                                //         overflow:
                                                //             TextOverflow.ellipsis,
                                                //         style: TextStyle(
                                                //             fontSize: 14,
                                                //             color: Colors.grey
                                                //                 .withOpacity(0.8)),
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                                // Padding(
                                                //   padding:
                                                //       const EdgeInsets.only(top: 4),
                                                //   child: Row(
                                                //     children: <Widget>[
                                                //       // SmoothStarRating(
                                                //       //   allowHalfRating: true,
                                                //       //   starCount: 5,
                                                //       //   rating: hotelData.rating,
                                                //       //   size: 20,
                                                //       //   color: HotelAppTheme
                                                //       //           .buildLightTheme()
                                                //       //       .primaryColor,
                                                //       //   borderColor: HotelAppTheme
                                                //       //           .buildLightTheme()
                                                //       //       .primaryColor,
                                                //       // ),
                                                //       Text(
                                                //         ' ${hotelData.reviews} Reviews',
                                                //         style: TextStyle(
                                                //             fontSize: 14,
                                                //             color: Colors.grey
                                                //                 .withOpacity(0.8)),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       right: 16, top: 8),
                                      //   child: Column(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.center,
                                      //     crossAxisAlignment:
                                      //         CrossAxisAlignment.end,
                                      //     children: <Widget>[
                                      //       Text(
                                      //         '\$${hotelData.perNight}',
                                      //         textAlign: TextAlign.left,
                                      //         style: TextStyle(
                                      //           fontWeight: FontWeight.w600,
                                      //           fontSize: 22,
                                      //         ),
                                      //       ),
                                      //       Text(
                                      //         '/per night',
                                      //         style: TextStyle(
                                      //             fontSize: 14,
                                      //             color:
                                      //                 Colors.grey.withOpacity(0.8)),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      // Row(
                                      //   children: <Widget>[
                                      //     Padding(
                                      //       padding: const EdgeInsets.only(
                                      //           right: 5.0),
                                      //       child: Icon(
                                      //         MdiIcons.calendar,
                                      //         color: Colors.grey,
                                      //       ),
                                      //     ),
                                      //     // Text(datevalue)
                                      //   ],
                                      // ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
