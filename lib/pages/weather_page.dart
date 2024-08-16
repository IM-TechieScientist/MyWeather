import 'package:MyWeather/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';
import 'package:MyWeather/secrets.dart';

class MyWidget extends StatefulWidget{
  const MyWidget({super.key});

  State <MyWidget>createState()=>_MyWidgetState();
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class _MyWidgetState extends State<MyWidget>{
  String timeOfDay="";
  DateTime now = DateTime.now();

  final _weatherService=WeatherService(apiKey);
  Weather? _weather;

  _fetchWeather() async {
    String cityName=await _weatherService.getCurrentCity();

    try{
      final weather=await _weatherService.getWeather(cityName);
      setState(() {
        _weather=weather;
      });
    }

    catch(e){
      print(e); 
    }
  }

  String getWeatherAnimation(String? mainCondition){
    if (mainCondition==null) return "assets/${timeOfDay}sunny.json";
    if (now.hour>=18) timeOfDay="night_";
    switch (mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return "assets/${timeOfDay}cloudy.json";
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return "assets/${timeOfDay}rainy.json";
      case 'thunderstorm':
        return "assets/${timeOfDay}thunderstorm.json";
      case 'clear':
        return "assets/${timeOfDay}sunny.json";
      default:
        return "assets/${timeOfDay}sunny.json";
    }

  }


  @override
  void initState(){
    super.initState();

    _fetchWeather();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[900] ,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
   
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.my_location,color: Colors.white,),
                  SizedBox(width: 10,),
                  Text(_weather?.cityName ?? "locating city",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 48.0,color: Colors.white),),
                ],
              ),
            ),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            Text(_weather?.mainCondition ?? "",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: Checkbox.width,color: Colors.white),),
            Text('${_weather?.temperature.round()}°C',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 60,color: Colors.white),),
            SizedBox(height: 50),
            Text("Feels Like ${_weather?.feelsLike ?? ""}°C",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: Checkbox.width,color: Colors.white),),
          ],
        ),
      ),
    );
  }
}