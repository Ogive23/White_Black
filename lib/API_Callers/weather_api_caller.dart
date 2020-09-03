import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:white_black/Factory/factory.dart';
import 'package:white_black/Models/weather.dart';

Factory factory = new Factory();

class WeatherApiCaller {
  Future<Weather> get(latitude, longitude) async {
    final String weatherURL =
        'http://api.openweathermap.org/data/2.5/weather?lat=' +
            latitude.toString() +
            "&lon=" +
            longitude.toString() +
            "&appid=" +
            'eeb0971ab03a92f6318c8907c2c13e20';
    var headers = {
      "Accpet": "application/json",
      "Content-Type": "application/json"
    };
    var response = await http.get(Uri.encodeFull(weatherURL), headers: headers);
    var convertDataToJson = jsonDecode(response.body);
    return factory.getWeatherFromJson(convertDataToJson, latitude, longitude);
  }
}
