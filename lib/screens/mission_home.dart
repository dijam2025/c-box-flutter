import 'package:flutter/material.dart';
import '../widgets/category_tab.dart';
import '../widgets/post_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../screens/message_list_page.dart';  // ✉️ 쪽지 목록 화면 import

class MissionHome extends StatelessWidget {
  const MissionHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title을 const Row → Row로 변경 (IconButton 때문에)
        title: Row(
          children: [
            const Text(
              'C:BOX',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Spacer(),

            // 알림 버튼 + 배지
            Stack(
              children: [
                const Icon(Icons.notifications_none),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: const Text(
                      '1',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),

            //쪽지버튼
            IconButton(
              icon: const Icon(Icons.mail_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MessageListPage(),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const MainContent(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: '검색',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CategoryTab(title: '전체', isSelected: true),
              CategoryTab(title: '알바'),
              CategoryTab(title: '같이 하기'),
              CategoryTab(title: '정보 요청'),
            ],
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              PostCard(category: '알바', title: '제목', comments: 3),
              SizedBox(height: 10),
              PostCard(category: '정보 요청', title: '정보', comments: 1),
            ],
          ),
        ),
      ],
    );
  }
}


