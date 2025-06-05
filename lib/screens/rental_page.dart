import 'package:flutter/material.dart';
import '../widgets/rental_item_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar_title.dart';
import '../widgets/category_tab_bar.dart';
import '../widgets/search_bar.dart';

class RentalPage extends StatefulWidget {
  const RentalPage({super.key});

  @override
  State<RentalPage> createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  final List<String> colleges = [
    '문과대학', '사범대학', '공과대학', '스마트융합대학', '경상대학',
    '사회과학대학', '생명·나노과학대학', '아트&디자인테크놀로지대학', '린튼글로벌스쿨', '탈메이지 교양·융합대학'
  ];

  String selectedCollege = '문과대학';
  String searchText = '';
  final TextEditingController _itemController = TextEditingController();

  final Map<String, List<String>> rentalItems = {
    '문과대학': ['우산', '보조배터리'],
    '공과대학': ['드라이버', '충전기'],
  };

  @override
  Widget build(BuildContext context) {
    final List<String> filteredItems = rentalItems[selectedCollege]
        ?.where((item) => item.contains(searchText))
        .toList() ??
        [];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomAppBarTitle(),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📚 단과대 카테고리Add commentMore actions
          const CategoryTabBar(
              categories: [
                '전체', '경상대학', '공과대학', '사회과학대힉', '문과대학',
                '사회과학대학', '생명·나노과학대학', '스마트융합대학', '아트&디자인테크놀로지대학', '사범대학','LGS대학'
              ]
          ),
          const SizedBox(height: 8),

          // 🔍 검색창
          const CustomSearchBar(),

          // ➕ 물품 등록
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      hintText: '새 물품 이름 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,  // 버튼 배경색
                    foregroundColor: Colors.white,   // 버튼 텍스트 색
                  ),
                  onPressed: () {
                    final newItem = _itemController.text.trim();
                    if (newItem.isNotEmpty) {
                      setState(() {
                        rentalItems[selectedCollege] ??= [];
                        rentalItems[selectedCollege]!.add(newItem);
                        _itemController.clear();
                      });
                    }
                  },
                  child: const Text("등록"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 🎒 물품 목록
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return RentalItemCard(
                  item: item,
                  onRented: (result) {
                    Navigator.pop(context, result);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
