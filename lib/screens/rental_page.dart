import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../widgets/rental_item_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar_title.dart';
import '../widgets/category_tab_bar.dart';
import '../widgets/search_bar.dart';
import 'rental_register_page.dart';
import 'rental_qr_page.dart';

class RentalPage extends StatefulWidget {
  const RentalPage({super.key});

  @override
  State<RentalPage> createState() => _RentalPageState();
}

class RentalItem {
  final int itemId;
  final String name;
  final String college;
  int quantity;

  RentalItem({
    required this.itemId,
    required this.name,
    required this.college,
    required this.quantity,
  });
}

class _RentalPageState extends State<RentalPage> {
  static const List<String> colleges = [
    '전체', '경상대학', '공과대학', '사회과학대학', '문과대학',
    '생명·나노과학대학', '스마트융합대학', '아트&디자인테크놀로지대학', '사범대학', 'LGS대학'
  ];

  String searchText = '';
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<RentalItem> allItems = [
    RentalItem(itemId: 1, name: '우산', college: '문과대학', quantity: 5),
    RentalItem(itemId: 2, name: '보조배터리', college: '문과대학', quantity: 2),
    RentalItem(itemId: 3, name: '드라이버', college: '공과대학', quantity: 0),
  ];

  // ✅ QR 스캔 후 수량 반영
  void _navigateToQRPage(RentalItem item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QRScanPage(itemName: item.name, isRenting: true),
      ),
    );

    if (result != null && result is int) {
      setState(() {
        final matchedItem = allItems.firstWhere((i) => i.itemId == result);
        matchedItem.quantity = (matchedItem.quantity - 1).clamp(0, 999);
      });
    }
  }
  //등록 페이지 이동 + 결과 수량 반영
  void _navigateToCreatePage() async{
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RentalRegisterPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        allItems.add(RentalItem(
          itemId: result['itemId'], // 백엔드에서 반환된 고유 ID 사용
          name: result['name'],
          college: result['college'],
          quantity: result['quantity'],
        ));
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final selectedCollege = context.watch<CategoryProvider>().selected;

    List<RentalItem> filteredItems = allItems.where((item) {
      final matchesCollege = selectedCollege == '전체' || item.college == selectedCollege;
      final matchesSearch = item.name.contains(searchText);
      return matchesCollege && matchesSearch;
    }).toList();

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
          const CategoryTabBar(categories: colleges),
          const SizedBox(height: 8),

          // 🔍 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '물품 검색',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.trim();
                });
              },
            ),
          ),

          const SizedBox(height: 8),

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
      //오른쪽 하단에 +버튼 추가
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePage,
        backgroundColor: Colors.indigo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
