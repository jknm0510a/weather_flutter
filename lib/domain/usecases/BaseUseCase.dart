import '../repositories/WeatherRepository.dart';

abstract class BaseUseCase<T> {
  final WeatherRepository weatherRepository;
  const BaseUseCase(this.weatherRepository,);
}