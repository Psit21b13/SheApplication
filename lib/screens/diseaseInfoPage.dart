import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:womenCare/utils/constants.dart';
import 'package:womenCare/widgets/customeDrawer.dart';
import 'package:womenCare/widgets/diseasListView.dart';

class DiseasePage extends StatefulWidget {
  @override
  _DiseasePageState createState() => _DiseasePageState();
}

class _DiseasePageState extends State<DiseasePage>
    with TickerProviderStateMixin {
  double width, height;
  // NewsModel newsModelGlobal;

  AnimationController animationController;

  final ScrollController _scrollController = ScrollController();

  var news = [
    {
      "imgpath":
          "https://nikonrumors.com/wp-content/uploads/2019/10/Nikon-Z-Noct-Nikkor-58mm-f0.95-lens-sample-photos-4.jpg",
      "title": "Latest Covid updates",
      "desc":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "date": "6/20/2020, 1:46:28 AM"
    },
    {
      "imgpath":
          "https://nikonrumors.com/wp-content/uploads/2019/10/Nikon-Z-Noct-Nikkor-58mm-f0.95-lens-sample-photos-4.jpg",
      "title": "Latest Covid updates",
      "desc":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "date": "6/19/2020, 1:46:28 AM"
    },
    {
      "imgpath":
          "https://nikonrumors.com/wp-content/uploads/2019/10/Nikon-Z-Noct-Nikkor-58mm-f0.95-lens-sample-photos-4.jpg",
      "title": "Latest Covid updates",
      "desc":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "date": "6/20/2020, 1:46:28 AM"
    },
    {
      "imgpath":
          "https://nikonrumors.com/wp-content/uploads/2019/10/Nikon-Z-Noct-Nikkor-58mm-f0.95-lens-sample-photos-4.jpg",
      "title": "Latest Covid updates",
      "desc":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "date": "6/20/2020, 1:46:28 AM"
    },
    {
      "imgpath":
          "https://nikonrumors.com/wp-content/uploads/2019/10/Nikon-Z-Noct-Nikkor-58mm-f0.95-lens-sample-photos-4.jpg",
      "title": "Latest Covid updates",
      "desc":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "date": "6/19/2020, 1:46:28 AM"
    },
    {
      "imgpath":
          "https://nikonrumors.com/wp-content/uploads/2019/10/Nikon-Z-Noct-Nikkor-58mm-f0.95-lens-sample-photos-4.jpg",
      "title": "Latest Covid updates",
      "desc":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "date": "6/20/2020, 1:46:28 AM"
    },
  ];

  String desc =
      "With the highest single-day increase of 12,881 COVID-19 cases reported in the last 24 hours, India's coronavirus count crossed 3.66 lakh.The death toll has gone up to 12,237 in the country with 334 persons succumbing to the infection on Thursday.Maharashtra also recorded the highest single-day spike of 3,7200 Covid-19 cases. However, the death toll came down to 200 from 178 recorded on June 15.Of the total 200 fatalities on Thursday, Mumbai notched 67 deaths, taking the city's death toll to 3,311.Meanwhile, the Brihanmumbai Municipal Corporation (BMC) has said that it did not hide any information related to the previous 862 COVID-19 deaths, which were added to the fatality count on June 16.";

  @override
  void initState() {
    // TODO: implement initState

    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        drawer: CustomeDrawer(),
        appBar: AppBar(
          backgroundColor: Constants.primaryDark,
          title: Text(
            "Disease information",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
            height: height,
            width: width,
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Constants.gradientDark,
                Constants.gradientLight,
              ],
            )),
            child: Container(
                color: Color(0xFFFFFFFF),
                // decoration: new BoxDecoration(
                //     gradient: new LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     Constants.gradientDark,
                //     Constants.gradientLight,
                //   ],
                // )),
                child: StreamBuilder(
                    stream:
                        Firestore.instance.collection("disease").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          padding: const EdgeInsets.only(top: 8, bottom: 40),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            final int count =
                                snapshot.data.documents.length > 10
                                    ? 10
                                    : snapshot.data.documents.length;
                            final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: animationController,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn)));
                            animationController.forward();
                            return DiseasListView(
                              animation: animation,
                              animationController: animationController,
                              title: snapshot.data.documents[index]['title'],
                              url: snapshot.data.documents[index]['url'],
                              desc: snapshot.data.documents[index]['desc'],
                            );
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }))));
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
    this.size,
  );
  final Widget searchUI;
  final Size size;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => size.height * .35;

  @override
  double get minExtent => size.height * .35;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
