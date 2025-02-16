import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal {
  late String name, image, email, token;
  late bool isOnline,isTyping;
  late Timestamp timestamp;

  UserModal(
      {required this.name,
      required this.image,
      required this.email,
      required this.token,
      required this.isOnline,
      required this.isTyping,
      required this.timestamp});

  factory UserModal.fromMap(Map m1) {
    return UserModal(
        name: m1['name'],
        image: m1['image'],
        email: m1['email'],
        token: m1['token'],
      isOnline: m1['isOnline'] ?? false,
      isTyping: m1['isTyping'] ?? false,
      timestamp: m1['timestamp']
    );
  }

  Map<String, dynamic> toMap(UserModal user) {
    return {
      'name': user.name,
      'image': user.image,
      'email': user.email,
      'token': user.token,
    };
  }
}
