import 'package:chat_app/services/firebase_cloud_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../modal/chat_modal.dart';

class ChatController extends GetxController
{
  RxString receiverEmail = "".obs;
  RxString receiverName = "".obs;
  RxBool appBar = false.obs;
  var txtMessage = TextEditingController();
  RxInt select = 0.obs;
  RxBool isEditing = false.obs;
  RxString messageIdToEdit = ''.obs;// to toggle the appbar
  String? docId, messageController;
  RxString image = "".obs;
  RxString userImage = "".obs;


  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   appBar.value= false;
  // }

  void getImage(String url)
  {
    image.value = url;
  }
  void userPicImage(String url)
  {
    userImage.value = url;
  }
  void getReceiver(String email, String name)
  {
    receiverEmail.value = email;
    receiverName.value = name;
  }

  void editAppBar()
  {
    appBar.value = true;
  }

  void selectIndex(int index)
  {
    select.value = index;
  }

  void showEditDeleteDialog(String messageId, String message,
      String receiverEmail, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete',
          ),
          content: const Text('Do you want to delete this message?'),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
              ),
              onPressed: () {
                appBar.value = false;
                // Delete the message from Firestore
                FirebaseCloudService.firebaseCloudService.deleteMessageFromFireStore(
                  messageId,
                  receiverEmail,
                );
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
}