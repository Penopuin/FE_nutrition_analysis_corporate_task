import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_keys.dart';
import '../models/nutrition_item.dart';

class NutritionApiService {
  static const String _baseUrl = 'https://openapi.foodsafetykorea.go.kr/api';
  static const String _dataType = 'json';
  static const String _dataId = 'I2790'; // 식품영양성분DB 기준

  Future<List<NutritionItem>> fetchNutritionItems(String query, {int start = 1, int end = 20}) async {
    final encodedKey = ApiKeys.encodedServiceKey;

    final url = Uri.parse('$_baseUrl/$encodedKey/$_dataType/$_dataId/$start/$end/DESC_KOR=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> rawItems = decoded[_dataId]['row'];

      // 필수 값 필터링 전처리
      final filteredItems = rawItems
          .where((e) =>
      e['DESC_KOR'] != null &&
          e['SERVING_SIZE'] != null &&
          e['NUTR_CONT1'] != null)
          .toList();

      return filteredItems.map((e) => NutritionItem.fromJson(e)).toList();
    } else {
      throw Exception('API 호출 실패: ${response.statusCode}');
    }
  }
}
