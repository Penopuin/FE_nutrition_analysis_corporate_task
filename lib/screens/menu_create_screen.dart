import 'package:flutter/material.dart';
import '../services/nutrition_api_service.dart';
import '../screens/ai_comment_menu_screen.dart';
import '../models/selected_ingredients.dart';
import '../models/nutrition_item.dart';

class MenuCreateScreen extends StatefulWidget {
  const MenuCreateScreen({super.key});

  @override
  State<MenuCreateScreen> createState() => _MenuCreateScreenState();
}

class _MenuCreateScreenState extends State<MenuCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitMenu() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final price = int.parse(_priceController.text.trim());

    try {
      final response = await NutritionApiService().createMenu(
        name: name,
        price: price,
        ingredients: SelectedIngredients.toJsonList(),
      );

      if (response['menu_id'] != null) {
        // 예시: 실제로는 분석 API나 코멘트 API로 받아야 할 수 있음
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AiCommentMenuScreen(
              item: NutritionItem(
                food_name: name,
                calorie_kcal: 0, // 추후 분석 결과로 채우기
                protein_g: 0,
                fat_g: 0,
                carbohydrate_g: 0,
                sugar_g: 0,
                saturated_fat_g: 0,
                trans_fat_g: 0,
                sodium_mg: 0,
                cholesterol_mg: 0,
                serving_size_g: 0,
              ),
              price: price,
              aiComment: 'AI 코멘트는 추후 연결 예정',
            ),
          ),
        );
      } else {
        throw Exception(response['error'] ?? '서버 오류');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("메뉴 이름 및 가격 설정")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                maxLength: 30,
                decoration: const InputDecoration(
                  labelText: "메뉴명",
                  hintText: "예: 닭가슴살 샐러드",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final valid = RegExp(r'^[가-힣a-zA-Z0-9 ]+$');
                  if (value == null || value.trim().isEmpty) {
                    return '메뉴명을 입력해주세요.';
                  }
                  if (!valid.hasMatch(value)) {
                    return '한글, 영문, 숫자, 공백만 허용됩니다.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "가격",
                  hintText: "예: 7000",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final price = int.tryParse(value ?? '');
                  if (price == null) return '숫자를 입력해주세요.';
                  if (price < 500 || price > 50000) {
                    return '가격은 500원 이상 50,000원 이하입니다.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitMenu,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text("메뉴 생성하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
