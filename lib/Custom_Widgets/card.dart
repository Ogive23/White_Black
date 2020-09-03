import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url, kind) async {
  String protocolURL;
  if (kind == 'fb')
    protocolURL = "fb://page/716275428808273";
  else if (kind == 'twitter')
    protocolURL = "twitter:///user?screen_name=\(MahmouedMartin)";
  try {
    bool launched = await launch(protocolURL,
        forceSafariVC: false, universalLinksOnly: false);
    if (!launched) {
      await launch(url, forceSafariVC: false);
    }
  } catch (e) {
    await launch(url, forceSafariVC: false);
  }
}

card(cardColor, bodyTextTheme, title, subtitle, url, icon, iconColor, kind) {
  return Container(
    decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [Colors.blueAccent, Colors.pinkAccent])),
    child: GestureDetector(
      onTap: () {
        launchURL(url, kind);
      },
      child: Card(
        color: cardColor,
        elevation: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: FaIcon(
                icon,
                color: iconColor,
                size: 40,
              ),
              title: Text(
                title,
                style: bodyTextTheme,
              ),
              subtitle: Text(
                subtitle,
                style: bodyTextTheme,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
