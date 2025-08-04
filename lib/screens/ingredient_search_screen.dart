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
  final ScrollController _scrollController = ScrollController();

  List<NutritionItem> _results = [];
  bool _isLoading = false;
  int _offset = 0;
  final int _limit = 15;
  String _lastQuery = '';
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
          !_isLoading &&
          _hasMore) {
        _loadMore();
      }
    });
  }

  Future<void> _onSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _results = [];
      _offset = 0;
      _hasMore = true;
      _lastQuery = query;
    });

    try {
      final items = await NutritionApiService().searchAllSources(query);
      setState(() {
        _results = items;
        _offset = items.length;
        _hasMore = items.length == _limit;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('검색 실패: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore || _lastQuery.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final items = await NutritionApiService().searchAllSources(_lastQuery);

      setState(() {
        _results.addAll(items);
        _offset += items.length.toInt();
        _hasMore = items.length == _limit;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('추가 로딩 실패: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _navigateToInput(NutritionItem item, {int? editIndex}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NutritionInputScreen(item: item),
      ),
    );
    setState(() {});
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
      height: 32,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ingredients.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _navigateToInput(item, editIndex: index),
                    child: Text(
                      item.foodName ?? '',
                      style: const TextStyle(color: Colors.black87, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        SelectedIngredients.items.removeAt(index);
                      });
                    },
                    child: const Icon(Icons.close, size: 16, color: Colors.grey),
                  ),
                ],
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
      subtitle: Text(
        '${item.calorie_kcal?.toStringAsFixed(0) ?? '-'} kcal',
      ),
      onTap: () => _navigateToInput(item),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '식재료 검색',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          _buildSelectedSummary(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _isLoading && _results.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                  ? const Center(child: Text('검색 결과가 없습니다.'))
                  : ListView.builder(
                controller: _scrollController,
                itemCount: _results.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _results.length) {
                    return _buildResultItem(_results[index]);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
              const Text(
                '메뉴 만들기',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 12,
                child: Text(
                  '$selectedCount',
                  style: const TextStyle(
                    color: Color(0xFF2AB382),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
