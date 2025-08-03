import 'package:flutter/material.dart';
import '../models/selected_ingredients.dart';
import '../services/nutrition_api_service.dart';
import 'ai_comment_menu_screen.dart';

class MenuCreateScreen extends StatefulWidget {
  const MenuCreateScreen({super.key});

  @override
  State<MenuCreateScreen> createState() => _MenuCreateScreenState();
}

class _MenuCreateScreenState extends State<MenuCreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _submitMenu() async {
    final name = _nameController.text.trim();
    final price = int.tryParse(_priceController.text.trim()) ?? 0;
    final ingredients = SelectedIngredients.toJsonList();

    if (name.isEmpty || price <= 0 || ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('메뉴명, 가격, 재료를 모두 입력해주세요.')),
      );
      return;
    }

    try {
      final response = await NutritionApiService().createMenu(
        name: name,
        price: price,
        ingredients: ingredients,
      );

      if (response != null && response['menu_id'] != null) {
        final menuId = response['menu_id'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AiCommentMenuScreen(menuId: menuId),
          ),
        );
      } else {
        // ❗️에러 메시지를 세부적으로 보여주는 부분
        final errMsg = response['error'] ?? '메뉴 생성 실패';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errMsg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('에러 발생: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final selectedCount = SelectedIngredients.count;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('메뉴 만들기'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('메뉴 이름', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: '예: 닭가슴살 샐러드',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('가격 (원)', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '예: 8000',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text('선택된 재료 수: $selectedCount', style: const TextStyle(fontSize: 14)),

            const Spacer(),
            ElevatedButton(
              onPressed: _submitMenu,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2AB382),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('메뉴 생성하기', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
