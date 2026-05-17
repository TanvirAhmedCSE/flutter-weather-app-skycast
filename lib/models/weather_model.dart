class WeatherModel {
  Location? location;
  Current? current;
  Forecast? forecast;

  WeatherModel({this.location, this.current, this.forecast});

  WeatherModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    current = json['current'] != null
        ? new Current.fromJson(json['current'])
        : null;
    forecast = json['forecast'] != null
        ? new Forecast.fromJson(json['forecast'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.current != null) {
      data['current'] = this.current!.toJson();
    }
    if (this.forecast != null) {
      data['forecast'] = this.forecast!.toJson();
    }
    return data;
  }
}

class Location {
  String? name;
  String? region;
  String? country;
  double? lat;
  double? lon;
  String? tzId;
  int? localtimeEpoch;
  String? localtime;

  Location({
    this.name,
    this.region,
    this.country,
    this.lat,
    this.lon,
    this.tzId,
    this.localtimeEpoch,
    this.localtime,
  });

  Location.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    region = json['region']?.toString();
    country = json['country']?.toString();
    lat = (json['lat'] as num?)?.toDouble();
    lon = (json['lon'] as num?)?.toDouble();
    tzId = json['tz_id']?.toString();
    localtimeEpoch = json['localtime_epoch'];
    localtime = json['localtime']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['region'] = this.region;
    data['country'] = this.country;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['tz_id'] = this.tzId;
    data['localtime_epoch'] = this.localtimeEpoch;
    data['localtime'] = this.localtime;
    return data;
  }
}

class Current {
  int? lastUpdatedEpoch;
  String? lastUpdated;
  double? tempC;
  double? tempF;
  int? isDay;
  Condition? condition;
  double? windMph;
  double? windKph;
  int? windDegree;
  String? windDir;
  double? pressureMb;
  double? pressureIn;
  double? precipMm;
  double? precipIn;
  int? humidity;
  int? cloud;
  double? feelslikeC;
  double? feelslikeF;
  double? visKm;
  double? visMiles;
  double? uv;
  double? gustMph;
  double? gustKph;

  Current({
    this.lastUpdatedEpoch,
    this.lastUpdated,
    this.tempC,
    this.tempF,
    this.isDay,
    this.condition,
    this.windMph,
    this.windKph,
    this.windDegree,
    this.windDir,
    this.pressureMb,
    this.pressureIn,
    this.precipMm,
    this.precipIn,
    this.humidity,
    this.cloud,
    this.feelslikeC,
    this.feelslikeF,
    this.visKm,
    this.visMiles,
    this.uv,
    this.gustMph,
    this.gustKph,
  });

