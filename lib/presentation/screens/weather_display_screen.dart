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
              return WeatherCard(
                cityName: provider.weatherEntity!.cityName,
                temperature: provider.weatherEntity!.temperatureCelsius,
                weatherCondition: provider.weatherEntity!.condition,
                iconCode: '',//provider.weatherEntity!.iconCode,
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