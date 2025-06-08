import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _userIdController = TextEditingController();
  final _pwController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  Future<void> _signup() async {
    final url = Uri.parse('http://172.30.1.12:8080/users/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': _userIdController.text,
        'password': _pwController.text,
        'name': _nameController.text,
        'phoneNumber': _phoneController.text,
        'email': _emailController.text,
        'role': 'USER',
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      // ✅ 성공 메시지 띄우고 로그인 페이지로 이동
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("회원가입 성공")),
        );
        Navigator.pop(context); // 로그인 페이지로 돌아가기
      }
    } else {
      // ❌ 실패 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("회원가입 실패")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _userIdController, decoration: const InputDecoration(labelText: "아이디")),
            TextField(controller: _pwController, decoration: const InputDecoration(labelText: "비밀번호"), obscureText: true),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "이름")),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "전화번호")),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "이메일")),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,  // 버튼 배경색
                  foregroundColor: Colors.white,   // 버튼 텍스트 색
                ),
                onPressed: _signup,
                child: const Text("회원가입")),
          ],
        ),
      ),
    );
  }
}
