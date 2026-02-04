import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:weather_flutter/core/errors/exceptions.dart';
import 'package:weather_flutter/data/datasources/remote_datasource_impl.dart';
import 'package:weather_flutter/data/models/forecast_weather_model.dart';

// 引入 mockito 產生的檔案
import 'remote_datasource_impl_test.mocks.dart';


// 這是您要求的「可以拿來用的資料」，一個模擬的 JSON 字串
const String mockForecastResponse = """
   {
       "location": {
           "name": "Taipei",
           "region": "Taipei City",
           "country": "Taiwan",
           "lat": 25.05,
           "lon": 121.53,
           "tz_id": "Asia/Taipei",
           "localtime_epoch": 1675663200,
           "localtime": "2024-02-06 14:00"
       },
       "current": {
           "last_updated_epoch": 1675662300,
           "last_updated": "2024-02-06 13:45",
           "temp_c": 25.0,
           "temp_f": 77.0,
           "is_day": 1,
           "condition": {
               "text": "Sunny",
               "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
               "code": 1000
           },
           "wind_mph": 5.6,
           "wind_kph": 9.0,
           "wind_degree": 180,
           "wind_dir": "S",
           "pressure_mb": 1012.0,
           "humidity": 50,
           "cloud": 0,
           "feelslike_c": 26.0,
           "uv": 6.0
       },
       "forecast": {
           "forecastday": [
               {
                   "date": "2024-02-06",
                   "date_epoch": 1675622400,
                   "day": {
                       "maxtemp_c": 28.0,
                       "mintemp_c": 22.0,
                       "avgtemp_c": 25.0,
                       "maxwind_kph": 15.0,
                       "totalprecip_mm": 0.0,
                       "avghumidity": 45,
                       "daily_chance_of_rain": 0,
                       "condition": {
                           "text": "Partly cloudy",
                           "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                           "code": 1003
                       },
                       "uv": 7.0
                   }
               }
           ]
       }
   }
   """;

@GenerateMocks([http.Client])
void main() {
  late MockClient mockHttpClient;
  late RemoteDatasourceImpl datasource;

  setUp(() {
    mockHttpClient = MockClient();
    datasource = RemoteDatasourceImpl(client: mockHttpClient);
  });
  group('fetchForecastWeatherFromApi', () {
    const tQuery = 'Taipei';
    const tDays = 7;
    final tUri =
    Uri.parse('http://api.weatherapi.com/v1/forecast.json?key=43efdc20b2db4cb2bc453308252910&q=$tQuery&days=$tDays');
    test('should return ForecastWeatherModel when the response code is 200 (success)', () async {
      // Arrange: 設定 mock client
      when(mockHttpClient.get(tUri, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(mockForecastResponse, 200));

      // Act: 呼叫要測試的方法
      final result = await datasource.fetchForecastWeatherFromApi(tQuery, days: tDays);

      // Assert: 驗證結果
      expect(result, isA<ForecastWeatherModel>());
      expect(result.location.name, 'Taipei');
      expect(result.forecast.forecastday.length, 1);
    });

  });
}