import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RentalRegisterPage extends StatefulWidget {
  const RentalRegisterPage({super.key});

  @override
  State<RentalRegisterPage> createState() => _RentalRegisterPageState();
}

class _RentalRegisterPageState extends State<RentalRegisterPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final List<String> colleges = [
    '경상대학', '공과대학', '사회과학대학', '문과대학',
    '생명·나노과학대학', '스마트융합대학', '아트&디자인테크놀로지대학',
    '사범대학', 'LGS대학'
  ];

  String? selectedCollege;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('물품 등록'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ✅ 단과대학 선택 Dropdown
            DropdownButtonFormField<String>(
              value: selectedCollege,
              hint: const Text('단과대학 선택'),
              items: colleges.map((college) {
                return DropdownMenuItem<String>(
                  value: college,
                  child: Text(college),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCollege = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // ✅ 물품 이름 입력
            TextField(
              controller: _itemController,
              decoration: const InputDecoration(
                labelText: '물품 이름',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // ✅ 수량 입력
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '수량',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // ✅ 등록 버튼 (관리자만 가능)
            ElevatedButton(
              onPressed: () async {
                // ✅ SharedPreferences에서 관리자 권한(role) 확인
                final prefs = await SharedPreferences.getInstance();
                final role = prefs.getString('role');

                // ✅ 관리자(role == 'ADMIN')가 아닐 경우 등록 차단
                if (role != 'ADMIN') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("관리자만 등록할 수 있습니다.")),
                  );
                  return;
                }

                // ✅ 입력값 검사 (물품명, 수량, 단과대)
                final itemName = _itemController.text.trim();
                final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

                if (itemName.isEmpty || quantity <= 0 || selectedCollege == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('모든 항목을 정확히 입력하세요.')),
                  );
                  return;
                }

                // ✅ 사용자 ID 가져오기 (백엔드 전송용)
                final userId = prefs.getString('userId');

                // ✅ 백엔드로 POST 요청
                final url = Uri.parse('http://172.30.1.58:8080/rental/rent'); // 실제 주소로 수정
                final body = jsonEncode({
                  'item': itemName,
                  'college': selectedCollege,
                  'quantity': quantity,
                  'userId': userId,
                });

                final response = await http.post(
                  url,
                  headers: {'Content-Type': 'application/json'},
                  body: body,
                );

                // ✅ 응답 처리
                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('물품이 등록되었습니다.')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('등록 실패. 다시 시도해주세요.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('등록하기', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}