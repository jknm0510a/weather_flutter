import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherDisplayScreen extends StatelessWidget {
  final String? cityName;
  const WeatherDisplayScreen({super.key, this.cityName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cityName ?? '天氣顯示')),
      body: Center(child: Text('天氣顯示頁面 ${cityName ?? ''}')),
    );
  }
}