class Train {
  final String trainNumber;
  final String trainName;
  final List<Station> stations;
  final Position currentPosition;
  final String sourceStation;
  final String destinationStation;
  final String currentStationName;
  final String currentStationCode;
  final DateTime trainStartDate;
  final int delay;
  final bool atDestination;
  final String status;
  final String platformNumber;

  Train({
    required this.trainNumber,
    required this.trainName,
    required this.stations,
    required this.currentPosition,
    required this.sourceStation,
    required this.destinationStation,
    required this.currentStationName,
    required this.currentStationCode,
    required this.trainStartDate,
    required this.delay,
    required this.atDestination,
    required this.status,
    required this.platformNumber,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    
    
    final List<Station> stations = [];
    for (var station in data['previous_stations']) {
      stations.add(Station.fromJson(station));
      
    
      if (station['non_stops'] != null) {
        for (var nonStop in station['non_stops']) {
          stations.add(Station.fromJson(nonStop, isNonStop: true));
        }
      }
    }

   
    Position currentPosition;
    if (stations.isNotEmpty) {
      var lastStation = stations.lastWhere(
        (station) => station.position.latitude != 0 && station.position.longitude != 0,
        orElse: () => stations.last,
      );
      currentPosition = lastStation.position;
    } else {
      currentPosition = Position(latitude: 0, longitude: 0);
    }

    return Train(
      trainNumber: data['train_number'],
      trainName: data['train_name'],
      stations: stations,
      currentPosition: currentPosition,
      sourceStation: data['source_stn_name'],
      destinationStation: data['dest_stn_name'],
      currentStationName: data['current_station_name'].toString().replaceAll('~', ''),
      currentStationCode: data['current_station_code'],
      trainStartDate: DateTime.parse(data['train_start_date']),
      delay: data['delay'] ?? 0,
      atDestination: data['at_dstn'] ?? false,
      status: data['status'] ?? '',
      platformNumber: data['platform_number']?.toString() ?? 'N/A',
    );
  }
}

class Station {
  final String name;
  final String code;
  final Position position;
  final DateTime? scheduledArrival;
  final DateTime? scheduledDeparture;
  final DateTime? actualArrival;
  final DateTime? actualDeparture;
  final int haltDuration;
  final bool isDelayed;
  final int? delay;
  final bool isNonStop;
  final String platformNumber;
  final int distanceFromSource;

  Station({
    required this.name,
    required this.code,
    required this.position,
    this.scheduledArrival,
    this.scheduledDeparture,
    this.actualArrival,
    this.actualDeparture,
    required this.haltDuration,
    required this.isDelayed,
    this.delay,
    required this.isNonStop,
    required this.platformNumber,
    required this.distanceFromSource,
  });

  factory Station.fromJson(Map<String, dynamic> json, {bool isNonStop = false}) {
    String? sta = json['sta'];
    String? std = json['std'];
    String? eta = json['eta'];
    String? etd = json['etd'];

    DateTime? parseTime(String? time) {
      if (time == null || time.isEmpty) return null;
      try {
       
        final parts = time.split(':');
        final now = DateTime.now();
        return DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      } catch (e) {
        return null;
      }
    }

    return Station(
      name: json['station_name'],
      code: json['station_code'],
      position: Position(
        latitude: (json['station_lat'] ?? 0.0).toDouble(),
        longitude: (json['station_lng'] ?? 0.0).toDouble(),
      ),
      scheduledArrival: parseTime(sta),
      scheduledDeparture: parseTime(std),
      actualArrival: parseTime(eta),
      actualDeparture: parseTime(etd),
      haltDuration: json['halt']?.toInt() ?? 0,
      isDelayed: (json['arrival_delay'] ?? 0) > 0,
      delay: json['arrival_delay']?.toInt(),
      isNonStop: isNonStop,
      platformNumber: json['platform_number']?.toString() ?? 'N/A',
      distanceFromSource: json['distance_from_source']?.toInt() ?? 0,
    );
  }
}

class Position {
  final double latitude;
  final double longitude;

  Position({required this.latitude, required this.longitude});
}