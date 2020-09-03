import 'dart:async';
import 'dart:isolate';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'Screens/main_screen.dart';
import 'Screens/splash_screen.dart';
import 'Screens/user_decision.dart';
import 'Screens/first_time_screens.dart';
import 'Screens/white_or_black_main.dart';

void main() {
  runApp(WhiteOrBlackMain());
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
//  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned<Future<void>>(() async {
    // ...
  }, onError: Crashlytics.instance.recordError);
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await Crashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);
}

class WhiteOrBlackMain extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'White Or Black',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        "SplashScreen": (BuildContext context) => SplashScreen(),
        "WelcomeScreen": (BuildContext context) => WelcomeScreen(),
        "MainScreen": (BuildContext context) => MainScreen(),
        "WhiteOrBlack": (BuildContext context) => WhiteOrBlack(),
        "UserDecision": (BuildContext context) => UserDecision(),
      },
    );
  }
}
