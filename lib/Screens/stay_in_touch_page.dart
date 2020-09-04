import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:white_black/Custom_Widgets/card.dart';
import 'package:white_black/Themes/app_theme.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class StayInTouchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      backgroundColor: appTheme.themeData.appBarTheme.color,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appTheme.themeData.appBarTheme.color,
        title: Text(
          'Our Society',
          style: appTheme.themeData.textTheme.title,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
        decoration: BoxDecoration(color: appTheme.themeData.backgroundColor),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: NativeBannerAdSize.HEIGHT_50.height.toDouble(),
                  child: FacebookNativeAd(
                    placementId: "355563962144474_355564722144398",
                    adType: NativeAdType.NATIVE_BANNER_AD,
                    bannerAdSize: NativeBannerAdSize.HEIGHT_50,
                    width: double.infinity,
                    backgroundColor: appTheme.themeData.backgroundColor,
                    titleColor: appTheme.themeData.accentColor,
                    descriptionColor: appTheme.themeData.accentColor,
                    buttonColor: Colors.deepPurple,
                    buttonTitleColor: appTheme.themeData.accentColor,
                    buttonBorderColor: appTheme.themeData.accentColor,
                    keepAlive: true,
                    labelColor: Colors.transparent,
                    listener: (result, value) {
                      print("Native Ad: $result --> $value");
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              card(
                  appTheme.themeData.cardTheme.color,
                  appTheme.themeData.textTheme.body2,
                  'Facebook',
                  'Visit our facebook Page.',
                  'https://www.facebook.com/ogive23/',
                  FontAwesomeIcons.facebook,
                  Colors.blue,
                  'fb'),
              SizedBox(
                height: 20,
              ),
              card(
                  appTheme.themeData.cardTheme.color,
                  appTheme.themeData.textTheme.body2,
                  'Instagram',
                  'Visit our Instagram Account.',
                  'https://www.instagram.com/mahmoued.martin/',
                  FontAwesomeIcons.instagram,
                  Colors.black,
                  'insta'),
              SizedBox(
                height: 20,
              ),
              card(
                  appTheme.themeData.cardTheme.color,
                  appTheme.themeData.textTheme.body2,
                  'Youtube',
                  'Visit our youtube channel.',
                  'https://www.youtube.com/channel/UCedueKqOIz38zog0alc7_eg',
                  FontAwesomeIcons.youtube,
                  Colors.red,
                  'youtube'),
              SizedBox(
                height: 20,
              ),
              card(
                  appTheme.themeData.cardTheme.color,
                  appTheme.themeData.textTheme.body2,
                  'Twitter',
                  'Find us on twitter.',
                  'https://twitter.com/MahmouedMartin2',
                  FontAwesomeIcons.twitter,
                  Colors.blue,
                  'twitter'),
            ],
          ),
        ),
      ),
    );
  }
}
