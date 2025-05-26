import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/day_model.dart';
import 'package:weather_app/models/weather_animations.dart';
import 'package:weather_app/services/weather_repo.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherRepo _weatherRepo = WeatherRepo();

  List<DayModel> days = [];

  bool isLoading = true;

  double? currentTemp;
  bool isDayTime = true;

  Future<void> initFetchWeather(double latitude, double longitude) async {
    isLoading = true;
    notifyListeners();

    final data =
        await _weatherRepo.getWeather(latitude: latitude, longitude: longitude);

    if (data != null && data.containsKey('daily')) {
      final dailyData = data['daily'];
      final hourlyJson = data['hourly'];

      days = List.generate(
        dailyData['time'].length,
        (i) => DayModel.fromJson(dailyData, i, hourlyJson),
      );
      
      if (days.isNotEmpty) {
        final now = DateTime.now();
        final today = days[0];
        final sunriseTime = today.sunrise.toLocal();
        final sunsetTime = today.sunset.toLocal();

        isDayTime = now.isAfter(sunriseTime) && now.isBefore(sunsetTime);
      }
    }

    await getCurrentWeather(latitude, longitude);

    isLoading = false;
    notifyListeners();
  }

  Future<void> getCurrentWeather(double latitude, double longitude) async {
    final data = await _weatherRepo.getCurrentWeather(latitude, longitude);

    if (data != null) {
      currentTemp = data['temperature_2m'];
    }
    notifyListeners();
  }

  double? getTempMax(int dayIndex) =>
      (days.length > dayIndex) ? days[dayIndex].maxTmp : null;
  double? getTempMin(int dayIndex) =>
      (days.length > dayIndex) ? days[dayIndex].minTmp : null;

  String? getWeatherDescriptionByIndex(int index) {
    if (index < 0 || index >= days.length) {
      return 'no data';
    }
    return getWeatherDescription(days[index].weatherCode);
  }

  // double? getWindSpeeedByDay(int dayIndex) =>
  //     (days.length > dayIndex) ? days[dayIndex].windspeed : null;

  String? getWeatherDescription(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return 'Clear Sky';
      case 1:
        return 'Partly Cloudy';
      case 2:
        return 'Partly Cloudy';
      case 3:
        return 'Cloudy';
      case 45:
        return 'Fog';
      case 48:
        return 'Rime';
      case 51:
        return 'Drizzle';
      case 53:
        return 'Drizzle';
      case 55:
        return 'Drizzle';
      case 61:
        return 'Rain';
      case 63:
        return 'Rain';
      case 65:
        return 'Heavy Rain';
      case 71:
        return 'Snow';
      case 73:
        return 'Snow';
      case 75:
        return 'Heavy Snow';
      case 77:
        return 'Grains';
      case 80:
        return 'Rainfall';
      case 81:
        return 'Rainfall';
      case 82:
        return 'Heavy Rainfall';
      case 85:
        return 'Snowfall';
      case 86:
        return 'Heavy Snowfall';
      case 95:
        return 'Thunderstorm';
      case 96:
        return 'Hailstorm';
      default:
        return 'Unknow';
    }
  }

  Image getNightWeatherIcon(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return Image.asset('assets/icons/clear_sky_n.png',
            width: 40, height: 40);
      case 1:
        return Image.asset('assets/icons/cloudy_night.png',
            width: 40, height: 40);
      case 2:
        return Image.asset('assets/icons/cloudy_night.png',
            width: 40, height: 40);
      case 3:
        return Image.asset('assets/icons/cloudy_night.png',
            width: 40, height: 40);
      case 45:
        return Image.asset('assets/icons/fog_n.png', width: 40, height: 40);
      case 48:
        return Image.asset('assets/icons/rime_n.png', width: 40, height: 40);
      case 51:
        return Image.asset('assets/icons/drizzle_n.png', width: 40, height: 40);
      case 53:
        return Image.asset('assets/icons/drizzle_n.png', width: 40, height: 40);
      case 55:
        return Image.asset('assets/icons/drizzle_n.png', width: 40, height: 40);
      case 61:
        return Image.asset('assets/icons/rain_n.png', width: 40, height: 40);
      case 63:
        return Image.asset('assets/icons/rain_n.png', width: 40, height: 40);
      case 65:
        return Image.asset('assets/icons/heavy_rain_n.png',
            width: 40, height: 40);
      case 71:
        return Image.asset('assets/icons/snow_n.png', width: 40, height: 40);
      case 73:
        return Image.asset('assets/icons/snow_n.png', width: 40, height: 40);
      case 75:
        return Image.asset('assets/icons/heavy_snow_n.png',
            width: 40, height: 40);
      case 77:
        return Image.asset('assets/icons/grains_n.png', width: 40, height: 40);
      case 80:
        return Image.asset('assets/icons/heavy_rain_n.png',
            width: 40, height: 40);
      case 81:
        return Image.asset('assets/icons/heavy_rain_n.png',
            width: 40, height: 40);
      case 82:
        return Image.asset('assets/icons/heavy_rain_n.png',
            width: 40, height: 40);
      case 85:
      case 86:
        return Image.asset('assets/icons/heavy_snow_n.png',
            width: 40, height: 40);
      case 95:
      case 96:
        return Image.asset('assets/icons/thunder_n.png', width: 40, height: 40);
      default:
        return Image.asset('assets/icons/default.png', width: 40, height: 40);
    }
  }

  Image getDayWeatherIcon(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return Image.asset('assets/icons/clear_sky.png', width: 40, height: 40);
      case 1:
        return Image.asset('assets/icons/partly_cloud.png',
            width: 40, height: 40);
      case 2:
        return Image.asset('assets/icons/partly_cloud.png',
            width: 40, height: 40);
      case 3:
        return Image.asset('assets/icons/cloudy.png', width: 40, height: 40);
      case 45:
        return Image.asset('assets/icons/fog.png', width: 40, height: 40);
      case 48:
        return Image.asset('assets/icons/rime.png', width: 40, height: 40);
      case 51:
        return Image.asset('assets/icons/drizzle.png', width: 40, height: 40);
      case 53:
        return Image.asset('assets/icons/drizzle.png', width: 40, height: 40);
      case 55:
        return Image.asset('assets/icons/drizzle.png', width: 40, height: 40);
      case 61:
      case 63:
        return Image.asset('assets/icons/rain.png', width: 40, height: 40);
      case 65:
        return Image.asset('assets/icons/heavy_rain.png',
            width: 40, height: 40);
      case 71:
        return Image.asset('assets/icons/snow.png', width: 40, height: 40);
      case 73:
        return Image.asset('assets/icons/snow.png', width: 40, height: 40);
      case 75:
        return Image.asset('assets/icons/heavy_snow.png',
            width: 40, height: 40);
      case 77:
        return Image.asset('assets/icons/grains.png', width: 40, height: 40);
      case 80:
        return Image.asset('assets/icons/heavy_rain.png',
            width: 40, height: 40);
      case 81:
        return Image.asset('assets/icons/heavy_rain.png',
            width: 40, height: 40);
      case 82:
        return Image.asset('assets/icons/heavy_rain.png',
            width: 40, height: 40);
      case 85:
      case 86:
        return Image.asset('assets/icons/heavy_snow.png',
            width: 40, height: 40);
      case 95:
      case 96:
        return Image.asset('assets/icons/thunder.png', width: 40, height: 40);
      default:
        return Image.asset('assets/icons/default.png', width: 40, height: 40);
    }
  }

  Image getWeatherIconByIndex(int index) {
    return isDayTime
        ? getDayWeatherIcon(days[index].weatherCode)
        : getNightWeatherIcon(days[index].weatherCode);
  }

  LottieBuilder getCurrentWeatherIcon(weatherCode) {
    return WeatherAnimation.fromCode(weatherCode).getAnimation(isDayTime);
  }

  LottieBuilder getCurrentAnimationbyDayIndex(int index) {
    return getCurrentWeatherIcon(days[index].weatherCode);
  }
}
