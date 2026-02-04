import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:weather_flutter/data/datasources/remote_datasource_impl.dart';

void main() {
  test('Fetch real forecast data from API and check parsing', () async {
    // Arrange: 建立真實的 http 客戶端和 datasource
    final httpClient = http.Client();
    final datasource = RemoteDatasourceImpl(client: httpClient);
    const cityName = 'Taipei'; // 您可以換成任何想測試的城市

    // Act & Assert
    try {
      print('Fetching real data for $cityName...');

      // 呼叫真實的 API
      final result = await datasource.fetchForecastWeatherFromApi(cityName);

      // 如果沒有拋出錯誤，就表示請求和基本解析成功了
      print('Successfully fetched and parsed data!');
      print('City: ${result.location.name}');
      print('Current Temp: ${result.current.tempC}°C');
      print('Forecast days: ${result.forecast.forecastday.length}'); // 假設有第二天的資料

      // 驗證解析後的結果不為空
      expect(result, isNotNull);
      expect(result.location.name, isNotEmpty);

    } catch (e) {
      // 如果發生任何錯誤（網路、解析、API Key等），測試將失敗
      print('Test failed with exception: $e');
      fail('Test failed due to an exception: $e');
    } finally {
      // 關閉 http 客戶端
      httpClient.close();
    }
  }, timeout: const Timeout(Duration(seconds: 20))); // 設定較長的超時時間
}