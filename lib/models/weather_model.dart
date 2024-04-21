class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final String mainCondition;
  final double minTemp;
  final double maxTemp;
  final int humidity;
  final String icon;

  Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.mainCondition,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      country: json['sys']['country'].toString(),
      temperature: json['main']['temp'].toDouble(), 
      feelsLike: json['main']['feels_like'].toDouble(), 
      mainCondition: json['weather'][0]['main'].toString(), 
      minTemp:  json['main']['temp_min'].toDouble(), 
      maxTemp:  json['main']['temp_max'].toDouble(),
      humidity:  json['main']['humidity'], 
      icon:  json['weather'][0]['icon'].toString(), 
    );
  }
}
