import 'package:equatable/equatable.dart';

class ForecastWeatherEntity extends Equatable {
  final String cityName;
  final CurrentWeatherEntity currentWeather;
  final List<HourlyWeatherEntity> hourlyForecast;
  final List<DailyWeatherEntity> dailyForecast;

  const ForecastWeatherEntity({
    required this.cityName,
    required this.currentWeather,
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  @override
  List<Object?> get props => [
    cityName,
    currentWeather,
    hourlyForecast,
    dailyForecast,
  ];
}

// 當前天氣實體
class CurrentWeatherEntity extends Equatable {
  final double temperatureC;
  final String conditionText;
  final String conditionIcon;
  final double windSpeedKph;
  final int humidity;
  final bool isDay; // 用於判斷白天或夜晚背景

  const CurrentWeatherEntity({
    required this.temperatureC,
    required this.conditionText,
    required this.conditionIcon,
    required this.windSpeedKph,
    required this.humidity,
    required this.isDay,
  });

  @override
  List<Object?> get props => [
    temperatureC,
    conditionText,
    conditionIcon,
    windSpeedKph,
    humidity,
    isDay,
  ];
}

// 每小時天氣預報實體
class HourlyWeatherEntity extends Equatable {
  final String time; // 例如 "Now", "23:00"
  final double temperatureC;
  final String conditionIcon;
  final bool isDay; // 判斷該時段是白天或夜晚，用於顯示不同圖示或背景

  const HourlyWeatherEntity({
    required this.time,
    required this.temperatureC,
    required this.conditionIcon,
    required this.isDay,
  });

  @override
  List<Object?> get props => [
    time,
    temperatureC,
    conditionIcon,
    isDay,
  ];
}

// 每日天氣預報實體
class DailyWeatherEntity extends Equatable {
  final String dayOfWeek; // 例如 "Today", "Wed"
  final String conditionIcon;
  final double maxTempC;
  final double minTempC;
  final int chanceOfRain; // 降雨機率，從 DayModel.dailyChanceOfRain 轉換
  final int humidity; // 濕度，從 DayModel.avghumidity 轉換

  const DailyWeatherEntity({
    required this.dayOfWeek,
    required this.conditionIcon,
    required this.maxTempC,
    required this.minTempC,
    required this.chanceOfRain,
    required this.humidity,
  });

  @override
  List<Object?> get props => [
    dayOfWeek,
    conditionIcon,
    maxTempC,
    minTempC,
    chanceOfRain,
    humidity,
  ];
}
