import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:white_black/Session/session_manager.dart';
import 'package:white_black/Themes/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  final SessionManager sessionManager = new SessionManager();
  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = Provider.of<AppTheme>(context);
    print('${appTheme.themeData.cardTheme.color}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: appTheme.themeData.textTheme.title,
        ),
        backgroundColor: appTheme.themeData.appBarTheme.color,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info,
              color: appTheme.themeData.iconTheme.color,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AboutDialog(
                    applicationName: 'White Or Black',
                    applicationVersion: '1.0.1',
                    children: <Widget>[
                      Text('Animations rights reserved to Lottie'),
                      Text('Fonts rights reserved to Google Fonts'),
                      Text('OGIVE ©2020')
                    ],
                  );
                },
              );
            },
            tooltip: 'License',
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: appTheme.themeData.backgroundColor),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Dark Mode', style: appTheme.themeData.textTheme.body1),
                  Switch(
                    value: appTheme.isDark,
                    activeColor: appTheme.themeData.toggleableActiveColor,
                    onChanged: (value) {
                      sessionManager.createPreferredTheme(value);
                      appTheme.changeTheme(value);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
