import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

enum _PrecipType { rain, snow, mixed }

class _PrecipData {
  final _PrecipType type;
  final int percent;
  const _PrecipData({required this.type, required this.percent});
}

// Returns precip data only when rain or snow chance is at least 20%
_PrecipData? _getPrecipData(Hour? hour) {
  final int rain = hour?.chanceOfRain ?? 0;
  final int snow = hour?.chanceOfSnow ?? 0;

  final bool showRain = rain >= 20;
  final bool showSnow = snow >= 20;

  if (showRain && showSnow) {
    // Both rain and snow qualify, so show a mixed indicator
    final int mixedPct = ((rain + snow) / 2).round();
    return _PrecipData(type: _PrecipType.mixed, percent: mixedPct);
  }
  if (showRain) return _PrecipData(type: _PrecipType.rain, percent: rain);
  if (showSnow) return _PrecipData(type: _PrecipType.snow, percent: snow);
  return null; // Clear sky, nothing to show
}

// Returns the local asset path for each precipitation type
String _precipAsset(_PrecipType type) {
  switch (type) {
    case _PrecipType.rain:
      return 'assets/icons/rain-icon.png';
    case _PrecipType.snow:
      return 'assets/icons/snow-icon.png';
    case _PrecipType.mixed:
      return 'assets/icons/rain-with-snow-icon.png';
  }
}

// Single card in the horizontal hourly forecast scroll
class HourlyWeatherListItem extends StatelessWidget {
  final Hour? hour;
  final bool isCurrentHour;

  const HourlyWeatherListItem({
    super.key,
    this.hour,
    this.isCurrentHour = false,
  });

  @override
  Widget build(BuildContext context) {
    final precipData = _getPrecipData(hour);
    final bool hasPrecip = precipData != null;

    // Card is taller when a precipitation row needs extra space
    final double boxHeight = hasPrecip ? 168 : 140;

    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      //width: 76,
      width: 88,
      height: boxHeight,
      decoration: BoxDecoration(
        // Current hour card is brighter to stand out
        color: isCurrentHour
            ? Colors.white.withValues(alpha: 0.22)
            : Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrentHour
              ? Colors.white
              : Colors.white.withValues(alpha: 0.20),
          width: isCurrentHour ? 2.2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Shows "Now" for the current hour, otherwise a formatted time
          Text(
            isCurrentHour
                ? "Now"
                : DateFormat.j().format(
                    DateTime.parse(hour?.time?.toString() ?? ""),
                  ),
            style: TextStyle(
              color: isCurrentHour
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.65),
              fontSize: 11,
              fontWeight: isCurrentHour ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),

          // Condition icon in a small frosted circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.10),
            ),
            child: ClipOval(
              child: Image.network(
                "https:${hour?.condition?.icon.toString()}",
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Rain or snow icon and percentage, only shown when threshold is met
          if (hasPrecip) ...[
            Column(
              children: [
                Image.asset(
                  _precipAsset(precipData.type),
                  width: 16,
                  height: 16,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
                const SizedBox(height: 2),
                Text(
                  "${precipData.percent}%",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.80),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ],

          // Temperature with degree symbol aligned to the top right
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hour?.tempC?.round().toString() ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.1,
                ),
              ),
              const Text(
                "°",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
