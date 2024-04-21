import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_flutter_app/service/weather_service.dart';
import 'package:my_flutter_app/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('1bef78dfa90d4b4a0ff1bf29d94b55c4');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    print(cityName);
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

//
  String getDayOfTheWeek(int? dateTime) {
    switch (dateTime) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }

//weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloud.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/snow.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'asset/sunny.json';
    }
  }

//init state
  @override
  void initState() {
    super.initState();

//fetch weather in start up
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather?.cityName == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _locationHeader(),
            _dateAndTime(),
            _animationUI(),
            _temperature(),
            _boxInfo(),
          ],
        ));
  }

  Widget _boxInfo() {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.80,
      height: MediaQuery.sizeOf(context).height * 0.15,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_minTempUI(), _maxTempUI()],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_feelsLikeUI(), _humidityUI()],
          )
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      '${_weather?.cityName}, ${_weather?.country}',
      style: const TextStyle(
          fontSize: 35, fontWeight: FontWeight.w500, color: Colors.white),
    );
  }

  Widget _mainCondition() {
    return Text(
      _weather?.mainCondition ?? '',
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Widget _animationUI() {
    return Lottie.asset(getWeatherAnimation(_weather?.mainCondition));
  }

  Widget _feelsLikeUI() {
    return Text(
      'Feels like: ${_weather!.feelsLike}C',
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Widget _temperature() {
    return Text(
      '${_weather!.temperature}C',
      style: const TextStyle(
          fontSize: 90, fontWeight: FontWeight.w500, color: Colors.white),
    );
  }

  Widget _minTempUI() {
    return Text(
      'Min: ${_weather!.minTemp}C',
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Widget _maxTempUI() {
    return Text(
      'Max: ${_weather!.maxTemp}C',
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Widget _humidityUI() {
    return Text(
      'Humidity: ${_weather!.humidity}C',
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Widget _dateAndTime() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              getDayOfTheWeek(DateTime.now().weekday),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            Text(
              '  ${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ],
        )
      ],
    );
  }
}
