import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    final url = Uri.parse('http://10.0.2.2:8080/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': _idController.text,
        'password': _pwController.text,
      }),
    );

    if (response.statusCode == 200) {
      // ✅ 로그인 성공 시 홈화면으로 이동
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그인 성공")),
        );
        Navigator.pushNamed(context, '/mission_home');
      }
    } else {
      // ❌ 로그인 실패 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("로그인 실패")),
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
            TextField(controller: _idController, decoration: const InputDecoration(labelText: "아이디")),
            TextField(controller: _pwController, decoration: const InputDecoration(labelText: "비밀번호"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text("로그인")),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text("회원가입 하러가기"),
            )
          ],
        ),
      ),
    );
  }
}
