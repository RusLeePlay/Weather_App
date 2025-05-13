import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/weather_provider.dart';

class WeatherDetaleScreen extends StatelessWidget {
  const WeatherDetaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Container(
      margin: const EdgeInsets.only(right: 10, left: 2),
      decoration: BoxDecoration(
        color: weatherProvider.isDayTime
            ? const Color.fromARGB(180, 138, 123, 143)
            : const Color.fromARGB(180, 101, 89, 105),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
