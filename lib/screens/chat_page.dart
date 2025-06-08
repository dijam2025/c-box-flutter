import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:convert';

import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_field.dart';


class ChatPage extends StatefulWidget {
  final String username;

  const ChatPage({super.key, required this.username});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  late StompClient stompClient;

  @override
  void initState() {
    super.initState();

    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'http://172.30.1.58:8080/ws-chat',
        onConnect: onConnectCallback,
        onWebSocketError: (dynamic error) {
          print('WebSocket Error: $error');
        },
      ),
    );

    stompClient.activate();
  }

  void onConnectCallback(StompFrame frame) {
    stompClient.subscribe(
      destination: '/sub/chat/room/1',
      callback: (frame) {
        final message = jsonDecode(frame.body!);

        /*if(widget.username == "유저2"){
          return;
        }*/

        setState(() {
          messages.add({
            'text': message['content'],
            'time': '지금',
            'isMe': false,
          });
        });
      },
    );
  }

  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || !stompClient.connected) return;

    stompClient.send(
      destination: '/pub/chat/message',
      body: jsonEncode({
        'roomId': '1',                 // 채팅방 번호
        'sender': widget.username,     // 사용자 이름
        'content': text                // 입력한 메시지
      }),
    );

    setState(() {
      if(widget.username == "유저1") {
        messages.add({
          'text': text,
          'time': '지금',
          'isMe': true,
        });
      }
    });

    _controller.clear();
  }

  @override
  void dispose() {
    stompClient.deactivate();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 인사
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Text('C:BOX', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),

          // 메시지 목록
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ChatBubble(
                  text: msg['text'],
                  time: msg['time'],
                  isMe: msg['isMe'],
                );
              },
            ),
          ),

          // 입력창
          ChatInputField(
            controller: _controller,
            onSend: sendMessage,
          ),
        ],
      ),
    );
  }
}