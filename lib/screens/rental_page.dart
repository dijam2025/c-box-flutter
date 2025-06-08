import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/category_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar_title.dart';
import '../widgets/category_tab_bar.dart';
import '../widgets/rental_item_card.dart';
import '../widgets/search_bar.dart';
import 'rental_register_page.dart';

import 'rental_qr_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  List<RentalItem> allItems = [
    RentalItem(itemId: 1, name: '우산', college: '문과대학', quantity: 5),
    RentalItem(itemId: 2, name: '보조배터리', college: '문과대학', quantity: 2),
    RentalItem(itemId: 3, name: '드라이버', college: '공과대학', quantity: 0),
  ];


  List<RentalItem> filteredItems = [];

  @override
  void initState() {
    super.initState();
    fetchRentalItemsFromBackend();
  }

  Future<void> fetchRentalItemsFromBackend() async {
    final response = await http.get(Uri.parse('http://172.30.1.53/rental/list'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        allItems = data.map((item) => RentalItem(
          itemId: item['itemId'],
          name: item['name'],
          college: item['college'],
          quantity: item['quantity'],
        )).toList();

        _applyCombinedFilter(); // ✅ 필터링도 다시 적용
      });
    } else {
      print('대여 물품 불러오기 실패: ${response.statusCode}');
    }
  }

  void _applyCombinedFilter() {
    final selectedCollege = context.read<CategoryProvider>().selected;

    setState(() {
      filteredItems = allItems.where((item) {
        final matchText = item.name.toLowerCase().contains(searchText.toLowerCase());
        final matchCollege = selectedCollege == '전체' || item.college == selectedCollege;
        return matchText && matchCollege;
      }).toList();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applyCombinedFilter();
  }

  void _navigateToCreatePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RentalRegisterPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        allItems.add(RentalItem(
          itemId: result['itemId'],
          name: result['name'],
          college: result['college'],
          quantity: result['quantity'],
        ));
      });
      _applyCombinedFilter();
    }
  }

  // ✅ QRScanPage로 이동하는 메서드 추가
  void _navigateToQRPage(RentalItem item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QRScanPage(itemName: item.name, isRenting: true),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        final matchedItem = allItems.firstWhere((i) => i.itemId == item.itemId);
        matchedItem.quantity = (matchedItem.quantity - 1).clamp(0, 999);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCollege = context.watch<CategoryProvider>().selected;

    final visibleItems = allItems.where((item) {
      final matchText = item.name.toLowerCase().contains(searchText.toLowerCase());
      final matchCollege = selectedCollege == '전체' || item.college == selectedCollege;
      return matchText && matchCollege;
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
      ),
      body: Column(
        children: [
          const CategoryTabBar(categories: colleges),
          const SizedBox(height: 8),
          CustomSearchBar<RentalItem>(
            allItems: allItems,
            onFiltered: (_) {},
            filter: (_, __) => true,
            onChanged: (text) {
              setState(() {
                searchText = text;
              });
              _applyCombinedFilter();
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: visibleItems.isEmpty
                ? const Center(child: Text('검색 결과가 없습니다'))
                : ListView.builder(
              itemCount: visibleItems.length,
              itemBuilder: (context, index) {
                final item = visibleItems[index];
                return RentalItemCard(
                  item: item,
                  onRented: (item) {
                    _navigateToQRPage(item); // ✅ 여기로 연결

                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          final role = prefs.getString('role');

          if (role != 'ADMIN') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("관리자만 등록할 수 있습니다.")),
            );
            return;
          }

          _navigateToCreatePage(); // ✅ ADMIN일 경우에만 페이지 이동
        },
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