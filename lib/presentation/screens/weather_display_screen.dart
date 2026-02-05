import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import 'city_list_screen.dart';

class WeatherDisplayScreen extends StatefulWidget {
  const WeatherDisplayScreen({Key? key}) : super(key: key);

  @override
  State<WeatherDisplayScreen> createState() => _WeatherDisplayScreenState();
}

class _WeatherDisplayScreenState extends State<WeatherDisplayScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeatherForCurrentLocation();
    });
    super.initState();
  }

  void _navigateToCityList(BuildContext context) async {
    // 使用 await 來等待 CityListScreen 返回結果
    final selectedCity = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CityListScreen()),
    );

    if (selectedCity != null && selectedCity is String) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeather(selectedCity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('天氣資訊'),
        actions: [
          // 在 AppBar 右上角新增一個切換城市的按鈕
          IconButton(
            icon: const Icon(Icons.location_city),
            onPressed: () => _navigateToCityList(context), // 點擊時觸發導航
          ),
        ],
      ),
      body: Center(
        // 使用 Consumer 來監聽 WeatherProvider 的變化
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            // 根據 provider 的狀態來決定顯示什麼
            if (provider.isLoading) {
              // 狀態1: 載入中
              return const CircularProgressIndicator();
            } else if (provider.weatherEntity != null) {
              // 狀態2: 成功取得天氣資料
              final weather = provider.weatherEntity!;
              return SingleChildScrollView( // 使用 SingleChildScrollView 讓內容超出螢幕時可以滾動
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // **當前天氣卡片**
                      WeatherCard(
                        cityName: weather.cityName,
                        temperature: weather.currentWeather.temperatureC,
                        weatherCondition: weather.currentWeather.conditionText,
                        iconCode: weather.currentWeather.conditionIcon,
                      ),
                      const SizedBox(height: 16),

                      // **每小時預報標題**
                      const Text('24小時預報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),

                      // **每小時預報水平滾動列表**
                      SizedBox(
                        height: 100, // 給水平列表一個固定的高度
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: weather.hourlyForecast.length,
                          itemBuilder: (context, index) {
                            final hourly = weather.hourlyForecast[index];
                            // 這裡我們先用簡單的 Text 顯示，您可以之後將其封裝成獨立的 Widget
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(hourly.time),
                                    // 這裡應該顯示圖示，我們先用文字代替
                                    Text(hourly.conditionIcon.isNotEmpty ? 'Icon' : ''),
                                    Text('${hourly.temperatureC.round()}°'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // **每日預報標題**
                      const Text('7日預報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),

                      // **每日預報垂直列表**
                      ListView.builder(
                        shrinkWrap: true, // 讓 ListView 在 Column 中只佔用所需高度
                        physics: const NeverScrollableScrollPhysics(), // 禁用內部滾動，由外層的 SingleChildScrollView 統一滾動
                        itemCount: weather.dailyForecast.length,
                        itemBuilder: (context, index) {
                          final daily = weather.dailyForecast[index];
                          // 這裡我們先用 ListTile 顯示，您可以之後將其封裝成獨立的 Widget
                          return Card(
                            child: ListTile(
                              leading: Text(daily.dayOfWeek),
                              title: Text('最高 ${daily.maxTempC.round()}° / 最低 ${daily.minTempC.round()}°'),
                              subtitle: Text('濕度: ${daily.humidity}%'),
                              trailing: Text('降雨機率: ${daily.chanceOfRain}%'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (provider.errorMessage != null) {
              // 狀態3: 發生錯誤
              return Text('錯誤: ${provider.errorMessage}');
            } else {
              // 狀態4: 初始狀態，或沒有任何資料
              return const Text('請點擊右上角按鈕來選擇城市');
            }
          },
        ),
      ),
    );
  }


}