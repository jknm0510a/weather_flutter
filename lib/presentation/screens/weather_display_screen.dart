import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_flutter/presentation/widgets/hour_weather_list_item.dart';
import 'package:weather_flutter/presentation/widgets/week_weather_list_item.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg_full_day.webp', // 您的圖片路徑
            fit: BoxFit.cover, // 讓圖片填滿整個螢幕，可能會被裁切
            height: double.infinity,
            width: double.infinity,
          ),
          SafeArea(child: Consumer<WeatherProvider>(
            builder: (context, provider, child) {
              // 根據 provider 的狀態來決定顯示什麼
              if (provider.isLoading) {
                // 狀態1: 載入中
                return const CircularProgressIndicator();
              } else if (provider.weatherEntity != null) {
                // 狀態2: 成功取得天氣資料
                final weather = provider.weatherEntity!;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // **當前天氣卡片**
                        WeatherCard(
                          cityName: weather.cityName,
                          temperature: weather.currentWeather.temperatureC,
                          weatherCondition: weather.currentWeather.conditionText,
                          iconCode: weather.currentWeather.conditionIcon,
                          windSpeed: weather.currentWeather.windSpeedKph,
                          humidity: weather.currentWeather.humidity,
                        ),
                        // const SizedBox(height: 16),

                        // **每小時預報標題**
                        const SizedBox(height: 8),

                        // **每小時預報水平滾動列表**
                        SizedBox(
                          height: 130, // 給水平列表一個固定的高度
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: weather.hourlyForecast.length,
                            itemBuilder: (context, index) {
                              final hourly = weather.hourlyForecast[index];
                              return HourWeatherListItem(
                                time: hourly.time,
                                conditionIcon: hourly.conditionIcon.isNotEmpty ? hourly.conditionIcon : '',
                                temperatureC: hourly.temperatureC,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // **每日預報標題**
                        const SizedBox(height: 8),

                        // **每日預報垂直列表**
                        ListView.builder(
                          shrinkWrap: true, // 讓 ListView 在 Column 中只佔用所需高度
                          physics: const NeverScrollableScrollPhysics(), // 禁用內部滾動，由外層的 SingleChildScrollView 統一滾動
                          itemCount: weather.dailyForecast.length,
                          itemBuilder: (context, index) {
                            final daily = weather.dailyForecast[index];
                            return WeekWeatherListItem(
                                dayOfWeek: daily.dayOfWeek,
                                maxTempC: daily.maxTempC,
                                minTempC: daily.minTempC,
                                conditionIcon: daily.conditionIcon.isNotEmpty ? daily.conditionIcon : '',
                                chanceOfRain: daily.chanceOfRain
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
          ))
        ],
      )
    );
  }


}