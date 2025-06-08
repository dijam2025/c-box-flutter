import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/post_detail_page.dart';

class PostCard extends StatefulWidget {
  final String category;
  final String title;
  final int comments;
  final DateTime createdAt;
  final String author;
  final String content;
  final List<Map<String, dynamic>> commentsList;
  final void Function(int)? onCommentChanged;

  const PostCard({
    super.key,
    required this.category,
    required this.title,
    required this.comments,
    required this.createdAt,
    required this.author,
    required this.content,
    required this.commentsList,
    this.onCommentChanged,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String userName = '로딩 중...';

  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    commentCount = widget.comments; // 처음에는 받은 값으로 초기화
  }

  void updateCommentCount(int newCount) {
    setState(() {
      commentCount = newCount;
    });
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? '이름 없음';
    });
  }

  String timeAgo(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays == 1) return '어제';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}주 전';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}달 전';
    return '${(diff.inDays / 365).floor()}년 전';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.category,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('${widget.author}  ${timeAgo(widget.createdAt)}'),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('댓글 $commentCount'),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,  // 버튼 배경색
                  foregroundColor: Colors.white,   // 버튼 텍스트 색
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailPage(
                        title: widget.title,
                        category: widget.category,
                        author: widget.author, // SharedPreferences에서 불러온 이름!
                        content: widget.content,
                        commentsList: widget.commentsList,
                        onCommentAdded: widget.onCommentChanged, // 댓글 수 전달!
                      ),
                    ),
                  );
                },
                child: const Text('상세 보기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}