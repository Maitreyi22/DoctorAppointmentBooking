import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  String getMonthFromNumber(int i) {
    return months[i];
  }

  //initilize

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("ic_launcher");

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Instant Notifications
  Future instantNofitication() async {
    var android = AndroidNotificationDetails("id", "channel", "description");

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo instant notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Image notification
  Future imageNotification() async {
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Image notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Stylish Notification
  Future stylishNotification(DateTime day, String batchTime) async {
    String message = "Your Appointment is sheduled on " +
        day.day.toString() +
        ' ' +
        getMonthFromNumber(day.month);
    var android = AndroidNotificationDetails("id", "channel", "description",
        color: Colors.deepOrange,
        enableLights: true,
        enableVibration: true,
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        styleInformation: MediaStyleInformation(
            htmlFormatContent: true, htmlFormatTitle: true));

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, 'Doctor Appointment', message + batchTime, platform);
  }

  //Sheduled Notification

  Future sheduledNotification(DateTime day, String batchTime) async {
    String message = "Your Appointment is sheduled on " +
        day.day.toString() +
        ' ' +
        getMonthFromNumber(day.month);

    var interval = RepeatInterval.daily;

    var android = AndroidNotificationDetails("id", "channel", "description",
        color: Colors.deepOrange,
        enableLights: true,
        enableVibration: true,
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        styleInformation: MediaStyleInformation(
            htmlFormatContent: true, htmlFormatTitle: true));

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'Doctor Appointment',
        message + "   \nOn Time : " + batchTime,
        interval,
        platform);
  }

  //Cancel notification

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
