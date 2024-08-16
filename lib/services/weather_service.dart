import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "http://api.openweathermap.org/data/2.5/weather";
  static const OPEN_METEO_URL = "https://api.open-meteo.com/v1/forecast";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric')
    );
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
  
Future<List<DailyWeather>> getWeeklyForecast(String cityName) async {
  final weatherData = await getWeather(cityName);
  final latitude = weatherData.latitude;
  final longitude = weatherData.longitude;

  final response = await http.get(
    Uri.parse('$OPEN_METEO_URL?latitude=$latitude&longitude=$longitude&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,weathercode&timezone=America%2FNew_York')
  );

  print("RESPONSE ${response.body}");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final dailyData = data['daily'] as Map<String, dynamic>;

    List<DailyWeather> forecast = (dailyData['weathercode'] as List<dynamic>).asMap().entries.map((entry) {
      int index = entry.key;
      int weatherCode = entry.value;
      return DailyWeather(
        date: DateTime.parse(dailyData['time'][index]),
        maxTemp: dailyData['temperature_2m_max'][index].toDouble(),
        minTemp: dailyData['temperature_2m_min'][index].toDouble(),
        precipitation: dailyData['precipitation_sum'][index].toDouble(),
        weatherCode: weatherCode,
      );
    }).toList();

    return forecast;
  } else {
    throw Exception("Failed to load weekly forecast");
  }
}

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude, 
      position.longitude
    );

    String? city = placemarks[0].locality;
    
    return city ?? "";
  }
}
