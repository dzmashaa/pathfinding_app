import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shortest_distance/models/tasks.dart';

class ApiService {
  String baseUrl;

  ApiService(this.baseUrl);

  Future<List<PathfindingTask>> getTask() async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData['error'] == false) {
          final List<dynamic> rawData = decodedData['data'];
          return rawData.map((json) => PathfindingTask.fromJson(json)).toList();
        } else {
          throw Exception(decodedData['message'] ?? 'Unknown API error');
        }
      } else {
        String errorMessage = 'Server error (code ${response.statusCode})';

        try {
          final decodedError = jsonDecode(response.body);
          if (decodedError['message'] != null) {
            errorMessage = decodedError['message'];
          }
        } catch (_) {}
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('No internet connection or server is unreachable.');
    } on FormatException {
      throw Exception('Received invalid data from the server.');
    } catch (err) {
      throw Exception(err.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<bool> sendResults(List<Map<String, dynamic>> results) async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(results),
      );
      final decodedData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decodedData['error'] == false;
      } else {
        final errorMessage =
            decodedData['message'] ??
            'Server error (code ${response.statusCode})';
        throw Exception(errorMessage);
      }
    } catch (err) {
      throw Exception('$err');
    }
  }
}
