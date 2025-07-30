import 'package:flutter/material.dart';
import '../models/nutrition_item.dart';

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

  Widget _nutrientRow(String label, String? value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text(value ?? '-', style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("메뉴 상세")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("images/img.png", height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(item.food_name ?? "메뉴 이름 없음", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("$price원", style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const Divider(height: 32),
            const Text("총 칼로리", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _nutrientRow("총 제공량", "${item.serving_size_g?.toStringAsFixed(0) ?? '-'}g"),
            _nutrientRow("칼로리", "${item.calorie_kcal?.toStringAsFixed(1) ?? '-'} kcal", bold: true),
            const Divider(height: 32),
            const Text("영양성분", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _nutrientRow("단백질", "${item.protein_g?.toStringAsFixed(1)}g"),
            _nutrientRow("탄수화물", "${item.carbohydrate_g?.toStringAsFixed(1)}g"),
            _nutrientRow("  └ 당", "${item.sugar_g?.toStringAsFixed(1)}g"),
            _nutrientRow("지방", "${item.fat_g?.toStringAsFixed(1)}g"),
            _nutrientRow("  └ 포화지방", "${item.saturated_fat_g?.toStringAsFixed(1)}g"),
            _nutrientRow("  └ 트랜스지방", "${item.trans_fat_g?.toStringAsFixed(1)}g"),
            _nutrientRow("나트륨", "${item.sodium_mg?.toStringAsFixed(1)}mg"),
            _nutrientRow("콜레스테롤", "${item.cholesterol_mg?.toStringAsFixed(1)}mg"),
            const Divider(height: 32),
            const Text("AI 코멘트", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Text(aiComment, style: const TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 16),
            const Text(
              "※ 1일 영양성분 기준치는 2,000 kcal 기준입니다.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
