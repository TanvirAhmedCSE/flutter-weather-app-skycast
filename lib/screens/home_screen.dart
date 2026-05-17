import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import '../models/weather_model.dart';
import '../services/api_services.dart';
import '../widgets/future_forcast.dart';
import '../widgets/hourly_weather.dart';
import '../widgets/todays_weather.dart';
import 'search_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService apiService = ApiService();

  // Default query uses device IP to detect location automatically
  String queryText = "auto:ip";

  Timer? _refreshTimer;
  final ScrollController _hourlyScrollController = ScrollController();
  Future<WeatherModel>? _weatherFuture;

  // Keeps the last successful response so SearchScreen can read it
  WeatherModel? _latestWeather;

  // Finds which index in the 24-hour list matches the current local hour
  int _getCurrentHourIndex(WeatherModel? weatherModel) {
    final localtime = weatherModel?.location?.localtime ?? "";
    if (localtime.isEmpty) return 0;
    final currentHour = DateTime.parse(localtime).hour;
    final hours = weatherModel?.forecast?.forecastday?[0].hour;
    if (hours == null) return 0;
    for (int i = 0; i < hours.length; i++) {
      final hourTime = DateTime.parse(hours[i].time ?? "").hour;
      if (hourTime == currentHour) return i;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _weatherFuture = apiService.getWeatherData(queryText);

    // Auto-refresh weather data every 15 minutes
    _refreshTimer = Timer.periodic(const Duration(minutes: 15), (_) {
      setState(() {
        _weatherFuture = apiService.getWeatherData(queryText);
      });
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _hourlyScrollController.dispose();
    super.dispose();
  }

  // Opens SearchScreen and applies the returned city query if the user picks one
  Future<void> _openSearchScreen() async {
    final String? result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(
          currentWeather:
              _latestWeather?.current,
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        queryText = result;
        _weatherFuture = apiService.getWeatherData(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherModel>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        final weatherModel = snapshot.data;

        // Cache the latest successful data so it survives loading states
        if (weatherModel != null) _latestWeather = weatherModel;

        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.15),
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            title: const Text(
              "Weather",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            actions: [
              // Search button opens city search screen
              IconButton(
                onPressed: _openSearchScreen,
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              // Location button resets query back to IP-based detection
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      queryText = "auto:ip";
                      _weatherFuture = apiService.getWeatherData("auto:ip");
                    });
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.my_location_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              // Layer 1: animated weather background fills the entire screen
              Positioned.fill(
                child: weatherModel != null
                    ? WeatherBg(
                        weatherType: TodaysWeather.getWeatherType(
                          weatherModel.current,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      )
                    : Container(color: const Color(0xFF006064)),
              ),

              // Layer 2: scrollable content sits on top of the background
              SafeArea(child: _buildContent(snapshot)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(AsyncSnapshot<WeatherModel> snapshot) {
    if (snapshot.hasData) {
      final weatherModel = snapshot.data!;
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TodaysWeather(weatherModel: weatherModel),

            const SizedBox(height: 24),

            // Section header for the hourly scroll
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.70),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Hourly Forecast",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 168,
              child: Builder(
                builder: (context) {
                  final currentIndex = _getCurrentHourIndex(weatherModel);
                  // Scroll to the current hour card after the first frame renders
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_hourlyScrollController.hasClients) {
                      _hourlyScrollController.animateTo(
                        //currentIndex * 86.0,
                        currentIndex * 98.0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                  return ListView.builder(
                    controller: _hourlyScrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      Hour? hour =
                          weatherModel.forecast?.forecastday?[0].hour?[index];
                      final isCurrentHour = index == currentIndex;
                      return HourlyWeatherListItem(
                        hour: hour,
                        isCurrentHour: isCurrentHour,
                      );
                    },
                    itemCount:
                        weatherModel.forecast?.forecastday?[0].hour?.length ??
                        0,
                    scrollDirection: Axis.horizontal,
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Section header for the 7-day forecast list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.70),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "7-Day Forecast",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Non-scrollable list nested inside the parent SingleChildScrollView
            ListView.builder(
              itemBuilder: (context, index) {
                return FutureForcastListItem(
                  forecastday: weatherModel.forecast?.forecastday?[index],
                );
              },
              itemCount: weatherModel.forecast?.forecastday?.length ?? 0,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
            ),
          ],
        ),
      );
    }

    // Network or parse error state
    if (snapshot.hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              color: Colors.white.withValues(alpha: 0.40),
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              "Couldn't load weather data",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.60),
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    // Initial loading spinner while the first API call is in flight
    return const Center(
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
    );
  }
}
