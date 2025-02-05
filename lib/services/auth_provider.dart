import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/secret.dart';
import '../models/train.dart';


class DigitTrafficService {
  Future<Train> getLiveTrainStatus(String trainNo, int startDay) async {
    try {
      final response = await http.get(
        Uri.parse('\$baseUrl/liveTrainStatus?trainNo=\$trainNo&startDay=\$startDay'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': 'irctc1.p.rapidapi.com',
        },
      );

      print('Response status: \${response.statusCode}');
      print('Response body: \${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

      
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          return Train.fromJson(jsonResponse);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load train data');
        }
      } else {
        throw Exception('Failed to load train status. Status code: \${response.statusCode}');
      }
    } catch (e) {
      print('Error in getLiveTrainStatus: \$e');
      throw Exception('Failed to load train status: \$e');
    }
  }
}

