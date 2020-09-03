import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.black, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )),
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'WhiteOrBlack');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'OpenSans',
                          letterSpacing: 1.4,
                        ),
                        children: [
                          TextSpan(
                              text: 'White O',
                              style: TextStyle(color: Colors.white, shadows: [
                                Shadow(
                                    color: Colors.black,
                                    offset: Offset.fromDirection(1, 3))
                              ])),
                          TextSpan(
                              text: 'R Black',
                              style: TextStyle(color: Colors.black, shadows: [
                                Shadow(
                                    color: Colors.white,
                                    offset: Offset.fromDirection(1, 3))
                              ])),
                        ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 30),
                  child: Image.asset(
                    'assets/images/BAW.png',
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GradientText(
                      'White or Black Program helps you to decide what color you gonna wear today.',
                      gradient: LinearGradient(
                          colors: [Colors.black, Colors.white],
                          begin: Alignment(-3, 0),
                          end: Alignment.center,
                          tileMode: TileMode.repeated),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('Click to Proceed'))
              ],
            ),
          ),
        ));
  }
}
