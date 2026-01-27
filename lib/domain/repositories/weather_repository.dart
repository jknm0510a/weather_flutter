import '../entities/city_entity.dart';
import '../entities/weather_entity.dart';

abstract class WeatherRepository  {
  Future<WeatherEntity> getWeatherForCity(String cityName);
  Future<WeatherEntity> getWeatherForCurrentLocation(); // 假設經緯度處理在 data 層
  Future<List<CityEntity>> getCities();
}