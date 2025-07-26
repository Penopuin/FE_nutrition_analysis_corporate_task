class NutritionItem {
  final String? food_code;
  final String? food_name;
  final double? serving_size_g;
  final double? calorie_kcal;
  final double? carbohydrate_g;
  final double? sugar_g;
  final double? protein_g;
  final double? fat_g;
  final double? saturated_fat_g;
  final double? trans_fat_g;
  final double? sodium_mg;
  final double? cholesterol_mg;

  NutritionItem({
    this.food_code,
    this.food_name,
    this.serving_size_g,
    this.calorie_kcal,
    this.carbohydrate_g,
    this.sugar_g,
    this.protein_g,
    this.fat_g,
    this.saturated_fat_g,
    this.trans_fat_g,
    this.sodium_mg,
    this.cholesterol_mg,
  });

  factory NutritionItem.fromJson(Map<String, dynamic> json) {
    return NutritionItem(
      food_code: json['food_code'],
      food_name: json['food_name'],
      serving_size_g: (json['serving_size_g'] as num?)?.toDouble(),
      calorie_kcal: (json['calorie_kcal'] as num?)?.toDouble(),
      carbohydrate_g: (json['carbohydrate_g'] as num?)?.toDouble(),
      sugar_g: (json['sugar_g'] as num?)?.toDouble(),
      protein_g: (json['protein_g'] as num?)?.toDouble(),
      fat_g: (json['fat_g'] as num?)?.toDouble(),
      saturated_fat_g: (json['saturated_fat_g'] as num?)?.toDouble(),
      trans_fat_g: (json['trans_fat_g'] as num?)?.toDouble(),
      sodium_mg: (json['sodium_mg'] as num?)?.toDouble(),
      cholesterol_mg: (json['cholesterol_mg'] as num?)?.toDouble(),
    );
  }

  // ✅ UI 코드와 호환되도록 Getter 추가
  String? get foodName => food_name;
  double? get calorieKcal => calorie_kcal;
}