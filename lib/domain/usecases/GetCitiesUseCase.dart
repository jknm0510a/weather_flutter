import '../entities/CityEntity.dart';
import 'BaseUseCase.dart';

class GetCitiesUseCase extends BaseUseCase<List<CityEntity>> {

  Future<List<CityEntity>> execute() {
    return weatherRepository.getCities();
  }

  @override
  const GetCitiesUseCase(
      weatherRepository,
  ): super(weatherRepository);

}