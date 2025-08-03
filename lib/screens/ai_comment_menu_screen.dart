import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

// NutritionItem 클래스 간단 정의 (테스트용)
// 실제 앱에서는 models/nutrition_item.dart 에서 import 하세요
class NutritionItem {
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 코멘트 예시',
      home: AiCommentMenuScreen(
        item: NutritionItem(
          food_name: "닭가슴살",
          serving_size_g: 250,
          calorie_kcal: 320,
          carbohydrate_g: 10,
          sugar_g: 5,
          protein_g: 35,
          fat_g: 15,
          saturated_fat_g: 2,
          trans_fat_g: 0,
          sodium_mg: 300,
          cholesterol_mg: 60,
        ),
        price: 10000,
        aiComment: '''
이 시스템은 공공 데이터를 활용하여 식재료의 영양 정보를 분석하고,  
사용자의 입력에 따라 맞춤형 코멘트를 생성하는 구조입니다.  
복잡한 계산 없이도 누구나 건강한 식단을 이해할 수 있도록 설계되었습니다.  
AI는 재료 기반으로 칼로리, 탄수화물, 단백질 등 주요 성분을 분석하고  
식단 목적에 맞는 피드백을 제공합니다.
''',
      ),
    );
  }
}

class AiCommentMenuScreen extends StatelessWidget {
  final NutritionItem item;
  final int price;
  final String aiComment;

  const AiCommentMenuScreen({
    super.key,
    required this.item,
    required this.price,
    required this.aiComment,
  });

  static const Color greenColor = Color(0xFF2AB382);
  static final NumberFormat _priceFormat = NumberFormat('#,###');

  Widget _nutrientRow(
      String label,
      String? value, {
        Color labelColor = Colors.black,
        bool bold = false,
        double fontSize = 14,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value ?? '-',
            style: TextStyle(
              color: greenColor,
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '메뉴 상세',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 이미지 영역 대체
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Text(
                "기업 UI 영역 (이미지 대체)",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.food_name ?? "메뉴 이름 없음",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // AI 코멘트
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F7EF),
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      aiComment,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("가격", style: TextStyle(fontSize: 16)),
                      Text(
                        "${_priceFormat.format(price)}원",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: greenColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 총 칼로리
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("총 칼로리 (메뉴)",
                                style: TextStyle(fontSize: 16, color: greenColor)),
                            Text(
                              "${item.calorie_kcal?.toStringAsFixed(1) ?? '-'} kcal",
                              style: const TextStyle(
                                color: greenColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _nutrientRow("총 제공량 (g/ml)",
                            "${item.serving_size_g?.toStringAsFixed(0) ?? '-'}g --ml",
                            labelColor: Colors.black, bold: true),
                        const Divider(color: Color(0xFFDDDDDD), thickness: 0.5),
                        _nutrientRow("단백질", "${item.protein_g?.toStringAsFixed(1)}g"),
                        _nutrientRow("탄수화물", "${item.carbohydrate_g?.toStringAsFixed(1)}g"),
                        _nutrientRow("└ 당", "${item.sugar_g?.toStringAsFixed(1)}g",
                            labelColor: Colors.grey[600]!, fontSize: 13),
                        _nutrientRow("지방", "${item.fat_g?.toStringAsFixed(1)}g"),
                        _nutrientRow("└ 포화지방", "${item.saturated_fat_g?.toStringAsFixed(1)}g",
                            labelColor: Colors.grey[600]!, fontSize: 13),
                        _nutrientRow("└ 트랜스지방", "${item.trans_fat_g?.toStringAsFixed(1)}g",
                            labelColor: Colors.grey[600]!, fontSize: 13),
                        const Divider(color: Color(0xFFDDDDDD), thickness: 0.5),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("나트륨",
                                      style: TextStyle(fontSize: 14, color: Colors.black)),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${item.sodium_mg?.toStringAsFixed(1)}mg",
                                    style: const TextStyle(
                                        color: greenColor, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("콜레스테롤",
                                      style: TextStyle(fontSize: 14, color: Colors.black)),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${item.cholesterol_mg?.toStringAsFixed(1)}mg",
                                    style: const TextStyle(
                                        color: greenColor, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Color(0xFFDDDDDD), thickness: 0.5),
                        const SizedBox(height: 12),
                        const Text(
                          "※ 1일 영양성분 기준치는 2,000kcal 기준이며\n개인의 필요 열량에 따라 다를 수 있습니다.",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
