import 'package:weather_flutter/domain/entities/city_entity.dart';
import 'package:weather_flutter/domain/entities/forecast_weather_entity.dart';
import 'package:weather_flutter/domain/entities/weather_entity.dart';
import 'package:weather_flutter/domain/repositories/weather_repository.dart';

import '../../core/errors/exceptions.dart';
import '../datasources/remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final RemoteDataSource remoteDataSource;

  const WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CityEntity>> getCities() async {
    try {
      final list = await remoteDataSource.fetchCitiesFromApi();
      return list.map((cityModel) => cityModel.toEntity()).toList();
    }on ServerException catch (e) {
      //TODO do something with the error
      print('ServerException caught in repository: ${e.message}');
      rethrow;
    } catch(e) {
      //TODO do something with the error
      print('Unexpected error caught in repository: $e');
      throw const ServerException(message: '未預期的錯誤發生');
    }
  }

  @override
  Future<ForecastWeatherEntity> getWeatherForQuery(String query) async {
    try {
      final weatherModel = await remoteDataSource.fetchForecastWeatherFromApi(query);
      return weatherModel.toEntity();
    } on ServerException catch (e) {
      //TODO do something with the error
      print('ServerException caught in repository: ${e.message}');
      rethrow;
    } catch(e) {
      //TODO do something with the error
      print('Unexpected error caught in repository: $e');
      throw const ServerException(message: '未預期的錯誤發生');
    }
  }
}