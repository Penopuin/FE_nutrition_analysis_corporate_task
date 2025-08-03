import 'package:bluemoon_flutter/models/nutrition_item.dart';

class SelectedIngredients {
  /// 선택된 재료들을 저장하는 정적 리스트
  static List<NutritionItem> items = [];

  /// 전체 재료 리스트 반환
  static List<NutritionItem> get all => items;

  /// 현재 재료 개수 반환
  static int get count => items.length;

  /// 재료 추가
  static void add(NutritionItem item) {
    items.add(item);
  }

  /// 특정 인덱스의 재료 삭제
  static void removeAt(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
    }
  }

  /// 전체 삭제
  static void clear() {
    items.clear();
  }

  /// 인덱스로 접근
  static NutritionItem getAt(int index) {
    return items[index];
  }

  /// 중복 체크 후 추가
  static void addIfNotExists(NutritionItem item) {
    if (!items.any((i) => i.food_code == item.food_code)) {
      items.add(item);
    }
  }

  /// JSON 리스트로 반환 (menu 생성 시 사용)
  static List<Map<String, dynamic>> toJsonList() {
    return items.map((item) => item.toJson()).toList();
  }
}
