import 'package:flutter/material.dart';
import 'package:weather_app/screens/home_screen.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
