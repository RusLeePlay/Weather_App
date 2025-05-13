class HourModel {
  HourModel({
    required this.time,
    required this.temperature,
    required this.windSpeed,
    required this.feelsLike,
    required this.humidity,
  });

  final DateTime time;
  final double temperature;
  final double windSpeed;
  final double humidity;
  final double feelsLike;

  factory HourModel.fromJson(Map<String, dynamic> json, int index) {
    return HourModel(
      time: DateTime.parse(json['time'][index]),
      temperature: (json['temperature_2m'][index] as num).toDouble(),
      windSpeed: (json['wind_speed_10m'][index] as num).toDouble(),
      humidity: (json['relative_humidity_2m'][index] as num).toDouble(),
      feelsLike: (json['apparent_temperature'][index] as num).toDouble(),
    );
  }
}
