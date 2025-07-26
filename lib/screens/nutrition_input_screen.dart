import 'package:flutter/material.dart';

class NutritionInputScreen extends StatelessWidget {
  final String title;
  final String amount;
  final String calorie;

  const NutritionInputScreen({
    super.key,
    required this.title,
    required this.amount,
    required this.calorie,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    );

    final titleController = TextEditingController(text: title);

    return Scaffold(
      appBar: AppBar(
        title: const Text('영양성분 직접 입력'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('재료명'),
          const SizedBox(height: 8),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: inputBorder,
            ),
          ),
          const SizedBox(height: 16),

          const Text('내용량*'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: amount,
                    border: inputBorder,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('g'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Divider(height: 2, thickness: 2, color: Colors.grey[300]),

          const SizedBox(height: 16),
          const Text('영양성분', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          const Text('총 칼로리'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: calorie,
                    border: inputBorder,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              const Text('kcal'),
            ],
          ),

          const SizedBox(height: 24),
          _buildNutrientRow('탄수화물', 'g', inputBorder, hint: '10'),
          _buildNutrientRow('단백질', 'g', inputBorder, hint: '3'),
          _buildNutrientRow('지방', 'g', inputBorder, hint: '3'),
          _buildNutrientRow('포화지방', 'g', inputBorder, hint: '1'),
          _buildNutrientRow('나트륨*', 'mg', inputBorder, hint: '600'),

          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2AB382),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '메뉴 만들기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Color(0xFF2AB382),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(
      String label,
      String unit,
      OutlineInputBorder border, {
        String? hint,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                color: label.contains('*') ? Colors.red : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                border: border,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 8),
          Text(unit),
        ],
      ),
    );
  }
}
