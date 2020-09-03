import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:white_black/Session/session_manager.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => new _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  SessionManager sessionManager;
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  double value = 0.0;
  double opacity = 0;
  String quote = "";
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _colorAnimation = Tween<Color>(begin: Colors.green, end: Colors.blue)
        .animate(_animationController);
    quote = [
      '“The purpose of life is not to be happy. It is to be useful,'
          ' to be honorable, to be compassionate,'
          ' to have it make some difference that you have lived and lived well.” \n ― Ralph Waldo Emerson',
      '“No one has ever become poor by giving.” \n'
          '― Anne Frank, diary of Anne Frank: the play',
      '“No one is useless in this world who lightens the burdens of another.”\n'
          '― Charles Dickens',
      '“There is no exercise better for the heart than reaching down and lifting people up.” \n'
          '― John Holmes',
      '“You have not lived today until you have done something for someone who can never repay you.”\n'
          '― John Bunyan'
    ].elementAt(Random().nextInt(5));
    sessionManager = new SessionManager();
    getSession();
    changeOpacity();
  }

  getSession() async {
    await sessionManager.getSessionManager();
    setState(() {});
  }

  getHomePage() {
    if (sessionManager.notFirstTime()) {
      return 'MainScreen';
    } else
      return 'WelcomeScreen';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  changeOpacity() {
    if (value < 1.0) {
      Timer.periodic(
          Duration(seconds: 1),
          (timer) => {
                if (mounted)
                  {
                    setState(() {
                      value += 0.02;
                    })
                  }
              });
      Timer.periodic(
          Duration(seconds: 3),
          (timer) => {
                if (mounted)
                  {
                    setState(() {
                      opacity = 1 - opacity;
                      changeOpacity();
                    })
                  }
              });
    } else {
      opacity = 1.0;
      navigate();
    }
  }

  navigate() {
    sessionManager.sharedPreferences == null
        ? navigate()
        : Navigator.popAndPushNamed(context, getHomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedContainer(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 40, left: 40),
          duration: Duration(seconds: 3),
          decoration: BoxDecoration(color: Colors.black),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: AnimatedOpacity(
                    opacity: opacity,
                    duration: Duration(seconds: 2),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Image.asset('assets/images/ogive_version_2.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    '$quote',
                    style: GoogleFonts.quando(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          value < 1.0
                              ? '${(value * 100).toStringAsPrecision(3)}%'
                              : 'Welcome',
                          style: GoogleFonts.snippet(
                            color: Colors.white,
                          ),
                        ),
                        LinearProgressIndicator(
                          value: value,
                          valueColor: _colorAnimation,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
