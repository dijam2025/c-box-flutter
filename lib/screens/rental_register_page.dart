import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

            // ✅ 등록 버튼
            ElevatedButton(
              onPressed: () {
                // ✅ 입력값 확인
                final itemName = _itemController.text.trim();
                final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

                if (itemName.isEmpty || quantity <= 0 || selectedCollege == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('모든 항목을 정확히 입력하세요.')),
                  );
                  return;
                }

                // ✅ 등록할 데이터 생성 (itemId는 현재 시간을 고유값으로 사용)
                final newItem = {
                  'itemId': DateTime.now().millisecondsSinceEpoch,
                  'item': itemName,
                  'college': selectedCollege,
                  'quantity': quantity,
                };

                // ✅ RentalPage로 데이터 전달 후 돌아감
                Navigator.pop(context, newItem);
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