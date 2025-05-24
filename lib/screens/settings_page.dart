import 'package:flutter/material.dart';
import 'app_intro_page.dart';
import 'developer_page.dart';
import 'contact_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
            onTap: () {
              // TODO: 외부 브라우저 오픈
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
          const Divider(height: 1),
          _buildTile(
            context,
            icon: Icons.logout,
            title: '로그아웃',
            onTap: () {
              // TODO: 로그아웃 처리
            },
          ),
          const Divider(height: 1),
          _buildTile(
            context,
            icon: Icons.delete_forever,
            title: '회원탈퇴',
            onTap: () {
              // TODO: 회원탈퇴 처리
            },
          ),
          const Divider(height: 1),
        ],
      ),
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