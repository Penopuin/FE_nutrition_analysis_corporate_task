
import 'package:flutter/material.dart';
import '../models/nutrition_item.dart';
import '../models/selected_ingredients.dart';

class NutritionInputScreen extends StatefulWidget {
  final NutritionItem item;

  const NutritionInputScreen({super.key, required this.item});

  @override
  State<NutritionInputScreen> createState() => _NutritionInputScreenState();
}

class _NutritionInputScreenState extends State<NutritionInputScreen> {
  late TextEditingController _amountController;
  String _unit = 'g';

  double get ratio {
    final input = double.tryParse(_amountController.text);
    final base = widget.item.serving_size_g ?? 100;
    if (input == null || base == 0) return 1.0;
    return input / base;
  }

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.item.serving_size_g?.toStringAsFixed(1) ?? '100',
    );
    _amountController.addListener(() => setState(() {}));
  }

  Widget _readonlyRow(String label, String unit, double? value) {
    final r = ratio;
    final v = value != null ? (value * r) : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(v != null ? v.toStringAsFixed(2) : '-'),
            ),
          ),
          const SizedBox(width: 8),
          Text(unit),
        ],
      ),
    );
  }

  void _onAddIngredient() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내용량을 올바르게 입력해주세요.')),
      );
      return;
    }

    final updatedItem = NutritionItem(
      food_code: widget.item.food_code,
      food_name: widget.item.food_name,
      serving_size_g: amount,
      calorie_kcal: widget.item.calorie_kcal,
      carbohydrate_g: widget.item.carbohydrate_g,
      sugar_g: widget.item.sugar_g,
      protein_g: widget.item.protein_g,
      fat_g: widget.item.fat_g,
      saturated_fat_g: widget.item.saturated_fat_g,
      trans_fat_g: widget.item.trans_fat_g,
      sodium_mg: widget.item.sodium_mg,
      cholesterol_mg: widget.item.cholesterol_mg,
    );

    SelectedIngredients.add(updatedItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('영양성분 입력'),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('재료명', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Text(widget.item.foodName ?? '이름 없음'),

                const SizedBox(height: 24),
                const Text('내용량'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '내용량 입력',
                          border: border,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _unit,
                      items: ['g', 'ml'].map((u) {
                        return DropdownMenuItem(value: u, child: Text(u));
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _unit = val ?? 'g');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                Divider(thickness: 2),
                const SizedBox(height: 16),
                const Text('영양성분 (자동 계산)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                _readonlyRow('칼로리', 'kcal', widget.item.calorie_kcal),
                _readonlyRow('탄수화물', 'g', widget.item.carbohydrate_g),
                _readonlyRow('당', 'g', widget.item.sugar_g),
                _readonlyRow('단백질', 'g', widget.item.protein_g),
                _readonlyRow('지방', 'g', widget.item.fat_g),
                _readonlyRow('포화지방', 'g', widget.item.saturated_fat_g),
                _readonlyRow('트랜스지방', 'g', widget.item.trans_fat_g),
                _readonlyRow('나트륨', 'mg', widget.item.sodium_mg),
                _readonlyRow('콜레스테롤', 'mg', widget.item.cholesterol_mg),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _onAddIngredient,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2AB382),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                '레시피 추가하기',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
