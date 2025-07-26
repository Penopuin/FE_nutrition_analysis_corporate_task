import 'package:flutter/material.dart';
import '../models/nutrition_item.dart';
import '../services/nutrition_api_service.dart';
import 'nutrition_input_screen.dart';

class IngredientSearchScreen extends StatefulWidget {
  const IngredientSearchScreen({super.key});

  @override
  State<IngredientSearchScreen> createState() => _IngredientSearchScreenState();
}

class _IngredientSearchScreenState extends State<IngredientSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<NutritionItem> _results = [];
  bool _isLoading = false;

  void _onSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final items = await NutritionApiService().fetchNutritionItems(query);
      setState(() {
        _results = items;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색 중 오류 발생: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _goToManualInput() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NutritionInputScreen(
          title: '',
          amount: '',
          calorie: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('재료 검색'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 👉 직접 입력 버튼 추가
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _goToManualInput,
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('직접 입력하기'),
              ),
            ),

            // 검색창
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '재료명 입력',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onSearch,
                  child: const Text('검색'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 결과
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
              child: _results.isEmpty
                  ? const Center(child: Text('검색 결과가 없습니다.'))
                  : ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final item = _results[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('열량: ${item.calories} kcal'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NutritionInputScreen(
                            title: item.name,
                            amount: item.servingSize,
                            calorie: item.calories,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
