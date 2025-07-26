class NutritionItem {
  final String name; // DESC_KOR: 재료명
  final String calories; // NUTR_CONT1: 열량(kcal)
  final String carbohydrates; // NUTR_CONT2: 탄수화물(g)
  final String protein; // NUTR_CONT3: 단백질(g)
  final String fat; // NUTR_CONT4: 지방(g)
  final String sugars; // NUTR_CONT5: 당류(g)
  final String sodium; // NUTR_CONT6: 나트륨(mg)
  final String cholesterol; // NUTR_CONT7: 콜레스테롤(mg)
  final String saturatedFat; // NUTR_CONT8: 포화지방(g)
  final String transFat; // NUTR_CONT9: 트랜스지방(g)
  final String servingSize; // SERVING_SIZE: 1회 제공량(g)

  NutritionItem({
    required this.name,
    required this.calories,
    required this.carbohydrates,
    required this.protein,
    required this.fat,
    required this.sugars,
    required this.sodium,
    required this.cholesterol,
    required this.saturatedFat,
    required this.transFat,
    required this.servingSize,
  });

  factory NutritionItem.fromJson(Map<String, dynamic> json) {
    return NutritionItem(
      name: json['DESC_KOR'] ?? '',
      calories: json['NUTR_CONT1'] ?? '',
      carbohydrates: json['NUTR_CONT2'] ?? '',
      protein: json['NUTR_CONT3'] ?? '',
      fat: json['NUTR_CONT4'] ?? '',
      sugars: json['NUTR_CONT5'] ?? '',
      sodium: json['NUTR_CONT6'] ?? '',
      cholesterol: json['NUTR_CONT7'] ?? '',
      saturatedFat: json['NUTR_CONT8'] ?? '',
      transFat: json['NUTR_CONT9'] ?? '',
      servingSize: json['SERVING_SIZE'] ?? '',
    );
  }
}
