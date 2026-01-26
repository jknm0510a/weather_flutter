import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable{
  final String cityName;
  final double temperatureCelsius;
  final String condition;
  final DateTime lastUpdated;

  const WeatherEntity({
    required this.cityName,
    required this.temperatureCelsius,
    required this.condition,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    cityName,
    temperatureCelsius,
    condition,
    lastUpdated,
  ];
  
}