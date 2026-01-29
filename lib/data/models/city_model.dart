import '../../domain/entities/city_entity.dart';

class CityModel {
  final name;
  final country;

  const CityModel({
    required this.name,
    required this.country,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    final countryName = json['name']['common'] as String;
    final List<dynamic>? capitals = json['capital'] as List<dynamic>?;
    final cityName = (capitals != null && capitals.isNotEmpty)
      ? capitals[0] as String
      : countryName;

    return CityModel(
        name: cityName,
        country: countryName
    );
  }

  CityEntity toEntity() {
    return CityEntity(
      name: name,
      country: country,
    );
  }
}