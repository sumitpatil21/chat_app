import 'dart:io';

import 'package:chat_app/modal/user_modal.dart';
import 'package:chat_app/services/firebase_cloud_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


import '../modal/chat_modal.dart';
import '../view/screen/home_page.dart';
import 'auth_services.dart';

class StorageServices {
  StorageServices._();

  static StorageServices services = StorageServices._();

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future uploadImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final reference = FirebaseStorage.instance.ref();
    final imageReference = reference.child("images/${image!.name}");
    await imageReference.putFile(File(image.path));
    String url = await imageReference.getDownloadURL();
    ChatModal chat = ChatModal(
      image: url,
      sender: AuthServices.authServices.getCurrentUser()!.email,
      receiver: chatController.receiverEmail.value,
      message: "",
      // You can leave this empty since it's an image
      time: Timestamp.now(),
    );
    await FirebaseCloudService.firebaseCloudService.addChatInFireStore(chat);
    chatController.getImage("");
  }

  Future<void> userPickImage(UserModal user) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final reference = firebaseStorage.ref();
      final imageReference = reference.child("userImage/${image.name}");
      await imageReference.putFile(File(image.path));
      String url = await imageReference.getDownloadURL();

      user.image = url;
      await FirebaseCloudService.firebaseCloudService.updateUserImage(user.email, url);
    }
  }
}