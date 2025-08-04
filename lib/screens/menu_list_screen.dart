import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bluemoon_flutter/screens/ingredient_search_screen.dart';

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  final String baseUrl = 'http://10.0.2.2:5001';
  bool _isLoading = true;
  List<dynamic> _menus = [];
  List<dynamic> _filteredMenus = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  Future<void> _fetchMenus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/menu'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _menus = data;
          _filteredMenus = data;
          _isLoading = false;
        });
      } else {
        throw Exception('메뉴 불러오기 실패');
      }
    } catch (e) {
      debugPrint('에러: $e');
      setState(() => _isLoading = false);
    }
  }

  void _search(String query) {
    setState(() {
      _searchQuery = query;
      _filteredMenus = _menus.where((menu) => menu['name'].toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _removeMenuFromUI(int menuId) {
    setState(() {
      _menus.removeWhere((menu) => menu['id'] == menuId);
      _filteredMenus.removeWhere((menu) => menu['id'] == menuId);
    });
  }

  Widget _buildMenuCard(Map<String, dynamic> menu) {
    final formatter = NumberFormat('#,###');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 텍스트 영역
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu['name'],
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  '${formatter.format(menu['price'])}원',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: List.generate(menu['tags']?.length ?? 0, (i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text('#${menu['tags'][i]}', style: const TextStyle(fontSize: 12)),
                    );
                  }),
                )
              ],
            ),
          ),
          const SizedBox(width: 4),
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image_outlined, size: 36, color: Colors.grey),
              ),
              GestureDetector(
                onTap: () => _removeMenuFromUI(menu['id']),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black26,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            '메뉴/옵션 관리',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
          bottom: const TabBar(
            labelColor: Color(0xFF2AB382),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF2AB382),
            tabs: [
              Tab(text: '메뉴 관리'),
              Tab(text: '옵션 관리'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: '찾으시는 메뉴명을 검색해주세요!',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    ),
                    onChanged: _search,
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['인기 샐러드 메뉴', '건강 포케', '랩, 샌드위치'].map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(
                            label: Text(category),
                            backgroundColor: const Color(0xFFF5F5F5),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // 메뉴 카테고리 추가
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2AB382),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '+ 메뉴 카테고리 추가',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IngredientSearchScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2AB382),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '+ 메뉴 추가',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('카테고리 1',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('수정 하기',
                          style: TextStyle(fontSize: 14, color: Color(0xFF2AB382))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _filteredMenus.isEmpty
                        ? const Center(child: Text('메뉴가 없습니다'))
                        : ListView.builder(
                      itemCount: _filteredMenus.length,
                      itemBuilder: (context, index) {
                        return _buildMenuCard(_filteredMenus[index]);
                      },
                    ),
                  )
                ],
              ),
            ),
            const Center(child: Text('옵션 관리 페이지 준비 중')),
          ],
        ),
      ),
    );
  }
}
