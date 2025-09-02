import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_practice/Chatbot-Gemini/chat_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point') //task
// backgroundMessageHandler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');

  // if (message.data.isNotEmpty || message.notification != null) {
  //   flutterLocalNotificationsPlugin.show(
  //     message.hashCode,
  //     message.notification?.title ?? message.data['title'] ?? 'Background Notification',
  //     message.notification?.body ?? message.data['body'] ?? 'You have a new message!',
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'high_importance_channel',
  //         'High Importance Notifications',
  //         channelDescription: 'This channel is used for important notifications.',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       ),
  //       iOS: DarwinNotificationDetails(
  //         presentAlert: true,
  //         presentBadge: true,
  //         presentSound: true,
  //       ),
  //     ),
  //     payload: message.data['click_action'],
  //   );
  // }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        // onDidReceiveLocalNotification: (id, title, body, payload) async {},
      );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (
      NotificationResponse notificationResponse,
    ) async {
      print('Notification tapped! Payload: ${notificationResponse.payload}');
    },
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await _requestNotificationPermissions();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> _requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission for notifications.');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not yet granted permission for notifications.');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(
          'App opened from terminated state via notification: ${message.notification?.title}',
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Foreground notification: ${message.notification?.title}');

      // for different payloads
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // AppleNotification? apple = message.notification?.apple;

      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              icon: android?.smallIcon,
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: message.data['click_action'],
        );
      } else if (message.data.isNotEmpty) {
        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.data['title'] ?? 'Data Message Title',
          message.data['body'] ?? 'Data Message Body',
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: message.data['click_action'],
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification caused app to open: ${message.notification?.title}');
    });

    _getDeviceToken();
  }

  void _getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }

  final _locale = const Locale('hi');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      locale: _locale, // set dynamically
      supportedLocales: const [Locale('en'), Locale('hi')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: BlocProvider(
      //   create: (_) => AuthBloc()..add(AppStarted()),
      //   child: AuthUi(),
      // ),
      home: Chatbot(),
      //home: LottieSample(),
    );
  }
}

// class ChatApp extends StatelessWidget {
//   const ChatApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MyChat',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home:
//           // FirebaseAuth.instance.currentUser == null
//           //     ? const ChatLogin()
//           //     : const ChatList(),
//           FcmSendUi(),
//     );
//   }
// }
