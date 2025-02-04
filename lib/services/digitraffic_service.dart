import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/train.dart';

class DigitrafficService {
  final String baseUrl = 'https://rata.digitraffic.fi/api/v1';

  Future<List<Train>> getTrains() async {
    final response = await http.get(
      Uri.parse('$baseUrl/train-locations/latest'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Train.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trains');
    }
  }

  Future<List<TrainDetails>> getTrainDetails(int trainNumber) async {
    final response = await http.get(
      Uri.parse('$baseUrl/trains/latest/$trainNumber'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isEmpty) return [];
      
      final timeTableRows = data[0]['timeTableRows'] as List;
      return timeTableRows
          .map((json) => TrainDetails.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load train details');
    }
  }
}
