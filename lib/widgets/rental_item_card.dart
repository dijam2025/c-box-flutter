import 'package:flutter/material.dart';
import '../screens/rental_page.dart'; // RentalItem 클래스 불러오기용

class RentalItemCard extends StatelessWidget {
  final RentalItem item;
  final void Function(RentalItem item) onRented;

  const RentalItemCard({
    super.key,
    required this.item,
    required this.onRented,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // 카드 내부 여백
        child: Row(
          children: [
            // ✅ 아이콘 영역
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.inventory_2, size: 32, color: Colors.indigo),
            ),
            const SizedBox(width: 16),

            // ✅ 텍스트 정보 영역
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item.college, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('남은 수량: ${item.quantity}', style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),

            // ✅ 버튼
            ElevatedButton(
              onPressed: item.quantity > 0 ? () => onRented(item) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo, // 🔵 파란 배경
                foregroundColor: Colors.white,  // ⚪ 흰 글씨
                disabledBackgroundColor: Colors.grey.shade300, // ❌ 수량 0일 때 회색
                disabledForegroundColor: Colors.black38,
              ),
              child: const Text('대여하기'),
            ),
          ],
        ),
      ),
    );
  }
}
