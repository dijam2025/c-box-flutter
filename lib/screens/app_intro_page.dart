import 'package:flutter/material.dart';

class AppIntroPage extends StatelessWidget {
  const AppIntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('앱 소개'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black),
              children: [
                TextSpan(
                  text:
                  '대학 캠퍼스 내에서는 학습에 필요한 물품이나, 갑작스럽게 필요한 우산 등 다양한 생활 용품이 필요한 순간이 빈번하게 발생합니다. '
                      '그러나 현재 이러한 공유 시스템은 체계적으로 정비되어 있지 않거나, 학생들이 존재 자체를 인지하지 못해 효율성과 접근성이 떨어지고 있습니다.\n\n',
                ),
                TextSpan(
                  text: '이에 따라 C:BOX (Campus Box)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                  '는 캠퍼스 내 필요한 물품을 누구나 쉽고 자유롭게 대여·반납할 수 있는 공유 플랫폼으로 개발되고자 합니다.\n\n'
                      '또한 단순 대여 시스템을 넘어, 학생들이 자발적으로 활동을 기획하고 참여할 수 있는 ‘미션 스쿨(Mission School)’ 기능을 추가하여, 커뮤니티 기반의 활발한 활동을 유도합니다.\n\n'
                      '(예시: "공대 3층 화장실에 휴지를 가져다주시면 500원을 드립니다", "충전기를 빌려주시면 1000원을 드립니다" 등 실생활에 밀접한 미션 수행)\n\n'
                      '본 과제는 QR코드, 실시간 위치 정보, 미션 기반 커뮤니티 기능을 통합하여, 보다 직관적이고 사용자 친화적인 통합 플랫폼 구축을 목표로 합니다.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
