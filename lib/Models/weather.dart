class Weather {
  String city;
  double lat;
  double lon;
  String condition;
  String description;
  double temperature;
  double tempMin;
  double tempMax;
  double pressure;
  double humidity;
  double windSpeed;
  Weather(
      this.city,
      this.lat,
      this.lon,
      this.condition,
      this.description,
      this.temperature,
      this.tempMin,
      this.tempMax,
      this.pressure,
      this.humidity,
      this.windSpeed);
  getAll() {
    return [
      city,
      lat,
      lon,
      condition,
      description,
      temperature,
      tempMin,
      tempMax,
      pressure,
      humidity,
      windSpeed
    ];
  }

  get getCity => city;
  get getLatitude => lat;
  get getLongitude => lon;
  get getCondition => condition;
  get getDescription => description;
  get getTemperature => temperature;
  get getTempMin => tempMin;
  get getTempMax => tempMax;
  get getPressure => pressure;
  get getHumidity => humidity;
  get getWindSpeed => windSpeed;
}
