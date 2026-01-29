import '../entities/city_entity.dart';
import '../entities/weather_entity.dart';

abstract class WeatherRepository  {
  Future<WeatherEntity> getWeatherForQuery(String query);
  Future<List<CityEntity>> getCities();
}