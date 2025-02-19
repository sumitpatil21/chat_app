import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/firebase_cloud_service.dart';
import 'package:chat_app/services/storage_services.dart';
import 'package:chat_app/modal/chat_modal.dart';
import 'package:chat_app/view/screen/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(chatController.receiverName.value)),
        actions: const [
          Icon(Icons.call),
          SizedBox(width: 20),
          Icon(Icons.video_call_outlined, size: 30),
          SizedBox(width: 15),
          Icon(Icons.more_vert_outlined)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseCloudService.firebaseCloudService
                  .readChatFromFireStore(chatController.receiverEmail.value),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List data = snapshot.data!.docs;
                List<ChatModal> chatList =
                data.map((snap) => ChatModal.fromMap(snap.data())).toList();

                FirebaseCloudService.firebaseCloudService
                    .markMessagesSeen(chatController.receiverEmail.value);
                _scrollToBottom();

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    final chat = chatList[index];
                    bool isMe = chat.sender ==
                        AuthServices.authServices.getCurrentUser()!.email;
                    return Align(
                      alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[300] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          chat.message.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          messageField(context),
        ],
      ),
    );
  }

  Widget messageField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatController.txtMessage,
              decoration: InputDecoration(
                hintText: "Message",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              String message = chatController.txtMessage.text.trim();
              if (message.isNotEmpty) {
                ChatModal chat = ChatModal(
                  sender: AuthServices.authServices.getCurrentUser()!.email,
                  receiver: chatController.receiverEmail.value,
                  message: message,
                  time: Timestamp.now(), image: '',
                );
                await FirebaseCloudService.firebaseCloudService
                    .addChatInFireStore(chat);
                chatController.txtMessage.clear();
                _scrollToBottom();
              }
            },
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
