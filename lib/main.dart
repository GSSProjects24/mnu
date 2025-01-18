import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mnu_app/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mnu_app/theme/color_schemes.g.dart';
import 'package:mnu_app/theme/myfonts.dart';
import 'package:mnu_app/view/auth/landing-page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'controllers/sessioncontroller.dart';
import 'view/chat/chat_screen.dart';

ValueNotifier isNotified = ValueNotifier(false);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: const AndroidInitializationSettings('@mipmap/launcher_icon'),
    iOS: DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (no, value, value2, value3) {},
    ),
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint(
          'Message also contained a notification: ${message.notification}');
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (payload) {
//       if(message.data['receiverid']!=null){
//         Get.to(ChatScreen(receiverId: message.data['receiverid'], receiverImageUrl:message.data['imageurl'], Name: message.data['username']));
//       }
      });
      flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
            iOS: DarwinNotificationDetails(
              subtitle: message.notification!.body,
              categoryIdentifier: message.notification!.title,
            ),
            android: AndroidNotificationDetails(
              message.notification!.title!,
              message.notification!.title!,
              icon: '@mipmap/launcher_icon',
            ),
          ));
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    if (event.data['receiverid'] != null) {
      Get.to(ChatScreen(
          receiverId: event.data['receiverid'],
          receiverImageUrl: event.data['imageurl'],
          Name: event.data['username']));
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.subscribeToTopic('admin');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  Get.put(() => SessionController());
}

// WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
//   Get.put(() => SessionController());
// }
// bool appDark= false;

ColorScheme clrschm = lightColorScheme;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getDeviceToken();
  }

  // void getDeviceToken() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   String? token = await messaging.getToken();
  //   print("Device Token: $token");
  //   // Optionally, save the token to a server or use it in your app for push notifications
  // }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      title: 'MNU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: const IconThemeData(color: Colors.white),
            color: clrschm.primary,
            actionsIconTheme: IconThemeData(color: clrschm.onPrimary),
          ),
          hintColor: const Color(0xFF4841a7),
          navigationBarTheme: NavigationBarThemeData(
              surfaceTintColor: const Color(0xFF4841a7),
              indicatorColor: Colors.grey.withOpacity(0.2)),
          elevatedButtonTheme: const ElevatedButtonThemeData(),
          textTheme: myfonts,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: clrschm.primary,
              unselectedItemColor: Theme.of(context).disabledColor),
          useMaterial3: true,
          colorScheme: clrschm),
      darkTheme: ThemeData(
          useMaterial3: true, colorScheme: darkColorScheme, textTheme: myfonts),
      // home: const LandingPage());
      home: AnimatedSplashScreen(
        animationDuration: const Duration(seconds: 1),
        splashIconSize: 250,
        splash: 'assets/MNU-Logo.png',
        nextScreen: const LandingPage(),
        splashTransition: SplashTransition.fadeTransition,
      ),
      // debugShowCheckedModeBanner: false,
    );
  }
}
