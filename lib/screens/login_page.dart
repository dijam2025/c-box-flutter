import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();

  Future<void> _login() async {

    final url = Uri.parse('http://172.31.128.73:8080/users/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': _idController.text,
          'password': _pwController.text,
        }),
      );

      print("응답 상태 코드: ${response.statusCode}");
      print("응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final name = data['name'];
        final role = data['role'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', name);
        await prefs.setString('userId', _idController.text);
        await prefs.setString('role', role);

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? '로그인 성공')),
        );

        Navigator.pushReplacementNamed(context, '/home_menu_page');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그인 실패")),
        );
      }
    } catch (e) {
      print("에러 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("서버 오류 또는 네트워크 오류")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("로그인")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: "아이디"),
            ),
            TextField(
              controller: _pwController,
              decoration: const InputDecoration(labelText: "비밀번호"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                print("로그인 버튼 눌림!"); // ✅ 이거 추가
                _login();
              },
              child: const Text("로그인"),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text("회원가입"),
            )
          ],
        ),
      ),
    );
  }
}