import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../widgets/comment_item.dart'; // 댓글 컴포넌트 import
import 'chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostDetailPage extends StatefulWidget {
  final String title;
  final String category;
  final String author;
  final String content;
  final List<Map<String, dynamic>> commentsList;
  final void Function(int)? onCommentAdded;

  const PostDetailPage({
    super.key,
    required this.title,
    required this.category,
    required this.author,
    required this.content,
    required this.commentsList,
    this.onCommentAdded,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  late List<Map<String, dynamic>> _comments;

  @override
  void initState() {
    super.initState();
    _comments = widget.commentsList.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
    timeago.setLocaleMessages('ko', timeago.KoMessages());
  }

  void _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '익명';

    setState(() {
      _comments.insert(0, {
        'username': username,
        'comment': text,
        'time': DateTime.now(),
      });
      _commentController.clear();
      widget.onCommentAdded?.call(_comments.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              widget.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 카테고리 + 작성자
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(widget.category),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 본문
            Text(
              widget.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // 이미지
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0), // 위아래 여백 40씩!
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/c_box.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // 댓글 입력창
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 작성하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addComment,
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 댓글 개수 표시
            Text(
              '댓글 ${_comments.length}개',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),

            // 댓글 리스트 보여주기
            ..._comments.map((comment) {
              final dynamic rawTime = comment['time'];

              final String formattedTime;
              if (rawTime is DateTime) {
                formattedTime = timeago.format(rawTime, locale: 'ko'); // 진짜 시간일 때만!
              } else if (rawTime is String) {
                formattedTime = rawTime; // 목데이터나 문자열이면 그대로 표시
              } else {
                formattedTime = '알 수 없음';
              }               // 🔥 아니면 그대로 사용!
              return CommentItem(
                username: comment['username'] ?? '',
                comment: comment['comment'] ?? '',
                time: formattedTime,
              );
            }).toList(),

            const SizedBox(height: 24),

            // 쪽지 보내기 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(username: widget.author),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  '쪽지 보내기',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}