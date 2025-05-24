import 'package:flutter/material.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 예시 개발자 리스트
    final developers = const [
      {'name': '이화진', 'role': '프론트엔드 개발'},
      {'name': '서유미', 'role': '프론트엔드 개발'},
      {'name': '장준태', 'role': '백엔드 개발'},
      {'name': '이영흔', 'role': '백엔드 개발'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('개발진'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        itemCount: developers.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          final dev = developers[index];
          return ListTile(
            leading: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(dev['name']!),
            subtitle: Text(dev['role']!),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          );
        },
      ),
    );
  }
}
