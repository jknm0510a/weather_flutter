import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:weather_flutter/data/datasources/remote_datasource_impl.dart';
import 'package:weather_flutter/data/repositories/location_repository_impl.dart';
import 'package:weather_flutter/data/repositories/weather_repository_impl.dart';
import 'package:weather_flutter/domain/usecases/get_weather_for_current_location_usecase.dart';

import 'data/datasources/remote_datasource.dart';
import 'domain/repositories/location_repository.dart';
import 'domain/repositories/weather_repository.dart';
import 'domain/usecases/get_cities_usecase.dart';
import 'domain/usecases/get_weather_for_city_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerFactory(() => GetWeatherForCityUseCase(sl<WeatherRepository>()));
  sl.registerFactory(() => GetCitiesUseCase(sl<WeatherRepository>()));
  sl.registerFactory(() => GetWeatherForCurrentLocationUseCase(
    weatherRepository: sl<WeatherRepository>(),
    locationRepository: sl<LocationRepository>(),
  ));

  sl.registerLazySingleton<WeatherRepository>(
          () => WeatherRepositoryImpl(remoteDataSource: sl<RemoteDataSource>()));
  sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl());

  sl.registerLazySingleton<RemoteDataSource>(
          () => RemoteDatasourceImpl(client: sl<http.Client>()));
  
}