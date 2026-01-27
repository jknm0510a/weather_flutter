import '../repositories/weather_repository.dart';

abstract class BaseUseCase<T> {
  final WeatherRepository weatherRepository;
  const BaseUseCase(this.weatherRepository,);
}