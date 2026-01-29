

import '../../domain/entities/weather_entity.dart';

class WeatherModel {
  final String locationName;
  final String region;
  final double tempC;
  final String conditionText;
  final String conditionIconUrl;

  const WeatherModel({
    required this.locationName,
    required this.region,
    required this.tempC,
    required this.conditionText,
    required this.conditionIconUrl,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      locationName: json['location']['name'] as String,
      region: json['location']['region'] as String,
      tempC: json['current']['temp_c'] as double,
      conditionText: json['current']['condition']['text'] as String,
      // API 回應的 icon URL 可能不包含 'https:'，我們手動補上
      conditionIconUrl: "https:${json['current']['condition']['icon']}",
    );
  }

  WeatherEntity toEntity() {
    return WeatherEntity(
      cityName: locationName,
      temperatureCelsius: tempC,
      condition: conditionText,
      lastUpdated: DateTime.now(),
    );
  }
}