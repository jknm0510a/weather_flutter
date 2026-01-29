import 'package:weather_flutter/domain/usecases/base_usecase.dart';

import '../entities/weather_entity.dart';
import '../repositories/location_repository.dart';

class GetWeatherForCurrentLocationUseCase extends BaseUseCase {
  final LocationRepository locationRepository;

  const GetWeatherForCurrentLocationUseCase({
    required weatherRepository,
    required this.locationRepository
  }): super(weatherRepository);

  Future<WeatherEntity> execute() async {
    final currentLocation = await locationRepository.getCurrentLocation();
    final coordinateString = '${currentLocation.latitude},${currentLocation.longitude}';

    return weatherRepository.getWeatherForQuery(coordinateString);
  }
}