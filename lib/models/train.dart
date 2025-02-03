class Train {
  final String trainNumber;
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
      trainNumber: json['trainNumber'].toString(),
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
  final String trainNumber;
  final String trainType;
  final String departureStation;
  final String destinationStation;
  final DateTime scheduledDeparture;
  final DateTime? actualDeparture;

  TrainDetails({
    required this.trainNumber,
    required this.trainType,
    required this.departureStation,
    required this.destinationStation,
    required this.scheduledDeparture,
    this.actualDeparture,
  });

  factory TrainDetails.fromJson(Map<String, dynamic> json) {
    return TrainDetails(
      trainNumber: json['trainNumber'].toString(),
      trainType: json['trainType'],
      departureStation: json['departureStation'],
      destinationStation: json['destinationStation'],
      scheduledDeparture: DateTime.parse(json['scheduledDeparture']),
      actualDeparture: json['actualDeparture'] != null
          ? DateTime.parse(json['actualDeparture'])
          : null,
    );
  }
}