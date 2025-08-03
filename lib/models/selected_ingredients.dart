import 'nutrition_item.dart';

class SelectedIngredients {
  static final List<NutritionItem> _items = [];

  /// 재료 추가
  static void add(NutritionItem item) {
    _items.add(item);
  }

  /// 재료 수정 (editIndex 기반 덮어쓰기)
  static void update(int index, NutritionItem updatedItem) {
    if (index >= 0 && index < _items.length) {
      _items[index] = updatedItem;
    }
  }

  /// 모든 재료 반환 (수정 불가능한 리스트로)
  static List<NutritionItem> get all => List.unmodifiable(_items);

  /// 재료 개수
  static int get count => _items.length;

  /// 모든 재료 초기화
  static void clear() {
    _items.clear();
  }

  /// JSON 변환 (Flask로 보낼 POST용)
  static List<Map<String, dynamic>> toJsonList() {
    return _items.map((item) => {
      "food_code": item.food_code,
      "amount": item.serving_size_g ?? 100.0, // 사용자가 입력한 제공량
    }).toList();
  }
}
