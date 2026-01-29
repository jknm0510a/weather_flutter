import '../models/city_model.dart';
import '../models/weather_model.dart';

abstract class RemoteDataSource {
  Future<WeatherModel> fetchWeatherFromApi(String query);
  Future<List<CityModel>> fetchCitiesFromApi();
}