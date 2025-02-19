import 'package:animate_do/animate_do.dart';
import 'package:chat_app/view/componets/signIn_page.dart';
import 'package:chat_app/view/componets/textField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modal/user_modal.dart';
import '../../services/auth_services.dart';
import '../../services/firebase_cloud_service.dart';
import '../../services/goggle_services.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: controller.signUpformkey,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('https://source.unsplash.com/random/800x600/?chat,background'),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                FadeInDown(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInDown(
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInLeft(
                  child: MyTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name is required';
                        }
                      },
                      hint: 'Enter Name',
                      prefixIcon: Icons.person,
                      controller: controller.txtName),
                ),
                FadeInRight(
                  child: MyTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                      },
                      hint: 'Enter Email',
                      prefixIcon: Icons.email_outlined,
                      controller: controller.txtEmail),
                ),
                FadeInLeft(
                  child: Obx(
                        () => MyTextField(
                        password: controller.hidePassword.value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                        },
                        hint: 'Enter Password',
                        sufixTap: () {
                          controller.passwordHide();
                        },
                        sufixIcon: controller.hidePassword.value
                            ? CupertinoIcons.eye_slash
                            : Icons.remove_red_eye,
                        prefixIcon: Icons.lock_open,
                        controller: controller.txtPassword),
                  ),
                ),
                FadeInRight(
                  child: Obx(
                        () => MyTextField(
                        password: controller.hidePassword.value,
                        validator: (value) {
                          if (value != controller.txtPassword.text) {
                            return 'Passwords do not match';
                          }
                        },
                        hint: 'Confirm Password',
                        sufixTap: () {
                          controller.passwordHide();
                        },
                        sufixIcon: controller.hidePassword.value
                            ? CupertinoIcons.eye_slash
                            : Icons.remove_red_eye,
                        prefixIcon: Icons.lock_open,
                        controller: controller.txtConfirmPassword),
                  ),
                ),
                FadeInUp(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (controller.signUpformkey.currentState!.validate()) {
                          if (controller.txtPassword.text ==
                              controller.txtConfirmPassword.text) {
                            try {
                              await AuthServices.authServices
                                  .createAccountWithEmailAndPassword(
                                controller.txtEmail.text,
                                controller.txtPassword.text,
                              );
                              UserModal userModal = UserModal(
                                name: controller.txtName.text,
                                image: '',
                                email: controller.txtEmail.text,
                                token: '',
                                isTyping: false,
                                isOnline: false,
                                timestamp: Timestamp.now(),
                              );

                              await FirebaseCloudService.firebaseCloudService
                                  .insertUserIntoFireStore(userModal);
                              controller.txtPassword.clear();
                              controller.txtEmail.clear();
                              controller.txtName.clear();
                              controller.txtConfirmPassword.clear();
                              Get.toNamed('/home');
                            } catch (e) {
                              Get.snackbar(
                                "Error",
                                e.toString(),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          } else {
                            Get.snackbar(
                              "Password Mismatch",
                              "The passwords do not match.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 30),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blueAccent,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
