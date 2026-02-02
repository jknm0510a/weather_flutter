import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CityListItem extends StatelessWidget {
  final String cityName;
  final VoidCallback onTap;
  const CityListItem({
    Key? key,
    required this.cityName,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
      child: ListTile(
        title: Text(cityName),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

}