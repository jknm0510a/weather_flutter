import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:weather_flutter/data/datasources/remote_datasource_impl.dart';
import 'package:weather_flutter/data/repositories/location_repository_impl.dart';
import 'package:weather_flutter/data/repositories/weather_repository_impl.dart';

import 'domain/usecases/get_cities_usecase.dart';
import 'domain/usecases/get_weather_for_city_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  
  sl.registerLazySingleton(
      () => RemoteDatasourceImpl(client: sl())
  );
  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton(
      () => WeatherRepositoryImpl(remoteDataSource: sl())
  );
  sl.registerLazySingleton(() => LocationRepositoryImpl());
  sl.registerLazySingleton(() => GetWeatherForCityUseCase(sl()));
  sl.registerLazySingleton(() => GetCitiesUseCase(sl()));
  
}