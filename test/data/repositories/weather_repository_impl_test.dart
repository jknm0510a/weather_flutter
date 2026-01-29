import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:weather_flutter/data/repositories/weather_repository_impl.dart';
import 'package:weather_flutter/data/datasources/remote_datasource.dart';
import 'package:weather_flutter/domain/entities/weather_entity.dart';
import 'package:weather_flutter/data/models/weather_model.dart';
import 'package:weather_flutter/core/errors/exceptions.dart';

@GenerateMocks([RemoteDataSource])
import 'weather_repository_impl_test.mocks.dart'; // 2. 引入一個「尚不存在」的檔案


void main() {
  late WeatherRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = WeatherRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const testQuery = 'London';
  const testWeatherModel = WeatherModel(
    locationName: 'London',
    region: 'City of London, Greater London',
    tempC: 10.0,
    conditionText: 'Sunny',
    conditionIconUrl: 'https://cdn.weatherapi.com/weather/64x64/day/113.png',
  );
  final testWeatherEntity = testWeatherModel.toEntity();

  test('should return WeatherEntity when the call to remote data source is successful', () async {
    when(mockRemoteDataSource.fetchWeatherFromApi(any))
      .thenAnswer((_) async => testWeatherModel);
    final result = await repository.getWeatherForQuery(testQuery);
    expect(result.cityName, testWeatherEntity.cityName);
    expect(result.temperatureCelsius, testWeatherEntity.temperatureCelsius);
    expect(result.condition, testWeatherEntity.condition);
    // 對於 lastUpdated，我們不檢查它的精確值，但可以做一個合理的驗證，例如確認它是一個最近的時間點
    expect(result.lastUpdated, isA<DateTime>());
    expect(result.lastUpdated.isAfter(DateTime.now().subtract(const Duration(seconds: 1))), isTrue);

    verify(mockRemoteDataSource.fetchWeatherFromApi(testQuery)); // 驗證 fetchWeatherFromApi 是否被以正確的參數呼叫
    verifyNoMoreInteractions(mockRemoteDataSource); // 驗證沒有其他多餘的互動
  });

  test('should rethrow ServerException when the call to remote data source is unsuccessful', () async {
    // 當 mockRemoteDataSource 的 fetchWeatherFromApi 被呼叫時，就拋出一個 ServerException
    when(mockRemoteDataSource.fetchWeatherFromApi(any))
      .thenThrow(const ServerException());
    final call = repository.getWeatherForQuery;
    // 驗證呼叫 `call(testQuery)` 是否會拋出一個 ServerException
    expect(() => call(testQuery), throwsA(isA<ServerException>()));
  });
}