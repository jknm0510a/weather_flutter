import 'package:weather_flutter/domain/usecases/base_usecase.dart';

import '../entities/weather_entity.dart';

class GetWeatherForCurrentLocationUseCase extends BaseUseCase {
  const GetWeatherForCurrentLocationUseCase(
      weatherRepository,
  ): super(weatherRepository);

  Future<WeatherEntity> execute() {
    return weatherRepository.getWeatherForCurrentLocation();
  }
}