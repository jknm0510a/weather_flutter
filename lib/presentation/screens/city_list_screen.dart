import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/city_entity.dart';
import '../providers/weather_provider.dart';
import '../widgets/city_list_item.dart';

class CityListScreen extends StatefulWidget {
  const CityListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CityEntity> _cities = [];
  List<CityEntity> _filteredCities = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCities();
    });
    _searchController.addListener(_filterCities);
  }

  Future<void> _fetchCities() async {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    await provider.fetchCities();

    setState(() {
      // 從 Provider 更新城市列表
      _cities = provider.cities;
      _filteredCities = _cities;
    });
  }


  @override
  void dispose() {
    _searchController.removeListener(_filterCities);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // 根據搜尋文字過濾城市列表
      _filteredCities = _cities
          .where((city) => city.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _navigateToWeatherDisplay(String cityName) {
    // TODO: 在這裡實作導航到 WeatherDisplayScreen 的邏輯
    // 目前，您可以先顯示一個 Snackbar 作為提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('正在導航到 $cityName 的天氣資訊')),
    );
    // 未來您可能會這樣導航：
    // Navigator.pushNamed(context, WeatherDisplayScreen.routeName, arguments: cityName);
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('城市列表'), // 畫面標題
      ),
      body: provider.isLoading // 檢查是否正在載入
          ? const Center(child: CircularProgressIndicator()) // 如果是，顯示載入指示器
        : Column(
          children: [
            // 整合 SearchBar Widget
            SearchBar(
              controller: _searchController,
              onChanged: (value) => _filterCities(), // 當搜尋文字改變時，呼叫過濾方法
            ),
            // 整合城市列表
            Expanded( // Expanded 確保 ListView 填滿剩餘空間
              child: ListView.builder(
                itemCount: _filteredCities.length, // 列表項目數量
                itemBuilder: (context, index) {
                  final city = _filteredCities[index]; // 取得當前城市的名稱
                  return CityListItem(
                    cityName: city.name, // 將城市名稱傳給 CityListItem
                    onTap: () => _navigateToWeatherDisplay(city.name), // 點擊時導航
                  );
                },
              ),
            ),
          ],
        ),
    );
  }

}