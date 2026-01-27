import '../entities/city_entity.dart';
import 'base_usecase.dart';

class GetCitiesUseCase extends BaseUseCase<List<CityEntity>> {

  Future<List<CityEntity>> execute() {
    return weatherRepository.getCities();
  }

  @override
  const GetCitiesUseCase(
      weatherRepository,
  ): super(weatherRepository);

}