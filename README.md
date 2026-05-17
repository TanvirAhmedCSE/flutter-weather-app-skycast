<div align="center">

# 🌤️ Skycast

**A beautiful, premium-feeling weather app built with Flutter**

*Real-time forecasts wrapped in a glassmorphism UI that adapts to every condition*

<br>

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![WeatherAPI](https://img.shields.io/badge/WeatherAPI-Powered-FF6B35?style=for-the-badge)](https://www.weatherapi.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

</div>

---

## 📸 Screenshots

<div align="center">

<table>
  <tr>
    <td align="center" width="33%">
      <img src="app screenshots/Screenshot_20260517_113908994.jpg" width="220" style="border-radius:16px" />
      <br><sub><b>Home — Rainy Night</b></sub>
    </td>
    <td align="center" width="33%">
      <img src="app screenshots/Screenshot_20260517_113938342.jpg" width="220" style="border-radius:16px" />
      <br><sub><b>7-Day Forecast</b></sub>
    </td>
    <td align="center" width="33%">
      <img src="app screenshots/Screenshot_20260517_114121430.jpg" width="220" style="border-radius:16px" />
      <br><sub><b>Search Location</b></sub>
    </td>
  </tr>
  <tr>
    <td align="center" width="33%">
      <img src="app screenshots/Screenshot_20260517_114138147.jpg" width="220" style="border-radius:16px" />
      <br><sub><b>Sunny Day — Rocky Mountain</b></sub>
    </td>
    <td align="center" width="33%">
      <img src="app screenshots/Screenshot_20260517_114159476.jpg" width="220" style="border-radius:16px" />
      <br><sub><b>Clear Night — The Granites</b></sub>
    </td>
    <td align="center" width="33%">
      <img src="app screenshots/Screenshot_20260517_114217880.jpg" width="220" style="border-radius:16px" />
      <br><sub><b>Overcast — Pokusagyr</b></sub>
    </td>
  </tr>
  <tr>
    <td align="center" width="33%">
      <img src="app screenshots/Screenshot_20260517_114231455.jpg" width="220" style="border-radius:16px" />
      <br><sub><b>Blizzard Forecast</b></sub>
    </td>
    <td align="center" width="33%">
      <img src="app screenshots/Screenshot_20260517_114526_com_hihonor_photos_GalleryMain.jpg" width="220" style="border-radius:16px" />
      <br><sub><b>Thunderstorm — Quilmes</b></sub>
    </td>
    <td align="center" width="33%">
      <br><br><br>
      <b>More conditions supported:</b><br><br>
      ☀️ Sunny &nbsp; 🌙 Clear Night<br>
      🌧️ Rain &nbsp; ❄️ Snow<br>
      ⛈️ Thunder &nbsp; 🌫️ Fog<br>
      🌪️ Blizzard &nbsp; 🌁 Hazy<br><br>
    </td>
  </tr>
</table>

</div>

---

## ✨ Features

- **Dynamic animated backgrounds** — the entire UI adapts its live background animation to the current weather condition (sunny, rainy, snowy, thunderstorm, foggy, and more)
- **Glassmorphism design** — frosted-glass cards, subtle borders, and layered transparency for a premium look
- **Current conditions** — temperature, feels like, wind speed, humidity, and visibility at a glance
- **Precipitation indicators** — rain and snow chance shown with dedicated icons; mixed conditions handled smartly
- **Hourly forecast** — 24-hour horizontal scroll that auto-scrolls to the current hour on open
- **7-day forecast** — full week outlook with condition icons, day labels, and max/min temperatures
- **City search with autocomplete** — live suggestions from WeatherAPI as you type, with 400ms debounce
- **Search history** — recent searches saved locally with Hive, up to 20 entries, with swipe-to-delete
- **IP-based auto location** — one tap to reset to your current location
- **Auto-refresh** — weather data silently refreshes every 15 minutes in the background

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart 3.x |
| State | `StatefulWidget` + `FutureBuilder` |
| HTTP | `http` package |
| Local storage | `hive_flutter` |
| Weather data | [WeatherAPI](https://www.weatherapi.com) (forecast endpoint, 7 days) |
| Background animation | `flutter_weather_bg_null_safety` |
| Date formatting | `intl` |

---

## 📁 Project Structure

```
lib/
├── config/
│   └── api_config.dart        # API base URL and key
├── models/
│   └── weather_model.dart     # Full JSON model (Location, Current, Forecast, Hour, Day, Astro)
├── screens/
│   ├── home_screen.dart       # Main screen with FutureBuilder, hourly scroll, 7-day list
│   └── search_screen.dart     # City search with autocomplete and Hive history
├── services/
│   └── api_services.dart      # API call — getWeatherData(query)
├── widgets/
│   ├── todays_weather.dart    # Current temp, condition, precip, stats card
│   ├── hourly_weather.dart    # Single hourly card with precip indicator
│   └── future_forcast.dart   # Single 7-day row item
└── main.dart                  # Entry point — Hive init, MaterialApp
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- A free API key from [weatherapi.com](https://www.weatherapi.com)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/TanvirAhmedCSE/flutter-weather-app-skycast.git
cd skye-weather

# 2. Install dependencies
flutter pub get

# 3. Add your API key
# Open lib/config/api_config.dart and replace the key
const baseUrl = "http://api.weatherapi.com/v1/forecast.json?key=YOUR_API_KEY";

# 4. Run the app
flutter run
```

### Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.5
  flutter_weather_bg_null_safety: ^1.0.0
  intl: ^0.18.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

---

## 🌍 Supported Weather Conditions

The animated background and precipitation logic cover all major WeatherAPI condition codes:

| Condition | Background | Precip Icon |
|---|---|---|
| Sunny / Clear (day) | Sunny animation | — |
| Clear (night) | Starry night | — |
| Partly cloudy / Cloudy | Cloud animation (day/night) | — |
| Overcast | Overcast | — |
| Light / Patchy rain | Light rain animation | 🌧️ |
| Moderate rain | Medium rain animation | 🌧️ |
| Heavy rain / Torrential | Heavy rain animation | 🌧️ |
| Thunderstorm | Thunder animation | 🌧️ |
| Light / Patchy snow | Light snow animation | ❄️ |
| Moderate snow | Medium snow animation | ❄️ |
| Blizzard / Heavy snow | Heavy snow animation | ❄️ |
| Fog / Mist / Freezing fog | Foggy animation | — |
| Haze | Hazy animation | — |
| Dust / Sand | Dusty animation | — |
| Mixed rain and snow | — | 🌨️ |

---

## 🔑 API Details

This app uses the **WeatherAPI** free tier:

- **Endpoint:** `forecast.json`
- **Parameters:** `q` (query — city name, coordinates, zip, or `auto:ip`), `days=7`
- **Autocomplete endpoint:** `search.json` — used for live suggestions in the search screen
- **Free tier limit:** 1 million calls/month

---

## 📄 License

```
MIT License

Copyright (c) 2026 TanvirAhmedCSE

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
```

---

<div align="center">

Made with ❤️ and Flutter by **[TanvirAhmedCSE](https://github.com/TanvirAhmedCSE)**

*If you like this project, give it a ⭐ on GitHub!*

</div>
