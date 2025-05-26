import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_provider.dart';
import 'package:weather_app/styles/app_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  Widget weatherForecast({
    required String dayOfWeek,
    required String weather,
    required String mintemp,
    required String maxntemp,
    required Image weatherIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
      child: Row(
        children: [
          weatherIcon,
          const SizedBox(width: 10),
          Text(dayOfWeek, style: AppTextStyle.body),
          Text(' / ', style: AppTextStyle.body),
          Text(weather, style: AppTextStyle.body),
          const Spacer(),
          Text('$mintemp-$maxntemp', style: AppTextStyle.varBody),
        ],
      ),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //loadWeatherFromLocation();
      loadSavedLocationName();
      loadWeatherFromLocation();
    });
  }

  final TextEditingController _locationNameController = TextEditingController();
  String locationName = 'Yerevan';
  bool isLocationSet = false;

  Future<void> saveLocationName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('location_name', locationName);
  }

  Future<void> loadSavedLocationName() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString('location_name');
    if (savedName != null && savedName.isNotEmpty) {
      setState(() {
        locationName = savedName;
        isLocationSet = true;
      });
      await fetchWeatherByCity();
    }
  }

  Future<void> loadWeatherFromLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        debugPrint(
            'Geolocation services are disabled. Waiting for user input.');
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          debugPrint(
              'Geolocation permission not granted. Waiting for user input.');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest,
      );

      final locationService =
          Provider.of<LocationService>(context, listen: false);
      String place = await locationService.getPlaceName(
          position.latitude, position.longitude);

      if (_locationNameController.text.isEmpty) {
        setState(() {
          isLocationSet = true;
          locationName = place;
        });
      }

      fetchWeatherByCity();
      debugPrint('Detected location: $place');
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> fetchWeatherByCity() async {
    if (locationName.isEmpty) return;
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    final locationService =
        Provider.of<LocationService>(context, listen: false);

    Map<String, double>? coordinates =
        await locationService.getCoordinatesFromCity(locationName);

    if (coordinates != null) {
      await weatherProvider.initFetchWeather(
          coordinates["latitude"]!, coordinates["longitude"]!);
    } else {
      debugPrint('Could not get coordinates for city: $locationName');
    }
  }

  void changeLocation(String value) {
    if (value.trim().isNotEmpty) {
      setState(() {
        isLocationSet = true;
        locationName = value;
      });
      saveLocationName();
      fetchWeatherByCity();
    }
  }

  Future<void> refreshData() async {
    await loadWeatherFromLocation();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    String getMaxTemp(int index) {
      return '${weatherProvider.getTempMax(index)?.toStringAsFixed(0)} C';
    }

    String getMinTemp(int index) {
      return '${weatherProvider.getTempMin(index)?.toStringAsFixed(0)}';
    }

    final today =
        weatherProvider.days.isNotEmpty ? weatherProvider.days.first : null;
    final hourData = today?.getHourlyDataByHour(DateTime.now().hour);

    PageController pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.6,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: !isLocationSet
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color.fromARGB(255, 106, 217, 245),
                    weatherProvider.isDayTime
                        ? const Color.fromARGB(255, 28, 181, 219)
                        : const Color.fromARGB(255, 4, 64, 80),
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Type Location',
                      labelStyle: GoogleFonts.jura(
                          textStyle: TextStyle(
                        color: const Color.fromARGB(135, 7, 7, 7),
                      )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: const Color.fromARGB(180, 101, 89, 105),
                            width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 101, 89, 105),
                            width: 1),
                      ),
                      suffix: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    style: AppTextStyle.clockStyle,
                    controller: _locationNameController,
                    onFieldSubmitted: (value) => changeLocation(value),
                    onTap: _locationNameController.clear,
                  ),
                ),
              ),
            )
          : weatherProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                    strokeWidth: 6.0,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color.fromARGB(255, 106, 217, 245),
                        weatherProvider.isDayTime
                            ? const Color.fromARGB(255, 28, 181, 219)
                            : const Color.fromARGB(255, 4, 64, 80),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        const Icon(
                          Icons.location_on,
                          color: Colors.amber,
                          size: 50,
                        ),
                        Text(
                          locationName,
                          style: AppTextStyle.heading,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 150,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  hourData?.temperature.toStringAsFixed(0) ??
                                      "--",
                                  style: AppTextStyle.main,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  ' °C',
                                  style: AppTextStyle.sign,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          DateFormat('HH:mm a').format(
                            DateTime.now(),
                          ),
                          style: AppTextStyle.clockStyle,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat('EEEE').format(
                            DateTime.now(),
                          ),
                          style: GoogleFonts.jura(
                            textStyle: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 50),
                          child: SizedBox(
                            height: 50,
                            width: 250,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Type Location',
                                labelStyle: GoogleFonts.jura(
                                    textStyle: TextStyle(
                                  color:
                                      const Color.fromARGB(180, 251, 251, 251),
                                )),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          180, 101, 89, 105),
                                      width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 101, 89, 105),
                                      width: 1),
                                ),
                                suffix: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                              style: AppTextStyle.weatherdetails,
                              controller: _locationNameController,
                              onFieldSubmitted: (value) =>
                                  changeLocation(value),
                              onTap: _locationNameController.clear,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 250,
                          child: PageView(
                            controller: pageController,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 2),
                                decoration: BoxDecoration(
                                  color: weatherProvider.isDayTime
                                      ? const Color.fromARGB(180, 138, 123, 143)
                                      : const Color.fromARGB(180, 101, 89, 105),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Day Details',
                                          style: AppTextStyle.details),
                                      SizedBox(
                                        height: 70,
                                      ),
                                      Text(
                                        DateFormat('d MMM')
                                            .format(DateTime.now()),
                                        style: AppTextStyle.day_additional,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 10, left: 2),
                                decoration: BoxDecoration(
                                  color: weatherProvider.isDayTime
                                      ? const Color.fromARGB(180, 138, 123, 143)
                                      : const Color.fromARGB(180, 101, 89, 105),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      weatherProvider
                                          .getCurrentAnimationbyDayIndex(0),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  margin:
                                      const EdgeInsets.only(right: 10, left: 2),
                                  decoration: BoxDecoration(
                                    color: weatherProvider.isDayTime
                                        ? const Color.fromARGB(
                                            180, 138, 123, 143)
                                        : const Color.fromARGB(
                                            180, 101, 89, 105),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 180,
                                      child: Column(
                                        children: [
                                          Text('Weather Details',
                                              style: AppTextStyle.details),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Feels Like',
                                                  style: AppTextStyle
                                                      .weatherdetails),
                                              SizedBox(width: 15),
                                              Text(
                                                  '${hourData!.feelsLike.toStringAsFixed(1)} C',
                                                  style: AppTextStyle
                                                      .weatherdetails),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Wind',
                                                  style: AppTextStyle
                                                      .weatherdetails),
                                              SizedBox(width: 15),
                                              Text(
                                                  '${hourData.windSpeed.toStringAsFixed(1)} m/s',
                                                  style: AppTextStyle
                                                      .weatherdetails),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Humidity',
                                                  style: AppTextStyle
                                                      .weatherdetails),
                                              SizedBox(width: 15),
                                              Text(
                                                  '${hourData.humidity.toStringAsFixed(0)} % ',
                                                  style: AppTextStyle
                                                      .weatherdetails),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.amber,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                  ),
                                  builder: (context) => Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    padding: const EdgeInsets.only(
                                      top: 0,
                                      left: 10,
                                      bottom: 30,
                                      right: 10,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 101, 89, 105),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 10,
                                          color: Colors.black26,
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.keyboard_double_arrow_down,
                                            color: Color.fromARGB(114, 0, 0, 0),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        widget.weatherForecast(
                                          dayOfWeek: DateFormat('d MMM').format(
                                            DateTime.now().add(
                                              const Duration(days: 1),
                                            ),
                                          ),
                                          weather:
                                              '${weatherProvider.getWeatherDescriptionByIndex(1)}',
                                          maxntemp: getMaxTemp(1),
                                          mintemp: getMinTemp(1),
                                          weatherIcon: weatherProvider
                                              .getWeatherIconByIndex(1),
                                        ),
                                        widget.weatherForecast(
                                          dayOfWeek: DateFormat('d MMM').format(
                                            DateTime.now().add(
                                              const Duration(days: 2),
                                            ),
                                          ),
                                          weather:
                                              '${weatherProvider.getWeatherDescriptionByIndex(2)}',
                                          maxntemp: getMaxTemp(2),
                                          mintemp: getMinTemp(2),
                                          weatherIcon: weatherProvider
                                              .getWeatherIconByIndex(2),
                                        ),
                                        widget.weatherForecast(
                                          dayOfWeek: DateFormat('d MMM').format(
                                            DateTime.now().add(
                                              const Duration(days: 3),
                                            ),
                                          ),
                                          weather:
                                              '${weatherProvider.getWeatherDescriptionByIndex(3)}',
                                          maxntemp: getMaxTemp(3),
                                          mintemp: getMinTemp(3),
                                          weatherIcon: weatherProvider
                                              .getWeatherIconByIndex(3),
                                        ),
                                        widget.weatherForecast(
                                          dayOfWeek: DateFormat('d MMM').format(
                                            DateTime.now().add(
                                              const Duration(days: 4),
                                            ),
                                          ),
                                          weather:
                                              '${weatherProvider.getWeatherDescriptionByIndex(4)}',
                                          maxntemp: getMaxTemp(4),
                                          mintemp: getMinTemp(4),
                                          weatherIcon: weatherProvider
                                              .getWeatherIconByIndex(4),
                                        ),
                                        widget.weatherForecast(
                                          dayOfWeek: DateFormat('d MMM').format(
                                            DateTime.now().add(
                                              const Duration(days: 5),
                                            ),
                                          ),
                                          weather:
                                              '${weatherProvider.getWeatherDescriptionByIndex(5)}',
                                          maxntemp: getMaxTemp(5),
                                          mintemp: getMinTemp(5),
                                          weatherIcon: weatherProvider
                                              .getWeatherIconByIndex(5),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                '5-Day Forecast',
                                style: AppTextStyle.buttonBody,
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.amber,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                              ),
                              onPressed: refreshData,
                              child: const Icon(
                                Icons.refresh_rounded,
                                size: 35,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
    );
  }
}
