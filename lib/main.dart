import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
        ),
        Provider(
          create: (_) => LocationService(),
        )
      ],
      child: const Application(),
    ),
  );
}
