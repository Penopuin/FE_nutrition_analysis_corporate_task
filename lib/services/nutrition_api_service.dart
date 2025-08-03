import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nutrition_item.dart';

class NutritionApiService {
  final String baseUrl = 'http://10.0.2.2:5001'; // Android emulator용 주소

  /// 🔍 전체 소스에서 식재료 검색
  Future<List<NutritionItem>> searchAllSources(String query) async {
    final uri = Uri.parse('$baseUrl/search/all?name=$query');
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception('서버 오류: ${res.statusCode}');
    }

    final data = jsonDecode(res.body);
    final List items = data['items'];
    return items.map((e) => NutritionItem.fromJson(e)).toList();
  }

  /// 📝 메뉴 생성
  Future<Map<String, dynamic>> createMenu({
    required String name,
    required int price,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    final url = Uri.parse('$baseUrl/menu/create');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'price': price,
        'ingredients': ingredients,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final err = jsonDecode(response.body);
      return {'error': err['error'] ?? '서버 오류'};
    }
  }

  /// 📥 메뉴 단건 조회
  Future<Map<String, dynamic>?> getMenu(int id) async {
    final url = Uri.parse('$baseUrl/menu/$id');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print('메뉴 조회 실패: ${res.body}');
      return null;
    }
  }

  /// 📊 메뉴 영양 분석
  Future<Map<String, dynamic>?> analyzeMenu(int id) async {
    final url = Uri.parse('$baseUrl/menu/analyze/$id');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print('영양 분석 실패: ${res.body}');
      return null;
    }
  }

  /// 💬 AI 코멘트
  Future<Map<String, dynamic>?> getComment(int id) async {
    final url = Uri.parse('$baseUrl/menu/comment/$id');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print('AI 코멘트 실패: ${res.body}');
      return null;
    }
  }

  /// 💡 강조 조건 (선택)
  Future<Map<String, dynamic>?> getEmphasis(int id) async {
    final url = Uri.parse('$baseUrl/menu/emphasis/$id');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print('강조 조건 실패: ${res.body}');
      return null;
    }
  }
}
