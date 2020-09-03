import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:white_black/Session/session_manager.dart';
import 'package:white_black/Ads/ad_manager.dart';
import 'package:white_black/Themes/app_theme.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'stay_in_touch_page.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 1;
  final pageOption = [StayInTouchPage(), HomeScreen(), SettingsScreen()];
  BannerAd bannerAd;

  void loadBannerAd() {
    bannerAd
      ..load()
      ..show(anchorType: AnchorType.top);
  }

  @override
  void initState() {
    super.initState();
    initializeNotification();
    bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
    loadBannerAd();
  }

  Future<void> initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  initializeNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        if (payload == 'W|B') {
          return Navigator.popAndPushNamed(context, 'UserDecision');
        }
        return null;
      },
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }

  final SessionManager sessionManager = new SessionManager();
  AppTheme appTheme;
  @override
  Widget build(BuildContext context) {
    appTheme = new AppTheme(sessionManager.loadPreferredTheme());
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.people), title: Text('Stay in touch')),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text('Settings')),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.white,
          onTap: onItemTapped,
          backgroundColor: Colors.indigo[900],
        ),
        body: ChangeNotifierProvider<AppTheme>(
          child: pageOption[selectedIndex],
          create: (context) => appTheme,
        ));
  }
}
