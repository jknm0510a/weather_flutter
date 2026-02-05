import 'package:flutter/cupertino.dart';
import 'package:weather_flutter/domain/usecases/get_weather_for_current_location_usecase.dart';

import '../../domain/entities/city_entity.dart';
import '../../domain/entities/forecast_weather_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/get_cities_usecase.dart';
import '../../domain/usecases/get_weather_for_city_usecase.dart';

class WeatherProvider extends ChangeNotifier {
  bool isLoading = false;
  ForecastWeatherEntity? weatherEntity;
  List<CityEntity> cities = [];
  String? errorMessage;
  final GetWeatherForCityUseCase getWeatherForCityUseCase;
  final GetCitiesUseCase getCitiesUseCase;
  final GetWeatherForCurrentLocationUseCase getWeatherForCurrentLocationUseCase;

  WeatherProvider({
    required this.getWeatherForCityUseCase,
    required this.getCitiesUseCase,
    required this.getWeatherForCurrentLocationUseCase,
  });

  Future<void> fetchWeather(String cityName) async {
    isLoading = true;
    notifyListeners();
    try {
      weatherEntity = await getWeatherForCityUseCase.execute(cityName);
      errorMessage = null;
    } catch(e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCities() async {
    isLoading = true;
    notifyListeners();
    try {
      cities = await getCitiesUseCase.execute();
      errorMessage = null;
    } catch(e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherForCurrentLocation() async {
    isLoading = true;
    notifyListeners();
    try {
      weatherEntity = await getWeatherForCurrentLocationUseCase.execute();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}