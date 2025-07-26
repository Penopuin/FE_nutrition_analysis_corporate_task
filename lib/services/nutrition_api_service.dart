import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nutrition_item.dart';

class NutritionApiService {
  // 👉 실제 Flask 서버 주소로 변경해 주세요
  final String baseUrl = 'http://10.0.2.2:5001'; // Android emulator 전용

  /// /search/all API 호출: 최대 15개의 식재료 검색 결과 반환
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
}
