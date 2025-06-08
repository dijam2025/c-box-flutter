import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/comment_checkbox.dart';

class PostCreatePage extends StatefulWidget {
  const PostCreatePage({super.key});

  @override
  State<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedCategory;
  bool _allowComments = true;

  final List<String> _categories = ['전체', '요청', '수업', '기타'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 글 작성'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 입력
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 내용 입력
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '내용',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // ✅ 분리된 카테고리 드롭다운 사용!
            CategoryDropdown(
              selected: _selectedCategory,
              categories: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 16),

            //체크박스
            CommentCheckbox(
              value: _allowComments,
              onChanged: (value) {
                setState(() {
                  _allowComments = value ?? true;
                });
              },
            ),

            const Spacer(),

            // 올리기 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_titleController.text.isEmpty ||
                      _contentController.text.isEmpty ||
                      _selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('제목, 내용, 카테고리를 모두 입력하세요!')),
                    );
                  } else {
                    final prefs = await SharedPreferences.getInstance();
                    final author = prefs.getString('username') ?? '익명';

                    final newPost = {
                      'title': _titleController.text,
                      'content': _contentController.text,
                      'category': _selectedCategory!,
                      'createdAt': DateTime.now().toIso8601String(),
                      'allowComments': _allowComments,
                      'comments': 0,
                      'author': author, // ✅ 작성자 추가!!
                    };

                    Navigator.pop(context, newPost); // 🎉 글 정보를 함께 전달!
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  '올리기',
                    style: const TextStyle(fontSize: 16, color: Colors.white)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
