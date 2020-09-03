import 'package:white_black/Models/weather.dart';

class Factory {
  Weather getWeatherFromJson(json, latitude, longitude) {
    return new Weather(
      json['name'].toString(),
      latitude,
      longitude,
      json['weather'][0]['main'].toString().toLowerCase(),
      json['weather'][0]['description'],
      double.parse(json['main']['temp'].toString()) - 273.15,
      double.parse(json['main']['temp_min'].toString()) - 273.15,
      double.parse(json['main']['temp_max'].toString()) - 273.15,
      double.parse(json['main']['pressure'].toString()),
      double.parse(json['main']['humidity'].toString()),
      double.parse(json['wind']['speed'].toString()),
    );
  }
}
