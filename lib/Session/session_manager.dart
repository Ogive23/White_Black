import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  SharedPreferences sharedPreferences;
  SessionManager._privateConstructor();

  static final SessionManager _instance = SessionManager._privateConstructor();

  factory SessionManager() {
    return _instance;
  }
  getSessionManager() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  bool notFirstTime() {
    return sharedPreferences.containsKey('notFirstTime'); //true if there
  }

  bool weatherInfoExist() {
    return sharedPreferences.containsKey('decision');
  }

  createWeatherInfo(Map<String, dynamic> data) {
    sharedPreferences.setString('decision', data.values.elementAt(0));
    sharedPreferences.setString(
        'condition', data.values.elementAt(1).condition.toString());
    sharedPreferences.setString(
        'temperature', data.values.elementAt(1).temperature.toString());
    sharedPreferences.setString(
        'humidity', data.values.elementAt(1).humidity.toString());
    sharedPreferences.setString(
        'windSpeed', data.values.elementAt(1).windSpeed.toString());
  }

  changeStatus() {
    sharedPreferences.setString('notFirstTime', true.toString());
  }

  createPreferredTheme(bool theme) {
    sharedPreferences.setString('theme', theme.toString());
  }

  bool loadPreferredTheme() {
    return sharedPreferences.get('theme') == 'true' ? true : false;
  }

  loadWeatherInfo() {
    return sharedPreferences.containsKey('decision')?
      [
        sharedPreferences.getString('decision'),
        sharedPreferences.getString('condition'),
        sharedPreferences.getString('temperature'),
        sharedPreferences.getString('humidity'),
        sharedPreferences.getString('windSpeed'),
      ] : null;
  }

  clearWeatherInfo() {
    sharedPreferences.remove('decision');
    sharedPreferences.remove('condition');
    sharedPreferences.remove('temperature');
    sharedPreferences.remove('humidity');
    sharedPreferences.remove('windSpeed');
  }
}
