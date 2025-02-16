import 'package:chat_app/modal/user_modal.dart';
import 'package:chat_app/services/firebase_cloud_service.dart';
import 'package:chat_app/services/storage_services.dart';
import 'package:chat_app/view/screen/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../main.dart';
import '../../services/auth_services.dart';
import '../../services/goggle_services.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: FutureBuilder(
        future: FirebaseCloudService.firebaseCloudService
            .readCurrentUserFromFireStore(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Ensure snapshot.data is not null and has data
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data found.'));
          }

          // Extract data safely
          Map? data = snapshot.data!.data();
          if (data == null) {
            return Center(child: Text('User data is null.'));
          }

          // Create UserModal safely
          UserModal userModal = UserModal.fromMap(data);

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        maxRadius: 33,
                        backgroundImage: NetworkImage(userModal.image),
                      ),
                      SizedBox(width: 10),
                      Text(
                        userModal.name ?? 'Unnamed', // Handle null name
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 40,),
                      IconButton(
                        onPressed: () async {
                          await StorageServices.services.userPickImage(
                              userModal);
                        },
                        icon: Icon(Icons.photo),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white, indent: 5, endIndent: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15),
                  child: Row(
                    children: [
                      Obx(() => (themeController.isDarkMode.value) ? Icon(
                        Icons.dark_mode, color: Colors.white,) : Icon(
                        Icons.light_mode, color: Colors.yellow,),),
                      SizedBox(width: 20,),
                      Obx(() =>
                      (themeController.isDarkMode.value) ? Text(
                        'Dark Mode', style: TextStyle(fontSize: 20),) : Text(
                        'Light Mode', style: TextStyle(fontSize: 20),),),
                      Spacer(),
                      Obx(
                            () =>
                            Switch(
                              value: themeController.isDarkMode.value,
                              onChanged: (value) {
                                themeController.themeMode();
                              },
                            ),
                      ),
                    ],
                  ),
                ),
                settingListTile(icon: Icons.key,
                    title: 'Account',
                    subTitle: 'security notification, changes number'),
                settingListTile(icon: Icons.lock_outline_rounded,
                    title: 'Privacy',
                    subTitle: 'Block contacts, disappearing message'),
                settingListTile(icon: Icons.photo,
                    title: 'Avatar',
                    subTitle: 'Create, edit, profile, photo'),
                settingListTile(icon: Icons.favorite_border,
                    title: 'Favourite',
                    subTitle: 'Add, recorder, remover'),
                settingListTile(icon: Icons.chat,
                    title: 'Chats',
                    subTitle: 'Theme, wallpaper, chat history'),
                settingListTile(icon: Icons.notifications_none,
                    title: 'Notification',
                    subTitle: 'Message, groups & call Tones'),
                settingListTile(icon: Icons.language,
                    title: 'App Language',
                    subTitle: "English (device's  language"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                  child: GestureDetector(
                    onTap: () async {
                      await AuthServices.authServices.signOut();
                      GoggleService.goggleService.googleSignOut();
                      User? user = AuthServices.authServices.getCurrentUser();

                      if (user == null) {
                        FirebaseCloudService.firebaseCloudService.toggleOnlineStatus(
                          false,
                          Timestamp.now(),
                          false,
                        );
                        Get.offAndToNamed('/signIn');
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.login,color: (themeController.isDarkMode.value) ? Colors.white: Colors.black,),
                        SizedBox(width: 20,),
                        Text('LogOut',style: TextStyle(fontSize: 23,color: Colors.redAccent
                        ),),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40,),
              ],
            ),
          );
        },
      ),
    );
  }

  Padding settingListTile(
      {required IconData icon, required String title, required String subTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Row(
        children: [
          Obx(() => Icon(icon, color: (themeController.isDarkMode.value) ? Colors.white: Colors.black, size: 30,),),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${title}', style: TextStyle(fontSize: 20),),
              Text('${subTitle}', style: TextStyle(letterSpacing: 0.5),)
            ],
          )
        ],
      ),
    );
  }
}
