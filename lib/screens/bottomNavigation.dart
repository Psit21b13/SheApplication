import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:mobistay/screens/Transaction_report/transaction_report_page.dart';
// import 'package:mobistay/screens/complaints/complaintmainpage.dart';
// import 'package:mobistay/screens/customer/manageCustomer.dart';
// import 'package:mobistay/screens/expense/expenseList.dart';

// import 'package:mobistay/screens/home_page_copy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:womenCare/screens/babyInfoPage.dart';
import 'package:womenCare/screens/diseaseInfoPage.dart';
import 'package:womenCare/screens/guestUserAlert.dart';
import 'package:womenCare/screens/periodsTrackerGuest.dart';
import 'package:womenCare/screens/periodsTrackerPage.dart';
import 'package:womenCare/screens/prescriptionPage.dart';
import 'package:womenCare/services/firebaseAuthService.dart';
import 'package:womenCare/utils/constants.dart';

class PageSelect extends StatefulWidget {
  final SharedPreferences prefs;
  final int page;

  static const String routeName = "/pageselect";
  PageSelect({Key key, this.prefs, this.page}) : super(key: key);

  @override
  _PageSelectState createState() => _PageSelectState();
}

class _PageSelectState extends State<PageSelect> {
  PageController _pageController;
  int _page;
  GlobalKey _bottomNavigationKey = GlobalKey();
  DateTime currentBackPressTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.page != null) {
      _page = widget.page;
      _pageController = PageController(
        initialPage: widget.page,
        keepPage: true,
      );
    } else {
      _page = 2;
      _pageController = PageController(
        initialPage: _page,
        keepPage: true,
      );
    }
  }

  void loadpage() {
    _pageController.jumpToPage(2);
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (_page == 2) {
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(
            msg: "Press Back Again to Exit", backgroundColor: Colors.grey);
        return Future.value(false);
      }
      return Future.value(true);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => PageSelect()));
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: onWillPop,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: onPageChanged,
            children: <Widget>[
              DiseasePage(),
              AuthenticationService.prefs.getBool('login_status')
                  ? BabyInfoPage()
                  : GustUserAlert(
                      prescription: false,
                    ),
              AuthenticationService.prefs.getBool('login_status')
                  ? PeriodsTrackerPage()
                  : GuestPeriodsTrackerPage(),
              AuthenticationService.prefs.getBool('login_status')
                  ? ReportPage()
                  : GustUserAlert(
                      prescription: true,
                    )
            ],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: (widget.page != null) ? widget.page : _page,
          height: 50.0,
          items: <Widget>[
            Icon(MdiIcons.medicalBag, size: 30),
            Icon(MdiIcons.babyCarriage, size: 30),
            Icon(MdiIcons.clock, size: 30),
            Icon(MdiIcons.chartLine, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Constants.primaryDark,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 500),
          onTap: (index) {
            setState(() {
              _page = index;
              print(index);
              _pageController.jumpToPage(
                index,
              );
            });
          },
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