  Current.fromJson(Map<String, dynamic> json) {
    lastUpdatedEpoch = json['last_updated_epoch'];
    lastUpdated = json['last_updated']?.toString();
    tempC = (json['temp_c'] as num?)?.toDouble();
    tempF = (json['temp_f'] as num?)?.toDouble();
    isDay = json['is_day'];
    condition = json['condition'] != null
        ? new Condition.fromJson(json['condition'])
        : null;
    windMph = (json['wind_mph'] as num?)?.toDouble();
    windKph = (json['wind_kph'] as num?)?.toDouble();
    windDegree = json['wind_degree'];
    windDir = json['wind_dir']?.toString();
    pressureMb = (json['pressure_mb'] as num?)?.toDouble();
    pressureIn = (json['pressure_in'] as num?)?.toDouble();
    precipMm = (json['precip_mm'] as num?)?.toDouble();
    precipIn = (json['precip_in'] as num?)?.toDouble();
    humidity = json['humidity'];
    cloud = json['cloud'];
    feelslikeC = (json['feelslike_c'] as num?)?.toDouble();
    feelslikeF = (json['feelslike_f'] as num?)?.toDouble();
    visKm = (json['vis_km'] as num?)?.toDouble();
    visMiles = (json['vis_miles'] as num?)?.toDouble();
    uv = (json['uv'] as num?)?.toDouble();
    gustMph = (json['gust_mph'] as num?)?.toDouble();
    gustKph = (json['gust_kph'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_updated_epoch'] = this.lastUpdatedEpoch;
    data['last_updated'] = this.lastUpdated;
    data['temp_c'] = this.tempC;
    data['temp_f'] = this.tempF;
    data['is_day'] = this.isDay;
    if (this.condition != null) {
      data['condition'] = this.condition!.toJson();
    }
    data['wind_mph'] = this.windMph;
    data['wind_kph'] = this.windKph;
    data['wind_degree'] = this.windDegree;
    data['wind_dir'] = this.windDir;
    data['pressure_mb'] = this.pressureMb;
    data['pressure_in'] = this.pressureIn;
    data['precip_mm'] = this.precipMm;
    data['precip_in'] = this.precipIn;
    data['humidity'] = this.humidity;
    data['cloud'] = this.cloud;
    data['feelslike_c'] = this.feelslikeC;
    data['feelslike_f'] = this.feelslikeF;
    data['vis_km'] = this.visKm;
    data['vis_miles'] = this.visMiles;
    data['uv'] = this.uv;
    data['gust_mph'] = this.gustMph;
    data['gust_kph'] = this.gustKph;
    return data;
  }
}

class Condition {
  String? text;
  String? icon;
  int? code;

  Condition({this.text, this.icon, this.code});

  Condition.fromJson(Map<String, dynamic> json) {
    text = json['text']?.toString();
    icon = json['icon']?.toString();
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['icon'] = this.icon;
    data['code'] = this.code;
    return data;
  }
}

class Forecast {
  List<Forecastday>? forecastday;

  Forecast({this.forecastday});

  Forecast.fromJson(Map<String, dynamic> json) {
    if (json['forecastday'] != null) {
      forecastday = <Forecastday>[];
      json['forecastday'].forEach((v) {
        forecastday!.add(new Forecastday.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.forecastday != null) {
      data['forecastday'] = this.forecastday!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Forecastday {
  String? date;
  int? dateEpoch;
  Day? day;
  Astro? astro;
  List<Hour>? hour;

  Forecastday({this.date, this.dateEpoch, this.day, this.astro, this.hour});

  Forecastday.fromJson(Map<String, dynamic> json) {
    date = json['date']?.toString();
    dateEpoch = json['date_epoch'];
    day = json['day'] != null ? new Day.fromJson(json['day']) : null;
    astro = json['astro'] != null ? new Astro.fromJson(json['astro']) : null;
    if (json['hour'] != null) {
      hour = <Hour>[];
      json['hour'].forEach((v) {
        hour!.add(new Hour.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['date_epoch'] = this.dateEpoch;
    if (this.day != null) {
      data['day'] = this.day!.toJson();
    }
    if (this.astro != null) {
      data['astro'] = this.astro!.toJson();
    }
    if (this.hour != null) {
      data['hour'] = this.hour!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Day {
  double? maxtempC;
  double? maxtempF;
  double? mintempC;
  double? mintempF;
  double? avgtempC;
  double? avgtempF;
  double? maxwindMph;
  double? maxwindKph;
  double? totalprecipMm;
  double? totalprecipIn;
  double? totalsnowCm;
  double? avgvisKm;
  double? avgvisMiles;
  double? avghumidity;
  int? dailyWillItRain;
  int? dailyChanceOfRain;
  int? dailyWillItSnow;
  int? dailyChanceOfSnow;
  Condition? condition;
  double? uv;

  Day({
    this.maxtempC,
    this.maxtempF,
    this.mintempC,
    this.mintempF,
    this.avgtempC,
    this.avgtempF,
    this.maxwindMph,
    this.maxwindKph,
    this.totalprecipMm,
    this.totalprecipIn,
    this.totalsnowCm,
    this.avgvisKm,
    this.avgvisMiles,
    this.avghumidity,
    this.dailyWillItRain,
    this.dailyChanceOfRain,
    this.dailyWillItSnow,
    this.dailyChanceOfSnow,
    this.condition,
    this.uv,
  });

  Day.fromJson(Map<String, dynamic> json) {
    maxtempC = (json['maxtemp_c'] as num?)?.toDouble();
    maxtempF = (json['maxtemp_f'] as num?)?.toDouble();
    mintempC = (json['mintemp_c'] as num?)?.toDouble();
    mintempF = (json['mintemp_f'] as num?)?.toDouble();
    avgtempC = (json['avgtemp_c'] as num?)?.toDouble();
    avgtempF = (json['avgtemp_f'] as num?)?.toDouble();
    maxwindMph = (json['maxwind_mph'] as num?)?.toDouble();
    maxwindKph = (json['maxwind_kph'] as num?)?.toDouble();
    totalprecipMm = (json['totalprecip_mm'] as num?)?.toDouble();
    totalprecipIn = (json['totalprecip_in'] as num?)?.toDouble();
    totalsnowCm = (json['totalsnow_cm'] as num?)?.toDouble();
    avgvisKm = (json['avgvis_km'] as num?)?.toDouble();
    avgvisMiles = (json['avgvis_miles'] as num?)?.toDouble();
    avghumidity = (json['avghumidity'] as num?)?.toDouble();
    dailyWillItRain = json['daily_will_it_rain'];
    dailyChanceOfRain = json['daily_chance_of_rain'];
    dailyWillItSnow = json['daily_will_it_snow'];
    dailyChanceOfSnow = json['daily_chance_of_snow'];
    condition = json['condition'] != null
        ? new Condition.fromJson(json['condition'])
        : null;
    uv = (json['uv'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maxtemp_c'] = this.maxtempC;
    data['maxtemp_f'] = this.maxtempF;
    data['mintemp_c'] = this.mintempC;
    data['mintemp_f'] = this.mintempF;
    data['avgtemp_c'] = this.avgtempC;
    data['avgtemp_f'] = this.avgtempF;
    data['maxwind_mph'] = this.maxwindMph;
    data['maxwind_kph'] = this.maxwindKph;
    data['totalprecip_mm'] = this.totalprecipMm;
    data['totalprecip_in'] = this.totalprecipIn;
    data['totalsnow_cm'] = this.totalsnowCm;
    data['avgvis_km'] = this.avgvisKm;
    data['avgvis_miles'] = this.avgvisMiles;
    data['avghumidity'] = this.avghumidity;
    data['daily_will_it_rain'] = this.dailyWillItRain;
    data['daily_chance_of_rain'] = this.dailyChanceOfRain;
    data['daily_will_it_snow'] = this.dailyWillItSnow;
    data['daily_chance_of_snow'] = this.dailyChanceOfSnow;
    if (this.condition != null) {
      data['condition'] = this.condition!.toJson();
    }
    data['uv'] = this.uv;
    return data;
  }
}

class Astro {
  String? sunrise;
  String? sunset;
  String? moonrise;
  String? moonset;
  String? moonPhase;
  String? moonIllumination;
  int? isMoonUp;
  int? isSunUp;

  Astro({
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.moonPhase,
    this.moonIllumination,
    this.isMoonUp,
    this.isSunUp,
  });

  Astro.fromJson(Map<String, dynamic> json) {
    sunrise = json['sunrise']?.toString();
    sunset = json['sunset']?.toString();
    moonrise = json['moonrise']?.toString();
    moonset = json['moonset']?.toString();
    moonPhase = json['moon_phase']?.toString();
    moonIllumination = json['moon_illumination']?.toString(); // API sends int
    isMoonUp = json['is_moon_up'];
    isSunUp = json['is_sun_up'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    data['moonrise'] = this.moonrise;
    data['moonset'] = this.moonset;
    data['moon_phase'] = this.moonPhase;
    data['moon_illumination'] = this.moonIllumination;
    data['is_moon_up'] = this.isMoonUp;
    data['is_sun_up'] = this.isSunUp;
    return data;
  }
}

class Hour {
  int? timeEpoch;
  String? time;
  double? tempC;
  double? tempF;
  int? isDay;
  Condition? condition;
  double? windMph;
  double? windKph;
  int? windDegree;
  String? windDir;
  double? pressureMb;
  double? pressureIn;
  double? precipMm;
  double? precipIn;
  int? humidity;
  int? cloud;
  double? feelslikeC;
  double? feelslikeF;
  double? windchillC;
  double? windchillF;
  double? heatindexC;
  double? heatindexF;
  double? dewpointC;
  double? dewpointF;
  int? willItRain;
  int? chanceOfRain;
  int? willItSnow;
  int? chanceOfSnow;
  double? visKm;
  double? visMiles;
  double? gustMph;
  double? gustKph;
  double? uv;

  Hour({
    this.timeEpoch,
    this.time,
    this.tempC,
    this.tempF,
    this.isDay,
    this.condition,
    this.windMph,
    this.windKph,
    this.windDegree,
    this.windDir,
    this.pressureMb,
    this.pressureIn,
    this.precipMm,
    this.precipIn,
    this.humidity,
    this.cloud,
    this.feelslikeC,
    this.feelslikeF,
    this.windchillC,
    this.windchillF,
    this.heatindexC,
    this.heatindexF,
    this.dewpointC,
    this.dewpointF,
    this.willItRain,
    this.chanceOfRain,
    this.willItSnow,
    this.chanceOfSnow,
    this.visKm,
    this.visMiles,
    this.gustMph,
    this.gustKph,
    this.uv,
  });

  Hour.fromJson(Map<String, dynamic> json) {
    timeEpoch = json['time_epoch'];
    time = json['time']?.toString();
    tempC = (json['temp_c'] as num?)?.toDouble();
    tempF = (json['temp_f'] as num?)?.toDouble();
    isDay = json['is_day'];
    condition = json['condition'] != null
        ? new Condition.fromJson(json['condition'])
        : null;
    windMph = (json['wind_mph'] as num?)?.toDouble();
    windKph = (json['wind_kph'] as num?)?.toDouble();
    windDegree = json['wind_degree'];
    windDir = json['wind_dir']?.toString();
    pressureMb = (json['pressure_mb'] as num?)?.toDouble();
    pressureIn = (json['pressure_in'] as num?)?.toDouble();
    precipMm = (json['precip_mm'] as num?)?.toDouble();
    precipIn = (json['precip_in'] as num?)?.toDouble();
    humidity = json['humidity'];
    cloud = json['cloud'];
    feelslikeC = (json['feelslike_c'] as num?)?.toDouble();
    feelslikeF = (json['feelslike_f'] as num?)?.toDouble();
    windchillC = (json['windchill_c'] as num?)?.toDouble();
    windchillF = (json['windchill_f'] as num?)?.toDouble();
    heatindexC = (json['heatindex_c'] as num?)?.toDouble();
    heatindexF = (json['heatindex_f'] as num?)?.toDouble();
    dewpointC = (json['dewpoint_c'] as num?)?.toDouble();
    dewpointF = (json['dewpoint_f'] as num?)?.toDouble();
    willItRain = json['will_it_rain'];
    chanceOfRain = json['chance_of_rain'];
    willItSnow = json['will_it_snow'];
    chanceOfSnow = json['chance_of_snow'];
    visKm = (json['vis_km'] as num?)?.toDouble();
    visMiles = (json['vis_miles'] as num?)?.toDouble();
    gustMph = (json['gust_mph'] as num?)?.toDouble();
    gustKph = (json['gust_kph'] as num?)?.toDouble();
    uv = (json['uv'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_epoch'] = this.timeEpoch;
    data['time'] = this.time;
    data['temp_c'] = this.tempC;
    data['temp_f'] = this.tempF;
    data['is_day'] = this.isDay;
    if (this.condition != null) {
      data['condition'] = this.condition!.toJson();
    }
    data['wind_mph'] = this.windMph;
    data['wind_kph'] = this.windKph;
    data['wind_degree'] = this.windDegree;
    data['wind_dir'] = this.windDir;
    data['pressure_mb'] = this.pressureMb;
    data['pressure_in'] = this.pressureIn;
    data['precip_mm'] = this.precipMm;
    data['precip_in'] = this.precipIn;
    data['humidity'] = this.humidity;
    data['cloud'] = this.cloud;
    data['feelslike_c'] = this.feelslikeC;
    data['feelslike_f'] = this.feelslikeF;
    data['windchill_c'] = this.windchillC;
    data['windchill_f'] = this.windchillF;
    data['heatindex_c'] = this.heatindexC;
    data['heatindex_f'] = this.heatindexF;
    data['dewpoint_c'] = this.dewpointC;
    data['dewpoint_f'] = this.dewpointF;
    data['will_it_rain'] = this.willItRain;
    data['chance_of_rain'] = this.chanceOfRain;
    data['will_it_snow'] = this.willItSnow;
    data['chance_of_snow'] = this.chanceOfSnow;
    data['vis_km'] = this.visKm;
    data['vis_miles'] = this.visMiles;
    data['gust_mph'] = this.gustMph;
    data['gust_kph'] = this.gustKph;
    data['uv'] = this.uv;
    return data;
  }
}
