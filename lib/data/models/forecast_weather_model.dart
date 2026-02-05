// 主模型，對應 CityForecastWeatherData
import '../../domain/entities/forecast_weather_entity.dart';
import 'package:intl/intl.dart';

class ForecastWeatherModel {
  final LocationModel location;
  final CurrentModel current;
  final ForecastModel forecast;

  const ForecastWeatherModel({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory ForecastWeatherModel.fromJson(Map<String, dynamic> json) {
    return ForecastWeatherModel(
      location: LocationModel.fromJson(json['location']),
      current: CurrentModel.fromJson(json['current']),
      forecast: ForecastModel.fromJson(json['forecast']),
    );
  }

  ForecastWeatherEntity toEntity() {
    return ForecastWeatherEntity(
      cityName: location.name,
      currentWeather: current.toEntity(),
      hourlyForecast: _createHourlyForecast(),
      dailyForecast: forecast.forecastday.map((day) => day.toEntity()).toList(),
    );
  }

  // 在 ForecastWeatherModel 類別的 } 之後，但在檔案的結尾之前，加入這個私有輔助方法
  List<HourlyWeatherEntity> _createHourlyForecast() {
    final now = DateTime.now();
    final List<HourModel> allHours = [];

    // 將今天和明天的每小時預報資料合併
    if (forecast.forecastday.isNotEmpty) {
      allHours.addAll(forecast.forecastday[0].hour);
      if (forecast.forecastday.length > 1) {
        allHours.addAll(forecast.forecastday[1].hour);
      }
    }

    // 找到從現在開始的下 24 個小時
    final upcomingHours = allHours.where((hour) {
      return DateTime.fromMillisecondsSinceEpoch(hour.time_epoch * 1000).isAfter(now);
    }).take(24).toList();

    // 將 HourModel 轉換為 UI 需要的 HourlyWeatherEntity
    return upcomingHours.map((hour) {
      final hourDateTime = DateTime.fromMillisecondsSinceEpoch(hour.time_epoch * 1000);
      return HourlyWeatherEntity(
        time: DateFormat('HH:mm').format(hourDateTime), // 格式化為 "23:00"
        temperatureC: hour.temp_c,
        conditionIcon: hour.condition.icon,
        isDay: hour.is_day == 1,
      );
    }).toList();
  }

}

// --- 以下是所有子模型的完整定義 ---

class LocationModel {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final int localtimeEpoch;
  final String localtime;

  const LocationModel({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
      tzId: json['tz_id'],
      localtimeEpoch: json['localtime_epoch'],
      localtime: json['localtime'],
    );
  }
}

class CurrentModel {
  final int lastUpdatedEpoch;
  final String lastUpdated;
  final double tempC;
  final double tempF;
  final int isDay;
  final ConditionModel condition;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double pressureMb;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double uv;

  const CurrentModel({
    required this.lastUpdatedEpoch,
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.uv,
  });

  factory CurrentModel.fromJson(Map<String, dynamic> json) {
    return CurrentModel(
      lastUpdatedEpoch: json['last_updated_epoch'],
      lastUpdated: json['last_updated'],
      tempC: json['temp_c'],
      tempF: json['temp_f'],
      isDay: json['is_day'],
      condition: ConditionModel.fromJson(json['condition']),
      windMph: json['wind_mph'],
      windKph: json['wind_kph'],
      windDegree: json['wind_degree'],
      windDir: json['wind_dir'],
      pressureMb: json['pressure_mb'],
      humidity: json['humidity'],
      cloud: json['cloud'],
      feelslikeC: json['feelslike_c'],
      uv: json['uv'],
    );
  }

  CurrentWeatherEntity toEntity() {
    return CurrentWeatherEntity(
      temperatureC: tempC,
      conditionText: condition.text,
      conditionIcon: condition.icon,
      windSpeedKph: windKph,
      humidity: humidity,
      isDay: isDay == 1,
    );
  }

}

class ConditionModel {
  final String text;
  final String icon;
  final int code;

  const ConditionModel({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory ConditionModel.fromJson(Map<String, dynamic> json) {
    return ConditionModel(
      text: json['text'],
      icon: "https:${json['icon']}",
      code: json['code'],
    );
  }
}

class ForecastModel {
  final List<ForecastDayModel> forecastday;

  const ForecastModel({required this.forecastday});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      forecastday: (json['forecastday'] as List)
          .map((day) => ForecastDayModel.fromJson(day))
          .toList(),
    );
  }

  List<DailyWeatherEntity> toEntity() {
    // 使用 map 將 List<ForecastDayModel> 轉換為 List<DailyWeatherEntity>
    return forecastday.map((dayModel) => dayModel.toEntity()).toList();
  }

}

class ForecastDayModel {
  final String date;
  final int dateEpoch;
  final DayModel day;
  final List<HourModel> hour;

  const ForecastDayModel({
    required this.date,
    required this.dateEpoch,
    required this.day,
    required this.hour,
  });

  factory ForecastDayModel.fromJson(Map<String, dynamic> json) {
    return ForecastDayModel(
      date: json['date'],
      dateEpoch: json['date_epoch'],
      day: DayModel.fromJson(json['day']),
      hour: (json['hour'] as List)
          .map((h) => HourModel.fromJson(h))
          .toList(),
    );
  }

  DailyWeatherEntity toEntity() {
    final date = DateTime.fromMillisecondsSinceEpoch(dateEpoch * 1000);
    return DailyWeatherEntity(
      dayOfWeek: DateFormat('EEE').format(date), // 將日期轉為星期 (例如 "Mon")
      conditionIcon: day.condition.icon,
      maxTempC: day.maxtempC,
      minTempC: day.mintempC,
      chanceOfRain: day.dailyChanceOfRain,
      humidity: day.avghumidity,
    );
  }

}


class DayModel {
  final double maxtempC;
  final double mintempC;
  final double avgtempC;
  final double maxwindKph;
  final double totalprecipMm;
  final int avghumidity;
  final int dailyChanceOfRain;
  final ConditionModel condition;
  final double uv;

  const DayModel({
    required this.maxtempC,
    required this.mintempC,
    required this.avgtempC,
    required this.maxwindKph,
    required this.totalprecipMm,
    required this.avghumidity,
    required this.dailyChanceOfRain,
    required this.condition,
    required this.uv,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      maxtempC: json['maxtemp_c'],
      mintempC: json['mintemp_c'],
      avgtempC: json['avgtemp_c'],
      maxwindKph: json['maxwind_kph'],
      totalprecipMm: json['totalprecip_mm'],
      avghumidity: (json['avghumidity'] as num).toInt(),
      dailyChanceOfRain: json['daily_chance_of_rain'],
      condition: ConditionModel.fromJson(json['condition']),
      uv: json['uv'],
    );
  }
}

class HourModel {
  final int time_epoch;
  final String time;
  final double temp_c;
  final int is_day;
  final ConditionModel condition;

  const HourModel({
    required this.time_epoch,
    required this.time,
    required this.temp_c,
    required this.is_day,
    required this.condition,
  });

  factory HourModel.fromJson(Map<String, dynamic> json) {
    return HourModel(
      time_epoch: json['time_epoch'],
      time: json['time'],
      temp_c: json['temp_c'],
      is_day: json['is_day'],
      condition: ConditionModel.fromJson(json['condition']),
    );
  }
}


