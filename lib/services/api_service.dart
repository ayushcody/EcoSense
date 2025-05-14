import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_data.dart';

class ApiService {
  final String endpoint;
  final String apiKey;

  ApiService({required this.endpoint, this.apiKey = ''});

  Future<List<SensorData>> fetchLatest() async {
    if (endpoint.isEmpty) {
      // Return dummy data for testing if no endpoint is set
      return _getDummyData();
    }

    final uri = Uri.parse('$endpoint/sensors/latest');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (apiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer $apiKey';
    }

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => SensorData.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Return dummy data for testing if API call fails
      return _getDummyData();
    }
  }

  // Generate some dummy data for testing
  List<SensorData> _getDummyData() {
    return [
      SensorData(
        id: 'temp_1',
        name: 'Temperature',
        unit: '°C',
        icon: 'thermostat',
        value: 25.5,
        timestamp: DateTime.now(),
      ),
      SensorData(
        id: 'hum_1',
        name: 'Humidity',
        unit: '%',
        icon: 'water_drop',
        value: 68.3,
        timestamp: DateTime.now(),
      ),
      SensorData(
        id: 'air_1',
        name: 'Air Quality',
        unit: 'AQI',
        icon: 'air',
        value: 42.0,
        timestamp: DateTime.now(),
      ),
    ];
  }

  Future<List<SensorData>> fetchHistory(String sensorId) async {
    final uri = Uri.parse('$endpoint/history?sensor=$sensorId');
    final headers = <String, String>{};
    if (apiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer $apiKey';
    }
    final resp = await http.get(uri, headers: headers);
    if (resp.statusCode != 200) {
      throw Exception('Error fetching history data: ${resp.statusCode}');
    }
    final List<dynamic> list = jsonDecode(resp.body) as List<dynamic>;
    return list
        .map((e) => SensorData.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
