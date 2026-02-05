import '../entities/city_entity.dart';
import '../entities/forecast_weather_entity.dart';
import '../entities/weather_entity.dart';

abstract class WeatherRepository  {
  Future<ForecastWeatherEntity> getWeatherForQuery(String query);
  Future<List<CityEntity>> getCities();
}