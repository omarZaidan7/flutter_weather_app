import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/pages/locations.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

final weatherServices = WeatherServices(apiKey: 'a2f656af79ae1f80ba08ed3a808523f4');

Weather ? _weather;

fetchWeather([String? cityName]) async {
  String city = cityName ?? await weatherServices.getCurrentCity(); // Use selected city or default

  try {
    final Weather weather = await weatherServices.getWeather(city);
    setState(() {
      _weather = weather;
    });
  } catch (e) {
    print(e);
  }
}

String getBackgroundAnimation() {
  if (_weather == null) return 'assets/default_background.json';

  switch (_weather!.mainCondition.toLowerCase()) {
    case 'haze':
    case 'clouds':
      return 'assets/cloudy_background.json';
    case 'rain':
    case 'drizzle':
      return 'assets/rain_background.json';
    case 'thunderstorm':
      return 'assets/rain_background.json';
   default:
      return 'assets/blue_background.json';
  }
}
Color getBackgroundColor() {
  if (_weather == null) return Colors.white;

  switch (_weather!.mainCondition.toLowerCase()) {
    case 'mist':
      return Colors.grey[800]!;
    case 'clear':
      return Colors.lightBlueAccent;
    default:
      return Colors.lightBlueAccent;
  }

}
 String getWeatherAnimation() {
  if (_weather == null) return 'assets/buffering.json';

  switch (_weather!.mainCondition.toLowerCase()) {
    case 'mist':
      return 'assets/mist.json';
    case 'haze':
    case 'clouds':
      return 'assets/haze.json';
    case 'clear':
      return 'assets/sunny.json';
    case 'rain':
    case 'drizzle':
      return 'assets/rainy.json';
    case 'thunderstorm':
      return 'assets/thunder.json';
    default:
      return 'assets/sunny.json'; 
  }
}

 void initState() {
   super.initState();
   fetchWeather();

}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Background Color (Fills the screen before animation loads)
        Container(
          color: getBackgroundColor(),
        ),

        // Background Animation (Lottie)
        SizedBox.expand(
          child: Lottie.asset(getBackgroundAnimation(), fit: BoxFit.cover),
        ),

        // Foreground Content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_weather == null) return;

                  final selectedCity = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Locations()),
                  );

                  if (selectedCity != null) {
                    fetchWeather(selectedCity);
                  }
                },
                child: Text(
                  'Choose Location',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 40),
              Text('Current location: ${_weather?.cityName ?? 'loading city...'}'),
              SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(getWeatherAnimation(), fit: BoxFit.contain),
              ),
              Text('${(_weather != null ? (_weather!.temp - 273.15).round() : 0)}°C'),
              Text(_weather?.mainCondition ?? 'loading condition...'),
            ],
          ),
        ),
      ],
    ),
  );
}


}