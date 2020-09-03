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
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: appTheme.themeData.appBarTheme.color,
              title: Text(
                'Our Society',
                style: appTheme.themeData.textTheme.title,
              ),
            ),
            body: Container(
              decoration:
                  BoxDecoration(color: appTheme.themeData.backgroundColor),
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
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
                        SizedBox(
                          height: 20,
                        ),
                        card(
                            appTheme.themeData.cardTheme.color,
                            appTheme.themeData.textTheme.body2,
                            'Patreon',
                            'Support us.',
                            'https://www.patreon.com/user?0=u&1=%3D&2=1&3=6&4=2&5=7&6=7&7=2&8=5&9=6',
                            FontAwesomeIcons.patreon,
                            Colors.red,
                            ''),
                        SizedBox(
                          height: 20,
                        ),
                        card(
                            appTheme.themeData.cardTheme.color,
                            appTheme.themeData.textTheme.body2,
                            'opencollective',
                            'Support us.',
                            'https://opencollective.com/ogive',
                            FontAwesomeIcons.flag,
                            Colors.green,
                            ''),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
