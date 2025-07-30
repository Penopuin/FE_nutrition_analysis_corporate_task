import 'package:flutter/material.dart';
import '../models/nutrition_item.dart';
import '../models/selected_ingredients.dart';
import '../services/nutrition_api_service.dart';
import 'nutrition_input_screen.dart';
import 'menu_create_screen.dart';

class IngredientSearchScreen extends StatefulWidget {
  const IngredientSearchScreen({super.key});

  @override
  State<IngredientSearchScreen> createState() => _IngredientSearchScreenState();
}

class _IngredientSearchScreenState extends State<IngredientSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<NutritionItem> _results = [];
  bool _isLoading = false;

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
    setState(() {}); // 돌아왔을 때 선택된 재료 갱신
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF2AB382)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: '식재료 검색',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _onSearch(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => _searchController.clear(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedSummary() {
    final ingredients = SelectedIngredients.all;
    if (ingredients.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 26,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ingredients.map((item) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                item.foodName ?? '',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildResultItem(NutritionItem item) {
    return ListTile(
      title: Text(item.foodName ?? ''),
      subtitle: Text('${item.serving_size_g?.toStringAsFixed(0) ?? '-'}g | ${item.calorie_kcal?.toStringAsFixed(0) ?? '-'} kcal'),
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
            subtitle: Text('${item.serving_size_g?.toStringAsFixed(0) ?? '-'}g | ${item.calorie_kcal?.toStringAsFixed(0) ?? '-'} kcal'),
          ),
        )),
        const SizedBox(height: 80),
      ],
    );
  }

  void _onCreateMenuPressed() {
    if (SelectedIngredients.count == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('재료를 한 개 이상 추가해주세요.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MenuCreateScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = SelectedIngredients.count;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _buildSearchBar(),
          _buildSelectedSummary(),
          const SizedBox(height: 0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                  ? const Center(child: Text('검색 결과가 없습니다.'))
                  : ListView(
                children: [
                  ..._results.map(_buildResultItem),
                  _buildSelectedList(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: const Offset(0, -1),
              blurRadius: 8,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: ElevatedButton(
          onPressed: _onCreateMenuPressed,
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
