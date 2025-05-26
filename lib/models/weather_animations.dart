import 'package:lottie/lottie.dart';

enum WeatherAnimation {
  clearSky('clear_sky.json', 'clear_sky_n.json'),
  cloudy('cloudy.json', 'cloudy_n.json'),
  fog('fog.json', 'fog_n.json'),
  snow('snow.json', 'snow_n.json'),
  rain('rain.json', 'rain_n.json'),
  thunder('thunder.json', 'thunder_n.json'),
  unknown('unknown.json', 'unknown_n.json'),
  partly_cloud('partly_cloud.json', 'partly_cloud_n.json');

  final String dayPath;
  final String nightPath;

  const WeatherAnimation(this.dayPath, this.nightPath);

  static WeatherAnimation fromCode(int code) {
    if ([0].contains(code)) return WeatherAnimation.clearSky;
    if ([51, 53, 55, 61, 63, 65].contains(code)) {
      return WeatherAnimation.cloudy;
    }
    if ([45].contains(code)) return WeatherAnimation.fog;
    if ([48, 71, 73, 75, 77].contains(code)) return WeatherAnimation.snow;
    if ([80, 81, 82, 85, 86].contains(code)) return WeatherAnimation.rain;
    if ([95, 96].contains(code)) return WeatherAnimation.thunder;
    if ([1, 2, 3].contains(code)) return WeatherAnimation.partly_cloud;
    return WeatherAnimation.unknown;
  }

  LottieBuilder getAnimation(bool isDayTime) {
    String path = isDayTime ? dayPath : nightPath;
    return Lottie.asset('assets/animations/$path', width: 200, height: 200);
  }
}
