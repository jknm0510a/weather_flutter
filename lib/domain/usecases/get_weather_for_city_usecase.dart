import '../entities/forecast_weather_entity.dart';
import '../entities/weather_entity.dart';
import 'base_usecase.dart';

class GetWeatherForCityUseCase extends BaseUseCase<WeatherEntity> {
  Future<ForecastWeatherEntity> execute(String cityName) {
    return weatherRepository.getWeatherForQuery(cityName);
  }
  const GetWeatherForCityUseCase(
      weatherRepository,
  ): super(weatherRepository);
}