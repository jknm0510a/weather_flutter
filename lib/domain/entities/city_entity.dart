import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String name;
  final String country;

  const CityEntity({
    required this.name,
    required this.country,
  });

  @override
  List<Object?> get props => [
    name,
    country
  ];
}