import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:white_black/Custom_Widgets/text.dart';
import 'package:white_black/Session/session_manager.dart';

class UserDecision extends StatefulWidget {
  @override
  _UserDecisionState createState() => _UserDecisionState();
}

class _UserDecisionState extends State<UserDecision> {
  SessionManager sessionManager = SessionManager();
  List<String> info = new List<String>();
  @override
  void initState() {
    super.initState();
    loadSessionManager();
    loadWeatherInfo();
  }

  loadSessionManager() async {
    await sessionManager.getSessionManager();
  }

  loadWeatherInfo() async {
    info = await sessionManager.loadWeatherInfo();
    setState(() {});
  }

  _save(outlook, temperature, humidity, windSpeed, decision) async {
    Map<String, dynamic> map = {
      'outlook': outlook,
      'temperature': temperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'decision': decision
    };
    for (int i = 0; i < map.values.length; i++) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${map.keys.elementAt(i)}.txt');
      await file.writeAsString(map.values.elementAt(i).toString() + " ",
          mode: FileMode.append);
    }
    sessionManager.clearWeatherInfo();
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  Widget getBody() {
    dynamic info = sessionManager.loadWeatherInfo();
    if (info != null)
      return getDecidingBody(sessionManager.loadWeatherInfo());
    else
      return getErrorBody();
  }

  Widget getErrorBody() {
    return Material(
        child: Container(
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      alignment: Alignment.center,
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Text(
            'Error!!!.',
            style: TextStyle(decoration: TextDecoration.none, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Image(
            image: AssetImage('assets/images/undraw_Notify_re_65on.png'),
            height: MediaQuery.of(context).size.height / 3,
          ),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              })
        ],
      )),
    ));
  }

  Widget getDecidingBody(info) {
    return Container(
        color: Colors.blue,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              text(
                  'Reaching this point means that you can decide whether today\'s decision was good or not?\n',
                  Colors.white,
                  18.0,
                  1.5,
                  FontWeight.w300),
              text(
                  '*This answer would help for taking better future decisions*.\n',
                  Colors.white,
                  14.0,
                  1.5,
                  FontWeight.w300),
              text('Decision was to ${info[0]}', Colors.white, 16.0, 1.5,
                  FontWeight.bold),
              text('Weather was ${info[1]}', Colors.white, 16.0, 1.5,
                  FontWeight.bold),
              text('Temperature was ${info[2].split('.')[0]} °C', Colors.white,
                  16.0, 1.5, FontWeight.bold),
              text('Humidity was ${info[3]}', Colors.white, 16.0, 1.5,
                  FontWeight.bold),
              text('Wind speed was ${info[4]}', Colors.white, 16.0, 1.5,
                  FontWeight.bold),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    onPressed: () async {
                      await _save(info[1], info[2], info[3], info[4], 'yes');
                    },
                    child: Text(
                      'Wear Bright Colors',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    color: Colors.black,
                    onPressed: () async {
                      await _save(info[1], info[2], info[3], info[4], 'no');
                    },
                    child: Text(
                      'Wear Dark Colors',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }
}
