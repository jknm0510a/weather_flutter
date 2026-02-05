import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeekWeatherListItem extends StatelessWidget {
  final String dayOfWeek;
  final double maxTempC;
  final double minTempC;
  final String conditionIcon;
  final int chanceOfRain;

  const WeekWeatherListItem ({
    Key? key,
    required this.dayOfWeek,
    required this.maxTempC,
    required this.minTempC,
    required this.conditionIcon,
    required this.chanceOfRain,
}): super(key: key);



  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            Text(
              dayOfWeek,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(width: 8.0),
            Image.network(
              conditionIcon,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 30); // 載入失敗顯示錯誤圖示
              },
            ),
            SizedBox(width: 8.0),
            Text(
              '${chanceOfRain}%',
              style: TextStyle(fontSize: 16.0),
            ),
            Spacer(),
            Text(

              '${maxTempC}°C - ${minTempC}°C',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        )
      )
    );
  }}