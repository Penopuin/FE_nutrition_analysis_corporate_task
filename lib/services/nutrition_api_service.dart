import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nutrition_item.dart';

class NutritionApiService {
  final String baseUrl = 'http://10.0.2.2:5001'; // Android emulator

  /// 검색 API
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

  /// 메뉴 생성 API
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
}
