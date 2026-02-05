import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../screens/city_list_screen.dart';

class WeatherCard extends StatelessWidget {
  final String cityName;
  final double temperature; 
  final String weatherCondition; 
  final String iconCode;
  final double windSpeed;
  final int humidity;


  const WeatherCard({
    Key? key,
    required this.cityName,
    required this.temperature,
    required this.weatherCondition,
    required this.iconCode,
    required this.windSpeed,
    required this.humidity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              cityName,
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold), // 顯示城市名稱，字體較大
            ),
            IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.refresh)
            ),
            Spacer(),
            IconButton(
              icon: const Icon(Icons.location_city),
              onPressed: () => _navigateToCityList(context),
            ),

          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${temperature}', // 顯示溫度，取整數並加上°C
              style: Theme.of(context).textTheme.displayLarge, // 顯示溫度，字體非常大
            ),
            Text(
              '°C   $weatherCondition',
              style: Theme.of(context).textTheme.headlineSmall, // 顯示溫度'
            )
          ],
        ),
        Card(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Text(
                        'Wind Speed',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '${windSpeed} kph',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        'Humidity',
                        style: const TextStyle(fontSize: 18),

                      ),
                      const SizedBox(height: 15),
                      Text(
                        '${humidity}%',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ]
              )
          )
        )
      ],
    );
  }

  void _navigateToCityList(BuildContext context) async {
    // 使用 await 來等待 CityListScreen 返回結果
    final selectedCity = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CityListScreen()),
    );

    if (selectedCity != null && selectedCity is String) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeather(selectedCity);
    }
  }
}