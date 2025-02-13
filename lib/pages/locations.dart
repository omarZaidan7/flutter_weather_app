import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_services.dart';

class Locations extends StatefulWidget {
  const Locations({super.key});

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  final weatherServices = WeatherServices(apiKey: 'a2f656af79ae1f80ba08ed3a808523f4');
  String? currentCity;

  @override
  void initState() {
    super.initState();
    fetchCurrentCity();
  }

  Future<void> fetchCurrentCity() async {
    String city = await weatherServices.getCurrentCity();
    setState(() {
      currentCity = city;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> locations = [
      if (currentCity != null) {'city': currentCity!, 'country': '📍'}, 
      {'city': 'Dubai', 'country': '🇦🇪'},
      {'city': 'New York', 'country': '🇺🇸'},
      {'city': 'London', 'country': '🇬🇧'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Choose Location')),
      body: currentCity == null
          ? Center(child: CircularProgressIndicator()) 
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: locations.map((location) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, location['city']); 
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: ListTile(
                      leading: Text(location['country']!, style: TextStyle(fontSize: 30)),
                      title: Text(location['city']!,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

