class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double latitude;
  final double longitude;
  final String mainCondition;
  final int feelsLike;
  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.mainCondition,
    required this.feelsLike
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      latitude: json['coord']['lat'].toDouble(),
      longitude: json['coord']['lon'].toDouble(),
      mainCondition: json["weather"][0]["main"],
      feelsLike: json["main"]["feels_like"].toDouble().round(),
    );
  }
}
class DailyWeather {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final double precipitation;
  final int weatherCode;  // Add this field for weather condition code

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitation,
    required this.weatherCode,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: DateTime.parse(json['date']),
      maxTemp: json['temperature_2m_max'].toDouble(),
      minTemp: json['temperature_2m_min'].toDouble(),
      precipitation: json['precipitation_sum'].toDouble(),
      weatherCode: json['weathercode'],
    );
  }
}
