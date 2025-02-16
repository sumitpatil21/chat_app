import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModal {
  String? sender, receiver, message,image;
  Timestamp time;
  bool isSeen;
  bool isSent;

  ChatModal(
      {required this.sender,
      required this.receiver,
      required this.message,
        required this.image,
      required this.time,
     this.isSeen = false,
     this.isSent = false});

  factory ChatModal.fromMap(Map m1) {
    return ChatModal(
        sender: m1['sender'],
        receiver: m1['receiver'],
        message: m1['message'],
        image: m1['image'],
        time: m1['time'],
      isSeen: m1['isSeen'] ?? false,
      isSent: m1['isSent'] ?? false
    );
  }

  Map<String, dynamic> toMap(ChatModal chat) {
    return {
      'sender': chat.sender,
      'receiver': chat.receiver,
      'message': chat.message,
      'image' : chat.image,
      'time': chat.time,
      'isSeen' : chat.isSeen,
      'isSent' : chat.isSent,
    };
  }
}
