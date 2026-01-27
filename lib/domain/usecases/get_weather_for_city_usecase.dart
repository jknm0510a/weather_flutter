import '../entities/weather_entity.dart';
import 'base_usecase.dart';

class GetWeatherForCityUseCase extends BaseUseCase<WeatherEntity> {
  Future<WeatherEntity> execute(String cityName) {
    return weatherRepository.getWeatherForCity(cityName);
  }
  const GetWeatherForCityUseCase(
      weatherRepository,
  ): super(weatherRepository);
}