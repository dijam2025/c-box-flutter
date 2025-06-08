import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'app_intro_page.dart';
import 'developer_page.dart';
import 'contact_page.dart';
import '../widgets/custom_app_bar_title.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildTile(
            context,
            icon: Icons.info_outline,
            title: '앱 소개',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppIntroPage()),
              );
            },
          ),
          const Divider(height: 1),
          _buildTile(
            context,
            icon: Icons.verified,
            title: '앱 버전',
            trailing: const Text('v1.0'),
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildTile(
            context,
            icon: Icons.announcement_outlined,
            title: '개발진',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeveloperPage()),
              );
            },
          ),
          const Divider(height: 1),
          _buildTile(
            context,
            icon: Icons.code,
            title: 'GitHub 링크',
            trailing: const Text('https://github.com/dijam2025'),
            onTap: () async {
              final uri = Uri.parse('https://github.com/dijam2025');
              if (!await launchUrl(
                uri,
                mode: LaunchMode.externalApplication, // 외부 브라우저로 열기
              )) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('링크를 열 수 없습니다.')),
                );
              }
            },
          ),
          const Divider(height: 1),
          _buildTile(
            context,
            icon: Icons.feedback_outlined,
            title: '피드백(문의하기)',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactPage()),
              );
            },
          ),
          _buildTile(
            context,
            icon: Icons.logout,
            title: '로그아웃',
            onTap: () async {
              final response = await http.put(
                Uri.parse('http://172.31.128.73:8080/users/logout'),
              );

              if (response.statusCode == 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그아웃 성공')),
                );
                // 로그인 페이지로 이동 (필요시 수정)
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그아웃 실패')),
                );
              }
            },
          ),
          _buildTile(
            context,
            icon: Icons.delete_forever,
            title: '회원탈퇴',
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final userId = prefs.getString('userId');

              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('유저 정보가 없습니다. 다시 로그인해주세요.')),
                );
                return;
              }

              final response = await http.delete(
                Uri.parse('http://172.31.128.73:8080/users/delete/$userId'),
              );

              if (response.statusCode == 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('회원 탈퇴 성공')),
                );
                await prefs.clear(); // 저장된 유저 정보 초기화
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('회원 탈퇴 실패')),
                );
              }
            },
          ),

          const Divider(height: 1),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        Widget? trailing,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minVerticalPadding: 12,
    );
  }
}