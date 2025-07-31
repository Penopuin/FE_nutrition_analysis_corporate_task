import 'package:flutter/material.dart';
import '../models/nutrition_item.dart';
import 'package:intl/intl.dart';

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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
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
                  // 메뉴명
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

                  // 가격
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

                  // 칼로리 및 성분
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
