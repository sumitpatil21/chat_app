import 'package:chat_app/controller/chat_controller.dart';
import 'package:chat_app/modal/user_modal.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/firebase_cloud_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FirebaseCloudService.firebaseCloudService.toggleOnlineStatus(true, Timestamp.now(), false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      FirebaseCloudService.firebaseCloudService.toggleOnlineStatus(false, Timestamp.now(), false);
    } else if (state == AppLifecycleState.resumed) {
      FirebaseCloudService.firebaseCloudService.toggleOnlineStatus(true, Timestamp.now(), false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: () {}),
          IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onSelected: (value) {
              if (value == "Settings") {
                Get.toNamed('/settigs');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "New group", child: Text("New group")),
              const PopupMenuItem(value: "New broadcast", child: Text("New broadcast")),
              const PopupMenuItem(value: "Linked devices", child: Text("Linked devices")),
              const PopupMenuItem(value: "Starred messages", child: Text("Starred messages")),
              const PopupMenuItem(value: "Settings", child: Text("Settings")),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseCloudService.firebaseCloudService.readDataFromFireStore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text(snapshot.error?.toString() ?? 'No data available'));
          }
          List<UserModal> userList =
          snapshot.data!.docs.map((doc) => UserModal.fromMap(doc.data() as Map<String, dynamic>)).toList();

          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  chatController.getReceiver(userList[index].email, userList[index].name);
                  Get.toNamed('/chat');
                },
                title: Text(userList[index].name, style: const TextStyle(fontSize: 18)),
                subtitle: Text(userList[index].email),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userList[index].image),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),
    );
  }
}
