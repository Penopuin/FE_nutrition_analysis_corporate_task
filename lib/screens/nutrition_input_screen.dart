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

  Widget _readonlyField(String label, String unit, double? value, {bool isRequired = false}) {
    final r = ratio;
    final v = value != null ? (value * r) : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(label),
                if (isRequired)
                  const Text('*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: IgnorePointer(
              ignoring: true,
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  suffixText: unit,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
                controller: TextEditingController(
                  text: v != null ? v.toStringAsFixed(1) : '-',
                ),
              ),
            ),
          ),
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
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    final selectedCount = SelectedIngredients.count;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('영양성분 직접 입력',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        leading: const BackButton(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('재료명', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.item.foodName ?? '이름 없음',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text('내용량', style: TextStyle(fontSize: 14)),
                    const Text('*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: border,
                            enabledBorder: border,
                            focusedBorder: border,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: '내용량 입력',
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 48,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              value: _unit,
                              isExpanded: true,
                              style: const TextStyle(color: Colors.black),
                              items: ['g', 'ml']
                                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _unit = val);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(thickness: 1, color: Colors.grey),
                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '영양성분',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 16),
                _readonlyField('총 칼로리', 'kcal', widget.item.calorie_kcal),
                _readonlyField('탄수화물', 'g', widget.item.carbohydrate_g),
                _readonlyField('당', 'g', widget.item.sugar_g),
                _readonlyField('단백질', 'g', widget.item.protein_g),
                _readonlyField('지방', 'g', widget.item.fat_g),
                _readonlyField('포화지방', 'g', widget.item.saturated_fat_g),
                _readonlyField('트랜스지방', 'g', widget.item.trans_fat_g),
                _readonlyField('나트륨', 'mg', widget.item.sodium_mg, isRequired: true),
                _readonlyField('콜레스테롤', 'mg', widget.item.cholesterol_mg),
              ],
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
              onPressed: _onAddIngredient,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2AB382),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '레시피 추가하기',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 12,
                    child: Text(
                      '$selectedCount',
                      style: const TextStyle(color: Color(0xFF2AB382), fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}