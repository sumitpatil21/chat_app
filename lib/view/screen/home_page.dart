import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/modal/user_modal.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/firebase_cloud_service.dart';
import 'package:chat_app/services/goggle_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

var chatController = Get.put(ChatController());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FirebaseCloudService.firebaseCloudService
        .toggleOnlineStatus(true, Timestamp.now(), false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      FirebaseCloudService.firebaseCloudService.toggleOnlineStatus(
        false,
        Timestamp.now(),
        false,
      );
    } else if (state == AppLifecycleState.resumed) {
      FirebaseCloudService.firebaseCloudService.toggleOnlineStatus(
        true,
        Timestamp.now(),
        false,
      );
    } else if (state == AppLifecycleState.inactive) {
      FirebaseCloudService.firebaseCloudService.toggleOnlineStatus(
        false,
        Timestamp.now(),
        false,
      );
    } else if (state == AppLifecycleState.hidden) {
      FirebaseCloudService.firebaseCloudService.toggleOnlineStatus(
        false,
        Timestamp.now(),
        false,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Home page'),
        actions: [
          Icon(Icons.qr_code_scanner),
          SizedBox(width: 20,),
          Icon(Icons.camera_alt_outlined),
          PopupMenuButton<String>(
            // color: Color(0xff121B22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onSelected: (value) {
              if (value == "Settings") {
                Get.toNamed('/settigs');
              }
              print("Selected option: $value");
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: "New group",
                  child: Text(
                    "New group",
                  ),
                ),
                const PopupMenuItem(
                  value: "New broadcast",
                  child: Text("New broadcast"),
                ),
                const PopupMenuItem(
                  value: "Linked devices",
                  child: Text("Linked devices"),
                ),
                const PopupMenuItem(
                  value: "Starred messages",
                  child: Text("Starred messages"),
                ),
                const PopupMenuItem(
                  value: "Settings",
                  child: Text("Settings"),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            FirebaseCloudService.firebaseCloudService.readDataFromFireStore(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List data = snapshot.data!.docs;
          List<UserModal> userList = [];
          for (QueryDocumentSnapshot user in data) {
            userList.add(UserModal.fromMap(user.data() as Map));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
                child: Container(
                    height: h * 0.068,
                    width: w,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            height: h * 0.1,
                            width: w * 0.1,
                            decoration: BoxDecoration(
                                // image: DecorationImage(
                                //     fit: BoxFit.cover,
                                //     image: AssetImage(
                                //         'assets/logo/meta-removebg-preview.png'),
                                // ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: w * 0.03,
                        ),
                        Text(
                          'Ask Meta Ai or Search',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: h * 0.03,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        chatController.getReceiver(
                            userList[index].email, userList[index].name);
                        Get.toNamed('/chat');
                      },
                      title: Text(
                        userList[index].name,
                        style: TextStyle(
                          fontSize: w * 0.05,
                        ),
                      ),
                      subtitle: Text(
                        userList[index].email,
                      ),
                      leading: CircleAvatar(
                        maxRadius: w * 0.08,
                        backgroundImage: NetworkImage(userList[index].image),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {},
        child: Icon(Icons.chat),
      ),
    );
  }
}
