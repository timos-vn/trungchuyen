import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationApi{
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String>();

  static Future _notificationDetails()async{
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "channelid", "chanelname",
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
        importance: Importance.max,
      ),
      // iOS: IOSFlutterLocalNotificationsPlugin(
      //     sound: 'a_long_cold_sting.aiff',
      //     presentAlert: true,
      //     presentBadge: true,
      //     presentSound: true,
      // )

    );
  }

  static Future init({bool initScheduled = false})async{
    var initializationSettingAndroid = AndroidInitializationSettings('ic_ok_noti');
    // var initializationSettingIOS = IOSInitializationSettings(
    //     requestAlertPermission: true,
    //     requestBadgePermission: true,
    //     requestSoundPermission: true,
    //     onDidReceiveLocalNotification: (
    //         int id, String? title, String? body, String? payload,
    //         ) async {}
    // );
    // var initializationSettings = InitializationSettings(android: initializationSettingAndroid,iOS: initializationSettingIOS);
    // await _notifications.initialize(
    //     initializationSettings,
    //     onSelectNotification: (payload) async {
    //       onNotification.add(payload!);
    //   }
    // );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload})async => _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload
  );

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    DateTime? scheduledDateTime,
    String? payload})async => _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime!, tz.local),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
  );


}