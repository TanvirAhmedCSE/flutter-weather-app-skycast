import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';

// Single row item in the 7-day forecast list
class FutureForcastListItem extends StatelessWidget {
  final Forecastday? forecastday;

  const FutureForcastListItem({super.key, required this.forecastday});

  @override
  Widget build(BuildContext context) {
    final double maxTemp = forecastday?.day?.maxtempC ?? 0;
    final double minTemp = forecastday?.day?.mintempC ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Condition icon inside a small frosted circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.10),
            ),
            child: ClipOval(
              child: Image.network(
                "https:${forecastday?.day?.condition?.icon ?? ""}",
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Day name on top, short date below
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.EEEE().format(
                    DateTime.parse(forecastday?.date.toString() ?? ""),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat.MMMd().format(
                    DateTime.parse(forecastday?.date.toString() ?? ""),
                  ),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.50),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Short condition description in the middle
          Expanded(
            flex: 3,
            child: Text(
              forecastday?.day?.condition?.text ?? "",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.70),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 8),

          // Max temp in bright white, min temp dimmed
          Row(
            children: [
              Text(
                "${maxTemp.round()}°",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                " / ${minTemp.round()}°",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 13,
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
