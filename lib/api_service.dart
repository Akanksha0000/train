import 'dart:convert';
import 'package:http/http.dart' as http;

class TrainTrafficService {
  final String baseUrl = "https://rata.digitraffic.fi/api/v1/";

  Future<List<dynamic>> fetchTrainLocations() async {
    final url = Uri.parse("$baseUrl/trains/latest/locations");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load train locations');
    }
  }

  Future<Map<String, dynamic>> fetchTrainDetails(int trainNumber) async {
    final url = Uri.parse("$baseUrl/trains/latest/$trainNumber");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load train details');
    }
  }
}