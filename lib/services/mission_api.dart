// lib/services/mission_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class MissionApi {
  static const String baseUrl = 'http://1172.31.128.73:8080'; // 예: http://10.0.2.2:8080

  static Future<List<Map<String, dynamic>>> fetchMissions() async {
    final response = await http.get(Uri.parse('$baseUrl/missions'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
      return jsonList.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('게시글 불러오기 실패: ${response.statusCode}');
    }
  }
}
