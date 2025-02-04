class Train 
{
  final int trainNumber;
  final Location location;
  final double speed;
  final bool delayed;

  Train({
    required this.trainNumber,
    required this.location,
    required this.speed,
    required this.delayed,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    return Train(
      trainNumber: json['trainNumber'],
      location: Location.fromJson(json['location']),
      speed: json['speed'].toDouble(),
      delayed: json['delayed'] ?? false,
    );
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['coordinates'][1],
      longitude: json['coordinates'][0],
    );
  }
}

class TrainDetails {
  final String stationShortCode;
  final String type;
  final DateTime scheduledTime;
  final DateTime? actualTime;
  final int differenceInMinutes;
  final bool trainStopping;
  final String? commercialTrack;

  TrainDetails(
    {
    required this.stationShortCode,
    required this.type,
    required this.scheduledTime,
    this.actualTime,
    required this.differenceInMinutes,
    required this.trainStopping,
    this.commercialTrack,
  }
  );

  factory TrainDetails.fromJson(Map<String, dynamic> json) {
    return TrainDetails(
      stationShortCode: json['stationShortCode'],
      type: json['type'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      actualTime: json['actualTime'] != null 
          ? DateTime.parse(json['actualTime'])
          : null,
      differenceInMinutes: json['differenceInMinutes'],
      trainStopping: json['trainStopping'],
      commercialTrack: json['commercialTrack'],
    );
  }
}