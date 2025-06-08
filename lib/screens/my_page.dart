import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'post_list_page.dart';
import 'rental_status_page.dart';
import '../widgets/custom_app_bar_title.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String userName = '사용자';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt');
      print('hi');
      print('현재 토큰: $token');
      print('hi');

      final response = await http.get(
        Uri.parse('http://172.30.1.12:8080/users/mypage'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('응답 상태 코드: ${response.statusCode}');
      print('응답 본문: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final serverName = data['name'] ?? '이름 없음';

        setState(() => userName = serverName);
        if (token != null) {
          await prefs.setString('jwt', token);
        }
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        await prefs.clear();
        _goToLogin();
      } else {
        print('서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('네트워크 에러: $e');
    }
  }


  void _goToLogin() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _goToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: '로그아웃',
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Divider(),
          _buildMenuTile(
            context,
            icon: Icons.shopping_bag_outlined,
            title: '대여현황',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RentalStatusPage()),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuTile(
            context,
            icon: Icons.article_outlined,
            title: '내 게시글',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PostListPage()),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuTile(
            context,
            icon: Icons.settings_outlined,
            title: '설정',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
          const Divider(height: 1),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildMenuTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minVerticalPadding: 12,
    );
  }
}
