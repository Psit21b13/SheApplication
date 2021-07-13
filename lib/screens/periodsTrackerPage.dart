import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:womenCare/screens/editPeriodsDetails.dart';
import 'package:womenCare/services/firebaseAuthService.dart';
import 'package:womenCare/utils/constants.dart';
import 'package:womenCare/utils/scrollBehavior.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:womenCare/utils/showNotification.dart';
import 'package:womenCare/widgets/customeDrawer.dart';
import 'package:womenCare/widgets/periodsDetailsPicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class PeriodsTrackerPage extends StatefulWidget {
  PeriodsTrackerPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PeriodsTrackerPageState createState() => _PeriodsTrackerPageState();
}

class _PeriodsTrackerPageState extends State<PeriodsTrackerPage>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  bool showPickers;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    getUserDetails().then((doc) {
      if (doc['last_date'] != null && doc['cycles'] != null) {
        setAllEvents(
            lastDate: DateTime.parse(doc['last_date']),
            period: doc['cycles'],
            n: 12 * 5);
        setState(() {
          showPickers = false;
          // print("next date is --->"+);
        });
      } else {
        setState(() {
          showPickers = true;
        });
      }
    });
    _selectedEvents = [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List list) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  Map<DateTime, List> _holidays = {
    DateTime(2019, 1, 1): ['New Year\'s Day'],
    DateTime(2019, 1, 6): ['Epiphany'],
    DateTime(2019, 2, 14): ['Valentine\'s Day'],
    DateTime(2019, 4, 21): ['Easter Sunday'],
    DateTime(2019, 4, 22): ['Easter Monday'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomeDrawer(),
      appBar: AppBar(
        backgroundColor: Constants.primaryDark,
        title: Text("Periods Tracker"),
        actions: <Widget>[
          showPickers != null && showPickers != true
              ? Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: InkWell(
                    onTap: () {
                      print("clicked");
                      // _showNotification();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPeriodsDetails(
                                    callBack: startCallForDetails,
                                  )));
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container()
        ],
      ),
      body: showPickers != null
          ? showPickers
              ? PeriodsDetailsPicker(
                  callBack: startCallForDetails,
                )
              : _events != null
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // Switch out 2 lines below to play with TableCalendar's settings
                        //-----------------------
                        TableCalendar(
                          calendarController: _calendarController,
                          events: _events,
                          // holidays: _holidays,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          calendarStyle: CalendarStyle(
                            selectedColor: Colors.blue[400],
                            todayColor: Colors.blue[200],
                            markersColor: Constants.primaryLight,
                            outsideDaysVisible: false,
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonTextStyle: TextStyle()
                                .copyWith(color: Colors.white, fontSize: 15.0),
                            formatButtonDecoration: BoxDecoration(
                              color: Colors.blueAccent[400],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          onDaySelected: _onDaySelected,
                          onVisibleDaysChanged: _onVisibleDaysChanged,
                          onCalendarCreated: _onCalendarCreated,
                        ),
                        // _buildTableCalendarWithBuilders(),
                        const SizedBox(height: 8.0),
                        // _buildButtons(),
                        const SizedBox(height: 8.0),
                        Expanded(child: _buildEventList()),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    )
          : Center(child: CircularProgressIndicator()),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  // Widget _buildTableCalendar() {
  //   return null
  //   }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'pl_PL',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events, list) {
        _onDaySelected(date, events, list);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text(
              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView(
        children: _selectedEvents
            .map((event) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.8),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(event.toString()),
                    onTap: () => print('$event tapped!'),
                  ),
                ))
            .toList(),
      ),
    );
  }

  void setAllEvents({int n = 12, DateTime lastDate, int period}) {
    Map<DateTime, List> lEvents = Map();
    DateTime today = DateTime.now();

    DateTime nextDate = lastDate;
    int sheduleIndex = 0;
    for (var i = 0; i < n; i++) {
      if (today.month <= nextDate.month && today.year <= nextDate.year) {
        DateTime temp =
            nextDate.subtract(Duration(days: 1, hours: 0, minutes: 0));
        print("match found diffrence in days is-->" +
            temp.difference(today).inDays.toString() +
            "days  " +
            temp.difference(today).inMinutes.toString() +
            "mins  " +
            (temp.difference(today).inMinutes > 0).toString());

        temp.difference(today).inMinutes > 0
            ? showNotification(temp.difference(today).inSeconds, sheduleIndex++)
            // ignore: unnecessary_statements
            : () {};
      }
      // print(nextDate.toString());
      lEvents[nextDate] = ['periods cycle starts'];
      nextDate = nextDate.add(Duration(days: period));
    }
    setState(() {
      _events = lEvents;
      print(lEvents);
    });
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    Map<String, dynamic> documentData;
    print("called get data on collection users");
    await Firestore.instance
        .collection('users')
        .where("user_id",
            isEqualTo: AuthenticationService.prefs.get('user_id').toString())
        .getDocuments()
        .then((value) {
      print(value.documents.toString());
      documentData = value.documents.single.data;
    });
    print("doc data-->" + documentData.toString());
    return documentData;
  }

  void startCallForDetails() {
    setState(() {
      showPickers = false;
    });
    getUserDetails().then((doc) => setAllEvents(
        lastDate: DateTime.parse(doc['last_date']),
        period: doc['cycles'],
        n: 12 * 5));
  }

  // Future<void> _showNotification(int duration, int index) async {
  //   print("shedule index" + index.toString());
  //   await flutterLocalNotificationsPlugin.cancelAll();
  //   print("called notification !!!!!!!!!!!");

  //   var scheduledNotificationDateTime =
  //       new DateTime.now().add(new Duration(seconds: duration));
  //   print("notifications fires in " +
  //       scheduledNotificationDateTime
  //           .difference(DateTime.now())
  //           .inDays
  //           .toString() +
  //       " " +
  //       scheduledNotificationDateTime
  //           .difference(DateTime.now())
  //           .inHours
  //           .toString() +
  //       "Hours " +
  //       scheduledNotificationDateTime
  //           .difference(DateTime.now())
  //           .inMinutes
  //           .toString() +
  //       "mins");
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.schedule(
  //       index,
  //       'period cycle remainder ',
  //       'period cycle starts tomorrow',
  //       scheduledNotificationDateTime,
  //       platformChannelSpecifics,
  //       payload: 'item x');
  // }
}
