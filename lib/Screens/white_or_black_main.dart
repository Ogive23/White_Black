import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:white_black/API_Callers/weather_api_caller.dart';
import 'package:white_black/Custom_Widgets/text.dart';
import 'package:white_black/ML_Models/weather_model.dart';
import 'package:white_black/Models/user_location.dart';
import 'package:white_black/Models/weather.dart';
import 'package:white_black/Session/session_manager.dart';

import 'main_screen.dart';

class WhiteOrBlack extends StatefulWidget {
  @override
  _WhiteOrBlackState createState() => _WhiteOrBlackState();
}

enum TtsState { playing, stopped }

class _WhiteOrBlackState extends State<WhiteOrBlack> {
  Weather weather;
  UserLocation userLocation;
  SessionManager sessionManager = new SessionManager();
  FlutterTts flutterTts;
  @override
  void initState() {
    super.initState();
    userLocation = new UserLocation();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();
  }

  Future _speak(newVoiceText) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.65);
    await flutterTts.setPitch(1.1);
    if (newVoiceText != null) {
      if (newVoiceText.isNotEmpty) {
        await flutterTts.speak(newVoiceText);
      }
    }
  }

  Future<Map<String, dynamic>> get() async {
    if (userLocation.latitude == null || userLocation.longitude == null) {
      await userLocation.getUserLocation();
    }
    WeatherApiCaller apiCaller = new WeatherApiCaller();
    weather =
        await apiCaller.get(userLocation.latitude, userLocation.longitude);
    ClothesDecideModel model = new ClothesDecideModel();
    return {
      'model': await model.test(
                  weather.getCondition.toString().toLowerCase(),
                  weather.getTemperature,
                  weather.getHumidity,
                  weather.getWindSpeed) ==
              'yes'
          ? 'Wear bright colors!'
          : 'Wear dark colors!',
      'weather': weather
    };
  }

  Widget showResult() {
    return FutureBuilder<Map<String, dynamic>>(
      future: get(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          if (sessionManager.weatherInfoExist()) {
            sessionManager.clearWeatherInfo();
            sessionManager.createWeatherInfo(snapshot.data);
            _scheduleNotification();
          } else {
            sessionManager.createWeatherInfo(snapshot.data);
            _scheduleNotification();
          }
          return getBody(snapshot.data);
        } else if (snapshot.error != null) {
          sessionManager.clearWeatherInfo();
          return Material(
              child: Container(
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            alignment: Alignment.center,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Text(
                  'Error!!!\nPlease Check Your internet connection, Also make sure that you enabled location service.',
                  style:
                      TextStyle(decoration: TextDecoration.none, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Image(
                  image: AssetImage('assets/images/undraw_Notify_re_65on.png'),
                  height: MediaQuery.of(context).size.height / 3,
                ),
                IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {});
                    })
              ],
            )),
          ));
        } else {
          return Container(
            color: Colors.blue,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              CupertinoActivityIndicator(
                animating: true,
                radius: 50,
              ),
              text('Make sure that you have enabled location service !',Colors.white,14.0,1.5,FontWeight.w500)
            ]),
          ));
        }
      },
    );
  }

  Future _scheduleNotification() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(new Duration(hours: 6));
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '23', 'WhiteOrBlack', 'WhiteOrBlack App',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'OGIVE',
        icon: 'ic_launcher',
        vibrationPattern: vibrationPattern);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.cancelAll();
    await flutterLocalNotificationsPlugin.schedule(
        TimeOfDay.now().minute,
        'White Or Black',
        'tell us which type of clothes would suited today\'s weather?',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        payload: 'W|B');
  }

  @override
  Widget build(BuildContext context) {
    return showResult();
  }

  Widget getBody(Map<String, dynamic> data) {
    List<dynamic> decoration =
        getDecoration(data.values.elementAt(1).condition);
    _speak('Hey today temperature is ' +
        data.values.elementAt(1).temperature.toStringAsFixed(2) +
        ' So ' +
        data.values.elementAt(0).toString());
    return SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/images/${decoration.elementAt(0)}.png'),
                  fit: BoxFit.cover),
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                        color: decoration[3],
                        width: 2,
                      )),
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(left: 3, right: 3, top: 5, bottom: 0),
                  margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      text('${data.values.elementAt(1).city}', decoration[3],
                          60.0, 1.5, FontWeight.w200),
                      text('${DateTime.now().hour}:${DateTime.now().minute}',
                          decoration[3], 40.0, 1.5, FontWeight.w100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Icon(
                            Icons.vertical_align_bottom,
                            size: 20,
                            color: decoration[3],
                          ),
                          text(
                              data.values
                                  .elementAt(1)
                                  .tempMin
                                  .toStringAsFixed(0),
                              decoration[3],
                              40.0,
                              1.0,
                              FontWeight.w100),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            decoration[1],
                            color: decoration[2],
                            size: 40,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.vertical_align_top,
                            size: 20,
                            color: decoration[3],
                          ),
                          text(
                              data.values
                                  .elementAt(1)
                                  .tempMax
                                  .toStringAsFixed(0),
                              decoration[3],
                              40.0,
                              1.0,
                              FontWeight.w100),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.15),
                        ),
                        child: Column(
                          children: [
                            text(data.values.elementAt(1).description,
                                decoration[3], 40.0, 1.0, FontWeight.w100),
                            Divider(
                              height: 1,
                              color: Colors.white.withOpacity(0.5),
                              indent: 10,
                              endIndent: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  FontAwesomeIcons.wind,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                                text(
                                    data.values
                                            .elementAt(1)
                                            .windSpeed
                                            .toString() +
                                        ' m/s',
                                    decoration[3],
                                    40.0,
                                    1.0,
                                    FontWeight.w100),
                              ],
                            ),
                            Divider(
                              height: 1,
                              color: Colors.white.withOpacity(0.5),
                              indent: 10,
                              endIndent: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  FontAwesomeIcons.compass,
                                  color: Colors.red[800],
                                  size: 30,
                                ),
                                text(
                                    data.values
                                            .elementAt(1)
                                            .pressure
                                            .toString() +
                                        ' hPa',
                                    decoration[3],
                                    40.0,
                                    1.0,
                                    FontWeight.w100),
                              ],
                            ),
                            Divider(
                              height: 1,
                              color: Colors.white.withOpacity(0.5),
                              indent: 10,
                              endIndent: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.opacity,
                                  color: Colors.yellow[600],
                                  size: 30,
                                ),
                                text(
                                    data.values
                                            .elementAt(1)
                                            .humidity
                                            .toString() +
                                        ' %',
                                    decoration[3],
                                    40.0,
                                    1.0,
                                    FontWeight.w100),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(FontAwesomeIcons.magic,
                          color: Colors.blue[700], size: 30),
                      Text(
                        '${data.values.elementAt(0).toString()} !',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.bilbo(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w400,
                            color: decoration[3],
                            fontSize: 70.0),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            text(
                                '${data.values.elementAt(1).temperature.toStringAsFixed(0)}',
                                decoration[3],
                                80.0,
                                1.0,
                                FontWeight.w200),
                            text('°C', decoration[3], 40.0, 1.0,
                                FontWeight.w200),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  getDecoration(condition) {
    switch (condition) {
      case 'clear':
        return ['clear', FontAwesomeIcons.tree, Colors.green, Colors.white];
      case 'clouds':
        return ['clouds', FontAwesomeIcons.cloud, Colors.white, Colors.white];
      case 'drizzle':
        return [
          'drizzle',
          FontAwesomeIcons.cloudMoonRain,
          Colors.blue,
          Colors.white
        ];
      case 'rain':
        return ['rain', FontAwesomeIcons.cloudRain, Colors.blue, Colors.white];
      case 'snow':
        return ['snow', FontAwesomeIcons.snowplow, Colors.black, Colors.black];
      case 'Thunderstorm':
        return [
          'Thunderstorm',
          FontAwesomeIcons.pooStorm,
          Colors.deepPurple[700],
          Colors.white
        ];
      case 'mist':
        return [
          'mist',
          FontAwesomeIcons.wind,
          Colors.deepOrange,
          Colors.redAccent
        ];
      default:
        return ['sunny', Icons.wb_sunny, Colors.orange, Colors.black];
    }
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }
}
