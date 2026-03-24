import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings ios = DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(settings: settings);
  }

  Future<void> scheduleAnniversaryNotification(DateTime anniversary) async {
    final now = DateTime.now();
    var nextAnniversary = DateTime(now.year, anniversary.month, anniversary.day);
    if (now.isAfter(nextAnniversary)) {
      nextAnniversary = nextAnniversary.add(const Duration(days: 365));
    }

    await _notifications.zonedSchedule(
      id: 0,
      scheduledDate:  tz.TZDateTime.from(nextAnniversary, tz.local),
      notificationDetails:  const NotificationDetails(
        android: AndroidNotificationDetails('anniversary_channel', 'Anniversaries', importance: Importance.max),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      title: 'Happy anniversary!',
      body:  'You have been ${DateTime.now().difference(anniversary).inDays} days together!',
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

}