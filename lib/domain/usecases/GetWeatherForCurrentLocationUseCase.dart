import 'package:weather_flutter/domain/usecases/BaseUseCase.dart';

import '../entities/WeatherEntity.dart';

class GetWeatherForCurrentLocationUseCase extends BaseUseCase {
  const GetWeatherForCurrentLocationUseCase(
      weatherRepository,
  ): super(weatherRepository);

  Future<WeatherEntity> execute() {
    return weatherRepository.getWeatherForCurrentLocation();
  }
}