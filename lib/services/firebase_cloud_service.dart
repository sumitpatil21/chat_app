import 'dart:developer';

import 'package:chat_app/modal/chat_modal.dart';
import 'package:chat_app/modal/user_modal.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../view/screen/home_page.dart';


class FirebaseCloudService
{
  static FirebaseCloudService firebaseCloudService =FirebaseCloudService._();
  FirebaseCloudService._();

  FirebaseFirestore firestore =  FirebaseFirestore.instance;

  Future<void> insertUserIntoFireStore(UserModal usersModal)
  async {
    await firestore.collection("user").doc(usersModal.email).set({
      'email' : usersModal.email,
      'name' : usersModal.name,
      'image' : usersModal.image,
      'token' : usersModal.token,
      'isOnline' : false,
      'isTyping' : false,
      'timestamp': Timestamp.now(),
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> readCurrentUserFromFireStore()
  async {
    User? user = AuthServices.authServices.getCurrentUser();
    return await firestore.collection("user").doc(user!.email).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> readDataFromFireStore()
  async {
    User? user = AuthServices.authServices.getCurrentUser();
    return await firestore.collection("user").where("email",isNotEqualTo: user!.email).get();
  }

  Future<void> addChatInFireStore(ChatModal chat)
  async {
    String? sender = chat.sender;
    String? receiver = chat.receiver;
    List doc = [sender,receiver];
    doc.sort();
    String docId = doc.join("_");
    DocumentReference docRef = await firestore.collection("chatroom").doc(docId).collection("chat").add(chat.toMap(chat));

    await docRef.update({'isSent' : true});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readChatFromFireStore(String receiver)
  {
    String sender = AuthServices.authServices.getCurrentUser()!.email!;
    List doc = [sender,receiver];
    doc.sort();
    String docId = doc.join("_");
    
    return firestore.collection("chatroom").doc(docId).collection("chat").orderBy("time" , descending: false).snapshots();
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return true; // Internet is available
    } else {
      return false; // No internet
    }
  }

  Future<void> markMessagesSeen(String receiverEmail)
  async {
    String senderEmail = AuthServices.authServices.getCurrentUser()!.email!;
    List doc = [senderEmail, receiverEmail];
    doc.sort();
    String docId = doc.join("_");

    QuerySnapshot<Map<String, dynamic>> unreadMessages = await firestore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .where("isSeen", isEqualTo: false)
        .get();

    for (var message in unreadMessages.docs) {
      if (message['receiver'] == senderEmail) {
        await message.reference.update({'isSeen': true});
      }
    }
  }

  Future<void> toggleOnlineStatus(
      bool status, Timestamp timestamp, bool isTyping) async {
    String email = AuthServices.authServices.getCurrentUser()!.email!;
    await firestore.collection("user").doc(email).update({
      'isOnline': status,
      'timestamp': timestamp,
      'isTyping': isTyping,
    });
    log(status.toString());
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> checkUserIsOnlineOrNot(
      String email) {
    return firestore.collection("user").doc(email).snapshots();
  }

  Future<void> updateMessageInFireStore(
      String documentId, String receiver, String message) async {
    String sender = AuthServices.authServices.getCurrentUser()!.email!;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await firestore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(documentId)
        .update({
      'message': message,
    });
  }
  Future<void> deleteMessageFromFireStore(
      String documentId, String receiver) async {
    String sender = AuthServices.authServices.getCurrentUser()!.email!;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    // chatController.appBar.value = false;
    await firestore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(documentId)
        .delete();
  }

  Future<void> updateUserImage(String email, String newImageUrl) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(email) // Use email or user ID to find the document
        .update({'image': newImageUrl});
  }
}
