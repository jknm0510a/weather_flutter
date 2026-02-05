import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HourWeatherListItem extends StatelessWidget {
  final String time;
  final String conditionIcon;
  final double temperatureC;

  const HourWeatherListItem({
    Key? key,
    required this.time,
    required this.conditionIcon,
    required this.temperatureC,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 16.0),
            ),
            Image.network(
              conditionIcon,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 30); // 載入失敗顯示錯誤圖示
              },
            ),
            Text(
              '${temperatureC.round()}°C',
              style: TextStyle(fontSize: 16.0),
            )
          ],
        ),
      )
    );
  }

}