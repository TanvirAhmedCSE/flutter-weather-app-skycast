import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class TodaysWeather extends StatelessWidget {
  final WeatherModel? weatherModel;

  const TodaysWeather({super.key, this.weatherModel});

  // Maps API condition text to a WeatherType for the animated background
  static WeatherType getWeatherType(Current? current) {
    final bool isDay = (current?.isDay == 1);
    final String text = current?.condition?.text?.toLowerCase().trim() ?? "";

    if (text.contains("thunder")) return WeatherType.thunder;

    if (text.contains("heavy rain") ||
        text.contains("torrential") ||
        text == "moderate or heavy rain shower" ||
        text == "moderate or heavy freezing rain" ||
        text == "moderate or heavy sleet" ||
        text == "moderate or heavy sleet showers") {
      return WeatherType.heavyRainy;
    }

    if (text == "moderate rain" ||
        text == "moderate rain at times" ||
        text == "light rain shower" ||
        text == "light freezing rain" ||
        text == "light sleet" ||
        text == "light sleet showers" ||
        text == "freezing drizzle" ||
        text == "heavy freezing drizzle") {
      return WeatherType.middleRainy;
    }

    if (text == "light rain" ||
        text == "patchy light rain" ||
        text == "patchy rain possible" ||
        text == "light drizzle" ||
        text == "patchy light drizzle" ||
        text == "patchy freezing drizzle possible") {
      return WeatherType.lightRainy;
    }

    if (text == "heavy snow" ||
        text == "patchy heavy snow" ||
        text == "blizzard" ||
        text == "moderate or heavy snow showers" ||
        text == "moderate or heavy showers of ice pellets") {
      return WeatherType.heavySnow;
    }

    if (text == "moderate snow" ||
        text == "patchy moderate snow" ||
        text == "blowing snow" ||
        text == "ice pellets" ||
        text == "light showers of ice pellets") {
      return WeatherType.middleSnow;
    }

    if (text == "light snow" ||
        text == "patchy light snow" ||
        text == "patchy snow possible" ||
        text == "light snow showers" ||
        text == "patchy sleet possible") {
      return WeatherType.lightSnow;
    }

    if (text == "fog" || text == "freezing fog" || text == "mist") {
      return WeatherType.foggy;
    }

    if (text.contains("haz")) return WeatherType.hazy;
    if (text.contains("dust") || text.contains("sand"))
      return WeatherType.dusty;
    if (text == "overcast") return WeatherType.overcast;

    if (text == "cloudy" || text == "partly cloudy") {
      return isDay ? WeatherType.cloudy : WeatherType.cloudyNight;
    }

    if (text == "sunny" || text == "clear") {
      return isDay ? WeatherType.sunny : WeatherType.sunnyNight;
    }

    // Default fallback when no condition matches
    return isDay ? WeatherType.cloudy : WeatherType.cloudyNight;
  }

  // Reads today's rain and snow chance and returns precip items to display
  static List<_PrecipItem> getPrecipItems(Forecastday? day) {
    final int rain = day?.day?.dailyChanceOfRain ?? 0;
    final int snow = day?.day?.dailyChanceOfSnow ?? 0;

    final bool hasMixed = rain > 0 && snow > 0;

    if (hasMixed) {
      // Show a single mixed icon instead of separate rain and snow
      final int mixedPct = ((rain + snow) / 2).round();
      return [_PrecipItem(type: _PrecipType.mixed, percent: mixedPct)];
    }

    final List<_PrecipItem> items = [];
    if (rain > 0) items.add(_PrecipItem(type: _PrecipType.rain, percent: rain));
    if (snow > 0) items.add(_PrecipItem(type: _PrecipType.snow, percent: snow));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    // Use the first forecastday as today
    final today = weatherModel?.forecast?.forecastday?.isNotEmpty == true
        ? weatherModel!.forecast!.forecastday![0]
        : null;
    final precipItems = getPrecipItems(today);

    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location name and formatted date
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      weatherModel?.location?.name ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.4,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat("EEEE, MMMM d, y").format(
                    DateTime.parse(
                      weatherModel?.location?.localtime.toString() ?? "",
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.80),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Big temperature display and weather icon side by side
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Weather icon with optional precipitation indicator below it
                Column(
                  children: [
                    // Frosted circle containing the condition icon
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          "https:${weatherModel?.current?.condition?.icon ?? ""}",
                          width: 52,
                          height: 52,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // Rain or snow chance shown below the icon
                    if (precipItems.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: precipItems
                            .map((item) => _PrecipIndicator(item: item))
                            .toList(),
                      ),
                    ],
                  ],
                ),

                const Spacer(),

                // Current temperature number and condition text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weatherModel?.current?.tempC?.round().toString() ??
                              "",
                          style: const TextStyle(
                            fontSize: 78,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                            height: 1.0,
                            shadows: [
                              Shadow(
                                blurRadius: 16,
                                color: Colors.black26,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            '°',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 160,
                      child: Text(
                        weatherModel?.current?.condition?.text ?? "",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.90),
                          letterSpacing: 0.6,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Glassmorphism card showing feels like, wind, humidity, visibility
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.30),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      icon: Icons.thermostat_rounded,
                      label: "Feels Like",
                      value:
                          "${weatherModel?.current?.feelslikeC?.round() ?? "--"}°",
                    ),
                    _VerticalDivider(),
                    _StatItem(
                      icon: Icons.air_rounded,
                      label: "Wind",
                      value:
                          "${weatherModel?.current?.windKph?.round() ?? "--"} km/h",
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Colors.white.withValues(alpha: 0.20),
                  thickness: 0.8,
                  height: 0,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      icon: Icons.water_drop_rounded,
                      label: "Humidity",
                      value: "${weatherModel?.current?.humidity ?? "--"}%",
                    ),
                    _VerticalDivider(),
                    _StatItem(
                      icon: Icons.visibility_rounded,
                      label: "Visibility",
                      value:
                          "${weatherModel?.current?.visKm?.round() ?? "--"} km",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _PrecipType { rain, snow, mixed }

class _PrecipItem {
  final _PrecipType type;
  final int percent;
  const _PrecipItem({required this.type, required this.percent});
}

// Small icon and percentage shown below the weather icon for rain or snow
class _PrecipIndicator extends StatelessWidget {
  final _PrecipItem item;
  const _PrecipIndicator({super.key, required this.item});

  // Returns the correct local asset path based on precip type
  String get _assetPath {
    switch (item.type) {
      case _PrecipType.rain:
        return 'assets/icons/rain-icon.png';
      case _PrecipType.snow:
        return 'assets/icons/snow-icon.png';
      case _PrecipType.mixed:
        return 'assets/icons/rain-with-snow-icon.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Image.asset(
            _assetPath,
            width: 20,
            height: 20,
            color: Colors.white.withValues(alpha: 0.90),
          ),
          const SizedBox(height: 3),
          Text(
            "${item.percent}%",
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable single stat item used inside the stats card
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.75), size: 16),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Thin vertical line that separates two stat items in the same row
class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.8,
      height: 32,
      color: Colors.white.withValues(alpha: 0.25),
    );
  }
}
