import 'hour_model.dart';

class DayModel {
  DayModel({
    required this.minTmp,
    required this.maxTmp,
    required this.date,
    required this.uvIndex,
    required this.weatherCode,
    required this.sunrise,
    required this.sunset,
    required this.hourlyData,
  });

  final double minTmp;
  final double maxTmp;
  final DateTime date;
  final int weatherCode;
  final double uvIndex;
  final DateTime sunrise;
  final DateTime sunset;
  final List<HourModel> hourlyData;

  factory DayModel.fromJson(
      Map<String, dynamic> json, int index, Map<String, dynamic> hourlyJson) {
    DateTime currentDate = DateTime.parse(json['time'][index]);

    List<DateTime> hourlyTimes =
        (hourlyJson['time'] as List).map((t) => DateTime.parse(t)).toList();

    List<int> hourlyIndexes = hourlyTimes
        .asMap()
        .entries
        .where((entry) => entry.value.day == currentDate.day)
        .map((entry) => entry.key)
        .toList();

    List<HourModel> hourlyData =
        hourlyIndexes.map((i) => HourModel.fromJson(hourlyJson, i)).toList();

    return DayModel(
      minTmp: (json['temperature_2m_min'][index] as num).toDouble(),
      maxTmp: (json['temperature_2m_max'][index] as num).toDouble(),
      date: currentDate,
      weatherCode: json['weather_code'][index] as int,
      uvIndex: (json['uv_index_max'][index] as num).toDouble(),
      sunrise: DateTime.parse(json['sunrise'][index]),
      sunset: DateTime.parse(json['sunset'][index]),
      hourlyData: hourlyData,
    );
  }

  HourModel? getHourlyDataByHour(int hour) {
    if (hourlyData.isEmpty) return null;

    final closestHour = hourlyData.firstWhere(
      (hourData) => hourData.time.hour == hour,
      orElse: () => hourlyData.first,
    );

    return closestHour;
  }
}
