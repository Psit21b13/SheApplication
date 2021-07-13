import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';

Future<void> showNotification(int duration, int index) async {
  print("shedule index" + index.toString());
  await flutterLocalNotificationsPlugin.cancelAll();
  print("called notification !!!!!!!!!!!");

  var scheduledNotificationDateTime =
      new DateTime.now().add(new Duration(seconds: duration));
  print("notifications fires in " +
      scheduledNotificationDateTime
          .difference(DateTime.now())
          .inDays
          .toString() +
      " " +
      scheduledNotificationDateTime
          .difference(DateTime.now())
          .inHours
          .toString() +
      "Hours " +
      scheduledNotificationDateTime
          .difference(DateTime.now())
          .inMinutes
          .toString() +
      "mins");
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
      index,
      'period cycle remainder ',
      'period cycle starts tomorrow',
      tz.TZDateTime.now(tz.local).add(new Duration(seconds: duration)),
      platformChannelSpecifics,
      payload: 'item x',
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}
