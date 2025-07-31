import 'package:flutter/material.dart';
import '../models/nutrition_item.dart';
import '../models/selected_ingredients.dart';
import '../services/nutrition_api_service.dart';
import 'ai_comment_menu_screen.dart';

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AiCommentMenuScreen(
              item: NutritionItem(
                food_name: name,
                calorie_kcal: 0,
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
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('메뉴 추가', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('메뉴명*', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      maxLength: 30,
                      decoration: InputDecoration(
                        border: border,
                        enabledBorder: border,
                        focusedBorder: border,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                    const Text('메뉴가격*', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: border,
                        enabledBorder: border,
                        focusedBorder: border,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '기업의 실제 앱 UI 화면으로 대체될 공간입니다.',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, offset: Offset(0, -1), blurRadius: 8),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitMenu,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2AB382),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text(
                '레시피 추가하기',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
