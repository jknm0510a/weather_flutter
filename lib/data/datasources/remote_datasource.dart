import '../models/city_model.dart';
import '../models/forecast_weather_model.dart';
import '../models/weather_model.dart';

abstract class RemoteDataSource {
  Future<WeatherModel> fetchWeatherFromApi(String query);
  Future<List<CityModel>> fetchCitiesFromApi();
  Future<ForecastWeatherModel> fetchForecastWeatherFromApi(String query, {int days});
}