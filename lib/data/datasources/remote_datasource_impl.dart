import 'dart:convert';

import 'package:weather_flutter/data/datasources/remote_datasource.dart';
import 'package:weather_flutter/data/models/city_model.dart';
import 'package:weather_flutter/data/models/weather_model.dart';
import 'package:http/http.dart' as http;

import '../../core/errors/exceptions.dart';
import '../models/forecast_weather_model.dart';

class RemoteDatasourceImpl implements RemoteDataSource{
  final http.Client client;

  final String _apiKey = '43efdc20b2db4cb2bc453308252910';
  final String _weatherApiBaseUrl = 'http://api.weatherapi.com/v1';
  final String _cityApiBaseUrl = 'https://restcountries.com/v3.1/all?fields=name,capitalInfo,cca2,capital';

  const RemoteDatasourceImpl({required this.client});

  @override
  Future<List<CityModel>> fetchCitiesFromApi() async {
    final response = await client.get(
      Uri.parse(_cityApiBaseUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => CityModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(
        message: 'Failed to fetch cities from API.',
        statusCode: response.statusCode,
        url: _cityApiBaseUrl
      );
    }
  }

  @override
  Future<WeatherModel> fetchWeatherFromApi(String query) async {
    final uri = Uri.parse('$_weatherApiBaseUrl/current.json?key=$_apiKey&q=$query');
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return WeatherModel.fromJson(json);
    } else {
      throw ServerException(
          message: 'Failed to fetch weather from API.',
          statusCode: response.statusCode,
          url: _weatherApiBaseUrl
      );
    }
  }

  @override
  Future<ForecastWeatherModel> fetchForecastWeatherFromApi(String query, {int days = 7}) async {
    final uri = Uri.parse('$_weatherApiBaseUrl/forecast.json?key=$_apiKey&q=$query&days=$days');
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      // 使用我們新建立的 ForecastWeatherModel.fromJson 來解析
      return ForecastWeatherModel.fromJson(json);
    } else {
      throw ServerException(
          message: 'Failed to fetch forecast weather from API.',
          statusCode: response.statusCode,
          url: uri.toString()
      );
    }
  }


}