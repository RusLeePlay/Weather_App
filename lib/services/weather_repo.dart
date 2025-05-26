import 'package:dio/dio.dart';

class WeatherRepo {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'https://api.open-meteo.com/v1',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5)));

  Future<Map<String, dynamic>?> getWeather(
      {required double latitude, required double longitude}) async {
    try {
      final response = await _dio.get('/forecast', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'daily':
            'weather_code,temperature_2m_max,temperature_2m_min,uv_index_max,sunrise,sunset',
        'hourly':
            'temperature_2m,wind_speed_10m,relative_humidity_2m,apparent_temperature',
        'timezone': 'auto'
      });
      return response.data;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCurrentWeather(
      double latitude, double longitude) async {
    try {
      final response = await _dio.get('/forecast', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'current': 'temperature_2m,weather_code',
        'timezone': 'auto'
      });
      return response.data?['current'];
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getHourlyWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get('/forecast', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'hourly':
            'temperature_2m,wind_speed_10m,relative_humidity_2m,apparent_temperature',
        'timezone': 'auto',
      });

      return response.data;
    } catch (e) {
      return null;
    }
  }
}
