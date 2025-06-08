import 'package:flutter/material.dart';
import '../widgets/message_item.dart';
import '../widgets/custom_app_bar_title.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/search_bar.dart';
import 'chat_page.dart';

class MessageListPage extends StatefulWidget {
  const MessageListPage({super.key});

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  // 샘플 데이터
  final List<Map<String, String>> _allMessages = [
    {
      'username': 'A',
      'snippet': '안녕하세요',
      'time': '오전 9:24',
    },
    {
      'username': '유저2',
      'snippet': '쪽지 보냈습니다.',
      'time': '어제',
    },
    {
      'username': '유저3',
      'snippet': '안녕하세요! 내일 오후 3시쯤 가능하실까요?',
      'time': '2024.4.23',
    },
    {
      'username': '유저4',
      'snippet': '2024.4.22',
      'time': '50분 전',
    },
  ];

  List<Map<String, String>> _filteredMessages = [];

  @override
  void initState() {
    super.initState();
    _filteredMessages = _allMessages;
  }

  void _showAddDialog() {
    String newUsername = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("새 대화 시작"),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(labelText: "상대 이름 입력"),
          onChanged: (value) => newUsername = value,
        ),
        actions: [
          TextButton(
            child: const Text("취소"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text("추가"),
            onPressed: () {
              if (newUsername.trim().isNotEmpty) {
                _addNewChat(newUsername.trim());
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _addNewChat(String username) {
    final newChat = {
      'username': username,
      'snippet': '새로운 대화를 시작해보세요!',
      'time': '방금',
    };
    setState(() {
      _allMessages.insert(0, newChat);
      _filteredMessages = _allMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchBar<Map<String, String>>(
                    allItems: _allMessages,
                    onFiltered: (results) {
                      setState(() {
                        _filteredMessages = results;
                      });
                    },
                    filter: (item, query) {
                      final username = item['username']?.toLowerCase() ?? '';
                      final snippet = item['snippet']?.toLowerCase() ?? '';
                      final search = query.toLowerCase();
                      return username.contains(search) ||
                          snippet.contains(search);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showAddDialog,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredMessages.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final msg = _filteredMessages[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(username: msg['username']!),
                      ),
                    );
                  },
                  child: MessageItem(
                    username: msg['username']!,
                    snippet: msg['snippet']!,
                    time: msg['time']!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}