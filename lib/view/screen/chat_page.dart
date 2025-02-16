import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/modal/chat_modal.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/firebase_cloud_service.dart';
import 'package:chat_app/services/storage_services.dart';
import 'package:chat_app/view/screen/home_page.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
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
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => chatController.appBar.value == true
              ? editAppBar(context)
              : noramlAppBar(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: h,
            width: w,
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   fit: BoxFit.cover,
              //   image: (themeController.isDarkMode == true)
              //       ? const AssetImage('assets/logo/dark chat_cleanup.jpg')
              //       : const AssetImage("assets/logo/light image'_cleanup.jpg"),
              // ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseCloudService.firebaseCloudService
                      .readChatFromFireStore(
                          chatController.receiverEmail.value),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    List data = snapshot.data!.docs;
                    List<ChatModal> chatList = [];
                    List<String> docIdList = [];
                    for (var snap in data) {
                      docIdList.add(snap.id);
                      chatList.add(ChatModal.fromMap(snap.data()));
                    }

                    FirebaseCloudService.firebaseCloudService
                        .markMessagesSeen(chatController.receiverEmail.value);
                    _scrollToBottom();

                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          // ...List.generate(
                          //   chatList.length,
                          //   (index) {
                          //     ChatModal chat = chatList[index];
                          //     bool isSender = chat.sender ==
                          //         AuthServices.authServices
                          //             .getCurrentUser()!
                          //             .email;
                          //     bool showTail = true;
                          //
                          //     if (index > 0) {
                          //       if (chatList[index].sender ==
                          //           chatList[index - 1].sender) {
                          //         showTail = false;
                          //       }
                          //     }
                          //     // return BubbleSpecialOne(
                          //     //     onLongPress: () {
                          //     //       chatController.selectIndex(index);
                          //     //       // if (!selectedMessages.contains(chat)) {
                          //     //       //   selectedMessages.add(chat);
                          //     //       // } else {
                          //     //       //   selectedMessages.remove(chat);
                          //     //       // }
                          //     //       chatController.docId = docIdList[index];
                          //     //       chatController.messageController =
                          //     //           chatList[index].message;
                          //     //       // chatController.toggleBar.value = true;
                          //     //       chatController.editAppBar();
                          //     //       // print(chatController.appBar);
                          //     //     },
                          //     //     color: (chatList[index].sender! ==
                          //     //             AuthServices.authServices
                          //     //                 .getCurrentUser()!
                          //     //                 .email)
                          //     //         ? Theme.of(context)
                          //     //             .colorScheme
                          //     //             .surface
                          //     //         : Theme.of(context)
                          //     //             .colorScheme
                          //     //             .tertiary,
                          //     //     time: DateFormat('h:mm a').format(
                          //     //         chatList[index]
                          //     //             .time
                          //     //             .toDate()
                          //     //             .toLocal()),
                          //     //     textStyle: TextStyle(
                          //     //       color: (chatList[index].sender! ==
                          //     //               AuthServices.authServices
                          //     //                   .getCurrentUser()!
                          //     //                   .email)
                          //     //           ? Theme.of(context)
                          //     //               .colorScheme
                          //     //               .onSurface
                          //     //           : Theme.of(context)
                          //     //               .colorScheme
                          //     //               .onTertiary,
                          //     //     ),
                          //     //     tail: showTail,
                          //     //     isSender: chatList[index].sender ==
                          //     //         AuthServices.authServices
                          //     //             .getCurrentUser()!
                          //     //             .email,
                          //     //     seen: (isSender) ? chat.isSeen : false,
                          //     //     sent: (isSender) ? chat.isSent : false,
                          //     //     text: '',
                          //     //
                          //     //     child: (chatList[index].image == "" &&
                          //     //             chatList[index].image!.isEmpty)
                          //     //         ? Text(chatList[index]
                          //     //             .message
                          //     //             .toString()
                          //     //             .trim())
                          //     //         : Container(
                          //     //       height: h*0.3,
                          //     //           width: w*0.4,
                          //     //           child: Image.network(
                          //     //             fit: BoxFit.cover,
                          //     //               chatList[index].image!),
                          //     //         ));
                          //   },
                          // ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              messageFeild(h, w, context),
            ],
          )
        ],
      ),
    );
  }

  AppBar noramlAppBar() {
    return AppBar(
        actions: [
          Icon(Icons.call),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.video_call_outlined,
            size: 30,
          ),
          SizedBox(
            width: 15,
          ),
          Icon(Icons.more_vert_outlined)
        ],
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatController.receiverName.value,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: (themeController.isDarkMode.value == true)
                      ? Colors.white
                      : Colors.black),
            ),
            SizedBox(
              height: 2,
            ),
            StreamBuilder(
              stream: FirebaseCloudService.firebaseCloudService
                  .checkUserIsOnlineOrNot(chatController.receiverEmail.value),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('');
                }

                Map? user = snapshot.data!.data();
                String day = "";

                if (user!['timestamp'].toDate().hour > 11) {
                  day = 'PM';
                } else {
                  day = 'AM';
                }
                return Text(
                  user['isOnline']
                      ? (user['isTyping'])
                          ? 'Typing...'
                          : 'Online'
                      : _getLastSeenText(user['timestamp']),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: (themeController.isDarkMode.value == true)
                          ? Colors.white
                          : Colors.black54
                      //(user[isOnline] ? blue : )
                      ),
                );
              },
            )
          ],
        ));
  }

  AppBar editAppBar(BuildContext context) {
    return AppBar(
      // title: (selectedMessages.isNotEmpty &&
      //     chatController.select.value < selectedMessages.length)
      //     ? Text(
      //     selectedMessages[chatController.select.value].message.toString())
      //     : Text("${selectedMessages.length}"),
      leading: GestureDetector(
          onTap: () {
            // selectedMessages.clear();
            chatController.appBar.value = false;
          },
          child: Icon(Icons.arrow_back)),
      actions: [
        Icon(Icons.copy),
        SizedBox(
          width: 30,
        ),
        GestureDetector(
            onTap: () {
              chatController.txtMessage.text =
                  chatController.messageController!;
              chatController.isEditing.value = true;
              chatController.messageIdToEdit.value = chatController.docId!;
              chatController.appBar.value = false;
            },
            child: Icon(Icons.edit)),
        SizedBox(
          width: 30,
        ),
        GestureDetector(
            onTap: () {
              chatController.showEditDeleteDialog(
                chatController.docId!,
                chatController.messageController!,
                chatController.receiverEmail.value,
                context,
              );
            },
            child: Icon(Icons.delete)),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }

  // Padding messageFeild(double h, double w, BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 8.0, right: 5, left: 5),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: SizedBox(
  //             height: h * 0.07,
  //             width: w,
  //             child: Container(
  //               padding: const EdgeInsets.all(8.0),
  //               decoration: BoxDecoration(
  //                 color: Theme.of(context).colorScheme.secondary,
  //                 borderRadius: BorderRadius.circular(30),
  //                 boxShadow: const [
  //                   BoxShadow(
  //                     color: Colors.black26,
  //                     blurRadius: 6,
  //                     spreadRadius: 1,
  //                     offset: Offset(0, 3),
  //                   ),
  //                 ],
  //               ),
  //               alignment: Alignment.center,
  //               child: TextField(
  //                 style: TextStyle(
  //                     color: (themeController.isDarkMode == true)
  //                         ? Colors.white
  //                         : Colors.black),
  //                 controller: chatController.txtMessage,
  //                 onChanged: (value) {
  //                   chatController.update();
  //                   FirebaseCloudService.firebaseCloudService
  //                       .toggleOnlineStatus(
  //                     true,
  //                     Timestamp.now(),
  //                     true,
  //                   );
  //                 },
  //                 onTapOutside: (event) {
  //                   FirebaseCloudService.firebaseCloudService
  //                       .toggleOnlineStatus(
  //                     true,
  //                     Timestamp.now(),
  //                     false,
  //                   );
  //                 },
  //                 decoration: InputDecoration(
  //                   prefixIcon: Icon(
  //                     Icons.emoji_emotions_outlined,
  //                     color: Theme.of(context).colorScheme.onSecondary,
  //                   ),
  //                   suffixIcon: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Icon(
  //                         Icons.attach_file,
  //                         color: Theme.of(context).colorScheme.onSecondary,
  //                       ),
  //                       SizedBox(
  //                         width: w * 0.03,
  //                       ),
  //                       Icon(
  //                         Icons.currency_rupee,
  //                         color: Theme.of(context).colorScheme.onSecondary,
  //                       ),
  //                       SizedBox(
  //                         width: w * 0.03,
  //                       ),
  //                       GestureDetector(
  //                         onTap: () async {
  //                           String url =
  //                               await StorageServices.services.uploadImage();
  //                           chatController.getImage(url);
  //                         },
  //                         child: Icon(
  //                           Icons.camera_alt_outlined,
  //                           color: Theme.of(context).colorScheme.onSecondary,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         width: w * 0.03,
  //                       ),
  //                     ],
  //                   ),
  //                   hintText: "Message",
  //                   hintStyle: TextStyle(
  //                       color: Theme.of(context).colorScheme.onSecondary),
  //                   border: InputBorder.none,
  //                   contentPadding: EdgeInsets.symmetric(vertical: 10),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         GetBuilder<ChatController>(
  //           builder: (controller) => GestureDetector(
  //             onTap: (chatController.txtMessage.text.isNotEmpty)
  //                 ? () async {
  //                     String message = chatController.txtMessage.text.trim();
  //                     if (message.isNotEmpty) {
  //                       if (chatController.isEditing.value) {
  //                         FirebaseCloudService.firebaseCloudService
  //                             .updateMessageInFireStore(
  //                                 chatController.messageIdToEdit.value,
  //                                 chatController.receiverEmail.value,
  //                                 message);
  //                         chatController.txtMessage.clear();
  //                         chatController.messageIdToEdit.value = '';
  //                         chatController.isEditing.value = false;
  //                         _scrollToBottom();
  //                       } else {
  //                         ChatModal chat = ChatModal(
  //                           image: chatController.image.value,
  //                           sender: AuthServices.authServices
  //                               .getCurrentUser()!
  //                               .email,
  //                           receiver: chatController.receiverEmail.value,
  //                           message: chatController.txtMessage.text,
  //                           time: Timestamp.now(),
  //                         );
  //                         await FirebaseCloudService.firebaseCloudService
  //                             .addChatInFireStore(chat);
  //                         chatController.txtMessage.clear();
  //                         chatController.getImage("");
  //                       }
  //                       await FirebaseCloudService.firebaseCloudService
  //                           .toggleOnlineStatus(
  //                         true,
  //                         Timestamp.now(),
  //                         false,
  //                       );
  //                     }
  //                     _scrollToBottom(); // Scroll to the bottom after sending a message
  //                   }
  //                 : () {},
  //             child: CircleAvatar(
  //                 key: ValueKey(chatController.txtMessage.text.isNotEmpty),
  //                 maxRadius: h * 0.032,
  //                 child: AnimatedSwitcher(
  //                   duration: Duration(milliseconds: 300),
  //                   switchInCurve: Curves.easeInOut,
  //                   switchOutCurve: Curves.easeInOut,
  //                   transitionBuilder: (child, animation) {
  //                     return FadeTransition(
  //                       opacity: animation,
  //                       child: SlideTransition(
  //                         position: Tween<Offset>(
  //                           begin: const Offset(0, 0.2),
  //                           end: Offset.zero,
  //                         ).animate(animation),
  //                         child: child,
  //                       ),
  //                     );
  //                   },
  //                   child: Icon(
  //                     (chatController.txtMessage.text.isNotEmpty || chatController.image.value.isNotEmpty)
  //                         ? Icons.send
  //                         : Icons.mic,
  //                     key: ValueKey(chatController.txtMessage.text.isNotEmpty || chatController.image.value.isNotEmpty
  //                         ? Icons.send
  //                         : Icons.mic),
  //                   ),
  //                 )),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Padding messageFeild(double h, double w, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 5, left: 5),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: h * 0.07,
              width: w,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: TextField(
                  style: TextStyle(
                      color: (themeController.isDarkMode == true)
                          ? Colors.white
                          : Colors.black),
                  controller: chatController.txtMessage,
                  onChanged: (value) {
                    chatController.update();
                    FirebaseCloudService.firebaseCloudService
                        .toggleOnlineStatus(
                      true,
                      Timestamp.now(),
                      true,
                    );
                  },
                  onTapOutside: (event) {
                    FirebaseCloudService.firebaseCloudService
                        .toggleOnlineStatus(
                      true,
                      Timestamp.now(),
                      false,
                    );
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.attach_file,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        SizedBox(
                          width: w * 0.03,
                        ),
                        Icon(
                          Icons.currency_rupee,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        SizedBox(
                          width: w * 0.03,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await StorageServices.services.uploadImage();
                          },
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        SizedBox(
                          width: w * 0.03,
                        ),
                      ],
                    ),
                    hintText: "Message",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
          ),
          GetBuilder<ChatController>(
            builder: (controller) => GestureDetector(
              onTap: (chatController.txtMessage.text.isNotEmpty || chatController.image.value.isNotEmpty)
                  ? () async {
                String message = chatController.txtMessage.text.trim();
                if (message.isNotEmpty || chatController.image.value.isNotEmpty) {
                  if (chatController.isEditing.value) {
                    FirebaseCloudService.firebaseCloudService
                        .updateMessageInFireStore(
                        chatController.messageIdToEdit.value,
                        chatController.receiverEmail.value,
                        message);
                    chatController.txtMessage.clear();
                    chatController.messageIdToEdit.value = '';
                    chatController.isEditing.value = false;
                    _scrollToBottom();
                  } else {
                    ChatModal chat = ChatModal(
                      image: chatController.image.value,
                      sender: AuthServices.authServices
                          .getCurrentUser()!
                          .email,
                      receiver: chatController.receiverEmail.value,
                      message: chatController.txtMessage.text,
                      time: Timestamp.now(),
                    );
                    await FirebaseCloudService.firebaseCloudService
                        .addChatInFireStore(chat);
                    chatController.txtMessage.clear();
                    // chatController.getImage("");
                  }
                  await FirebaseCloudService.firebaseCloudService
                      .toggleOnlineStatus(
                    true,
                    Timestamp.now(),
                    false,
                  );
                }
                _scrollToBottom(); // Scroll to the bottom after sending a message
              }
                  : () {},
              child: CircleAvatar(
                  key: ValueKey(chatController.txtMessage.text.isNotEmpty || chatController.image.value.isNotEmpty),
                  maxRadius: h * 0.032,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Icon(
                      (chatController.txtMessage.text.isNotEmpty || chatController.image.value.isNotEmpty)
                          ? Icons.send
                          : Icons.mic,
                      key: ValueKey(chatController.txtMessage.text.isNotEmpty || chatController.image.value.isNotEmpty
                          ? Icons.send
                          : Icons.mic),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }


  String _getLastSeenText(Timestamp timestamp) {
    DateTime now = DateTime.now();
    DateTime lastSeen = timestamp.toDate();

    Duration difference = now.difference(lastSeen);

    if (difference.inDays == 0) {
      // Same day, show time
      return 'Last seen at ${DateFormat('h:mm a').format(lastSeen)}';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Last seen yesterday at ${DateFormat('h:mm a').format(lastSeen)}';
    } else {
      // More than 1 day ago, show date
      return 'Last seen on ${DateFormat('MMM d, h:mm a').format(lastSeen)}';
    }
  }
}

// RxList<ChatModal> selectedMessages = <ChatModal>[].obs;
