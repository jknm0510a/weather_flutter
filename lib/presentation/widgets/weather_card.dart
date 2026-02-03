import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String cityName;
  final double temperature; 
  final String weatherCondition; 
  final String iconCode;

  const WeatherCard({
    Key? key,
    required this.cityName,
    required this.temperature,
    required this.weatherCondition,
    required this.iconCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0), // 卡片外邊距
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 卡片內邊距
        child: Column(
          mainAxisSize: MainAxisSize.min, // 讓 Column 內容根據子元件大小自動調整
          children: [
            Text(
              cityName,
              style: Theme.of(context).textTheme.headlineMedium, // 顯示城市名稱，字體較大
            ),
            const SizedBox(height: 10), // 間距
            Text(
              '${temperature.round()}°C', // 顯示溫度，取整數並加上°C
              style: Theme.of(context).textTheme.displayLarge, // 顯示溫度，字體非常大
            ),
            const SizedBox(height: 10), // 間距
            Text(
              weatherCondition, // 顯示天氣狀況文字
              style: Theme.of(context).textTheme.headlineSmall, // 字體稍大
            ),
            const SizedBox(height: 10), // 間距
            // 天氣圖示的佔位符。未來您可以根據 iconCode 從網路載入圖片，或使用本地資產
            Icon(
              Icons.wb_sunny, // 暫時使用一個太陽圖示作為佔位符
              size: 50,
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}