import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/rental_page.dart';
import '../screens/return_page.dart';
import '../screens/mission_home.dart';
import '../widgets/custom_app_bar_title.dart';
import '../widgets/bottom_nav_bar.dart';
import 'utils/shared_preferences_util.dart';


class RentalStatusPage extends StatefulWidget {
  final Map<String, dynamic>? rental; // ⬅️ 전달받을 대여 정보 (nullable)

  const RentalStatusPage({super.key, this.rental});

  @override
  State<RentalStatusPage> createState() => _RentalStatusPageState();
}

class _RentalStatusPageState extends State<RentalStatusPage> {
  List<Map<String, dynamic>> myRentals = [];

  @override
  void initState() {
    super.initState();
    // ✅ rental 파라미터가 있을 경우 초기 목록에 추가
    if (widget.rental != null) {
      myRentals.add(widget.rental!);
    }
  }

  Future<void> _navigateToRentalPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RentalPage()),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        myRentals.add(result); // ✅ 대여 정보 목록에 추가
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: const [
                Text("📦 대여중인 물품", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: myRentals.isEmpty
                ? const Center(child: Text("대여중인 물품이 없습니다."))
                : ListView.builder(
              itemCount: myRentals.length,
              itemBuilder: (context, index) {
                final rental = myRentals[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rental['item'] ?? rental['name'] ?? '이름 없음',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "반납 예정일: ${rental['dueDate']?.substring(0, 10) ?? 'N/A'}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "상태: ${rental['statusMessage'] ?? ''}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        /*Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                myRentals.removeAt(index); // ✅ 반납 시 제거
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("반납하기"),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RentalPage(),
                        ),
                      );
                      if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          myRentals.add(result); // ✅ 대여 완료 시 로컬 목록에 추가
                        });
                      }
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text("대여하러 가기"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReturnPage(
                            myRentals: myRentals,
                            onReturnComplete: (index) {
                              setState(() {
                                myRentals.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.assignment_return),
                    label: const Text("반납하러 가기"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
