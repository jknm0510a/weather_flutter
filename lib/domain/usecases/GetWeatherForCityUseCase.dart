import '../entities/WeatherEntity.dart';
import 'BaseUseCase.dart';

class GetWeatherForCityUseCase extends BaseUseCase<WeatherEntity> {
  Future<WeatherEntity> execute(String cityName) {
    return weatherRepository.getWeatherForCity(cityName);
  }
  const GetWeatherForCityUseCase(
      weatherRepository,
  ): super(weatherRepository);
}