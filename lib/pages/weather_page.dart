import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';
import 'package:MyWeather/services/weather_service.dart';
import 'package:MyWeather/secrets.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String timeOfDay = "";
  DateTime now = DateTime.now();

  final _weatherService = WeatherService(apiKey);
  Weather? _weather;
  List<DailyWeather>? _weeklyForecast;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      final weeklyForecast = await _weatherService.getWeeklyForecast(cityName);
      setState(() {
        _weather = weather;
        _weeklyForecast = weeklyForecast;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.my_location, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    _weather?.cityName ?? "Locating city",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 48.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            if (_weather != null) ...[
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              Text(
                _weather?.mainCondition ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              Text(
                '${_weather?.temperature.round()}°C',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 50),
              Text(
                "Feels Like ${_weather?.feelsLike ?? ""}°C",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ],
            SizedBox(height: 40),
            if (_weeklyForecast != null)
              Column(
                children: [
                  Text("Daily Forecast For the Week",
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 150, // Adjust as needed
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _weeklyForecast!.map((dailyWeather) {
                          String mainCondition = getWeatherAnimation(getWeatherCondition(dailyWeather.weatherCode));
                          return Container(
                            width: 100, // Adjust as needed
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${dailyWeather.date.day}/${dailyWeather.date.month}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Lottie.asset(mainCondition, height: 60),
                                // Text(getWeatherCondition(dailyWeather.weatherCode),
                                //   style: TextStyle(color: Colors.white),),
                                Text('${dailyWeather.minTemp.round()}°C - ${dailyWeather.maxTemp.round()}°C',
                                  style: TextStyle(color: Colors.white),),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String getWeatherCondition(int weatherCode) {
    switch (weatherCode) {
      case 0: return 'Clear';
      case 1: return 'Mainly Clear';
      case 2: return 'Partly Cloudy';
      case 3: return 'Overcast';
      case 45: return 'Fog';
      case 51: return 'Light Drizzle';
      case 61: return 'Showers';
      case 71: return 'Snow Showers';
      case 80: return 'Showers of Rain';
      case 95: return 'Thunderstorm';
      default: return 'Unknown';
    }
  }
    String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/${timeOfDay}sunny.json";
    if (now.hour >= 18) timeOfDay = "night_";
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case "overcast":
        return "assets/${timeOfDay}cloudy.json";
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'showers of rain':
        return "assets/${timeOfDay}rainy.json";
      case 'thunderstorm':
        return "assets/${timeOfDay}thunderstorm.json";
      case 'clear':
        return "assets/${timeOfDay}sunny.json";
      default:
        return "assets/${timeOfDay}sunny.json";
    }
  }
}
