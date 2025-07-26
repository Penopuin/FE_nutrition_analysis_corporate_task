import 'package:flutter/material.dart';
import '../models/nutrition_item.dart';
import '../models/selected_ingredients.dart';
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

  // 검색 API 호출
  Future<void> _onSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _results = [];
    });

    try {
      final items = await NutritionApiService().searchAllSources(query);
      setState(() => _results = items);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색 실패: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _navigateToInput(NutritionItem item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NutritionInputScreen(item: item)),
    );
    setState(() {}); // 누적된 재료 리스트 갱신
  }

  Widget _buildResultItem(NutritionItem item) {
    return ListTile(
      title: Text(item.foodName ?? ''),
      subtitle: Text('${item.serving_size_g?.toStringAsFixed(0) ?? '-'}g | ${item.calorieKcal?.toStringAsFixed(0) ?? '-'} kcal'),
      onTap: () => _navigateToInput(item),
    );
  }

  Widget _buildSelectedList() {
    final items = SelectedIngredients.all;
    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24),
        Text('추가된 재료 (${items.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...items.map((item) => Card(
          child: ListTile(
            title: Text(item.foodName ?? ''),
            subtitle: Text('${item.serving_size_g?.toStringAsFixed(0) ?? '-'}g | ${item.calorieKcal?.toStringAsFixed(0) ?? '-'} kcal'),
          ),
        )),
        const SizedBox(height: 80), // 하단 버튼과 간격
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = SelectedIngredients.count;

    return Scaffold(
      appBar: AppBar(title: const Text('식재료 검색')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 검색창
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: '식재료 이름 입력',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _onSearch,
                  child: const Text('검색'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 결과 & 누적 리스트
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_results.isEmpty)
              const Text('검색 결과가 없습니다.')
            else
              Expanded(
                child: ListView(
                  children: [
                    ..._results.map(_buildResultItem),
                    _buildSelectedList(),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            // TODO: 메뉴 최종 생성 화면 또는 POST 전송
          },
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
              const Text('메뉴 만들기', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 12,
                child: Text(
                  '$selectedCount',
                  style: const TextStyle(color: Color(0xFF2AB382), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
