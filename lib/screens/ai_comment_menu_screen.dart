import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menu_create_screen.dart'; // 상단 import 추가
import '../models/nutrition_item.dart';

class AiCommentMenuScreen extends StatefulWidget {
  final int menuId;

  const AiCommentMenuScreen({super.key, required this.menuId});

  @override
  State<AiCommentMenuScreen> createState() => _AiCommentMenuScreenState();
}

class _AiCommentMenuScreenState extends State<AiCommentMenuScreen> {
  final String baseUrl = 'http://10.0.2.2:5001';
  bool _isLoading = true;
  String? _menuName;
  int? _price;
  String? _aiComment;
  NutritionItem? _nutrition;
  List<String> _ingredients = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final analyzeRes = await http.get(Uri.parse('$baseUrl/menu/analyze/${widget.menuId}'));
      final commentRes = await http.get(Uri.parse('$baseUrl/menu/comment/${widget.menuId}'));
      final detailRes = await http.get(Uri.parse('$baseUrl/menu/${widget.menuId}'));

      if (analyzeRes.statusCode == 200 &&
          commentRes.statusCode == 200 &&
          detailRes.statusCode == 200) {
        final nutritionData = jsonDecode(analyzeRes.body);
        final commentData = jsonDecode(commentRes.body);
        final detailData = jsonDecode(detailRes.body);

        setState(() {
          _menuName = nutritionData['menu_name'];
          _price = detailData['price'];
          _aiComment = commentData['comment'];
          _ingredients =
          List<String>.from(detailData['ingredients'].map((e) => e['food_name'] ?? e['food_code']));

          _nutrition = NutritionItem(
            food_name: nutritionData['menu_name'],
            serving_size_g: nutritionData['total_weight_g']?.toDouble(),
            calorie_kcal: nutritionData['calorie_kcal']?.toDouble(),
            carbohydrate_g: nutritionData['carbohydrate_g']?.toDouble(),
            sugar_g: nutritionData['sugar_g']?.toDouble(),
            protein_g: nutritionData['protein_g']?.toDouble(),
            fat_g: nutritionData['fat_g']?.toDouble(),
            saturated_fat_g: nutritionData['saturated_fat_g']?.toDouble(),
            trans_fat_g: nutritionData['trans_fat_g']?.toDouble(),
            sodium_mg: nutritionData['sodium_mg']?.toDouble(),
            cholesterol_mg: nutritionData['cholesterol_mg']?.toDouble(),
          );

          _isLoading = false;
        });
      } else {
        throw Exception('데이터 불러오기 실패');
      }
    } catch (e) {
      debugPrint('오류: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _nutrientRow(String label, String? value,
      {Color labelColor = Colors.black, bool bold = false, double fontSize = 14}) {
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
              color: const Color(0xFF2AB382),
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
    final NumberFormat priceFormat = NumberFormat('#,###');

    return Scaffold(
      appBar: AppBar(
        title: const Text('메뉴 상세'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _nutrition == null
          ? const Center(child: Text('데이터를 불러오지 못했습니다'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👉 이미지 placeholder
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                '기업이 제공하는 이미지입니다',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              _menuName ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (_aiComment != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F7EF),
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_aiComment!, style: const TextStyle(fontSize: 14)),
              ),
            const SizedBox(height: 12),

            if (_price != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('가격', style: TextStyle(fontSize: 16)),
                  Text('${priceFormat.format(_price)}원',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),

            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF2AB382)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("총 칼로리 (메뉴)",
                          style: TextStyle(fontSize: 16, color: Color(0xFF2AB382))),
                      Text(
                        "${_nutrition!.calorie_kcal?.toStringAsFixed(1) ?? '-'} kcal",
                        style: const TextStyle(
                          color: Color(0xFF2AB382),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _nutrientRow("총 제공량 (g)",
                      "${_nutrition!.serving_size_g?.toStringAsFixed(0)}g",
                      bold: true),
                  const Divider(),
                  _nutrientRow("단백질", "${_nutrition!.protein_g?.toStringAsFixed(1)}g"),
                  _nutrientRow("탄수화물", "${_nutrition!.carbohydrate_g?.toStringAsFixed(1)}g"),
                  _nutrientRow("└ 당", "${_nutrition!.sugar_g?.toStringAsFixed(1)}g",
                      labelColor: Colors.grey[600]!, fontSize: 13),
                  _nutrientRow("지방", "${_nutrition!.fat_g?.toStringAsFixed(1)}g"),
                  _nutrientRow("└ 포화지방", "${_nutrition!.saturated_fat_g?.toStringAsFixed(1)}g",
                      labelColor: Colors.grey[600]!, fontSize: 13),
                  _nutrientRow("└ 트랜스지방", "${_nutrition!.trans_fat_g?.toStringAsFixed(1)}g",
                      labelColor: Colors.grey[600]!, fontSize: 13),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text("나트륨", style: TextStyle(fontSize: 14)),
                            Text("${_nutrition!.sodium_mg?.toStringAsFixed(1)}mg",
                                style: const TextStyle(
                                    color: Color(0xFF2AB382),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text("콜레스테롤", style: TextStyle(fontSize: 14)),
                            Text("${_nutrition!.cholesterol_mg?.toStringAsFixed(1)}mg",
                                style: const TextStyle(
                                    color: Color(0xFF2AB382),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    "※ 1일 영양성분 기준치는 2,000kcal 기준이며\n개인의 필요 열량에 따라 다를 수 있습니다.",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
