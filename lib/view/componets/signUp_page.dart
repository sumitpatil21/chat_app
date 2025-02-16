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
              image: AssetImage('assets/images/chat.png'),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 70,
                ),
                FadeInDown(
                  child: Center(
                    child: SizedBox(
                      height: 110,
                      width: 110,
                      child: Image.asset(
                          fit: BoxFit.cover,
                          'assets/images/logo1-removebg-preview.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FadeInDown(
                  child: const Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeInLeft(
                  child: MyTextField(
                      validator: (value) {
                        if(value!.isEmpty)
                          {
                            return 'Value Must be required';
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
                        if (!value.contains('@gmail.com')) {
                          return 'Must Be Enter @gmail.com';
                        }
                        if (value.contains(' ')) {
                          return 'Do not enter the space';
                        }
                        if (RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Entre the must be lowercase required';
                        }
                        if (value.toString() == '@gmail.com') {
                          return 'example : abc@gmail.com';
                        }
                      },
                      hint: 'Enter Email',
                      prefixIcon: Icons.email_outlined,
                      controller: controller.txtEmail),
                ),
                FadeInLeft(
                  child: Obx(
                    () =>  MyTextField(
                      password: controller.hidePassword.value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          if (!RegExp(r'[a-z]').hasMatch(value)) {
                            return 'example Abc@1234';
                          }
                          if (!RegExp(r'[A-Z]').hasMatch(value)) {
                            return 'example Abc@1234';
                          }
                          if (!RegExp(r'\d').hasMatch(value)) {
                            return 'example Abc@1234';
                          }
                          if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                            return 'example Abc@1234';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        hint: 'Enter Password',
                        sufixTap: () {
                          controller.passwordHide();
                        },
                        sufixIcon: (controller.hidePassword.value) ? CupertinoIcons.eye_slash : Icons.remove_red_eye,
                        prefixIcon: Icons.lock_open,
                        controller: controller.txtPassword),
                  ),
                ),
                FadeInRight(
                  child: Obx(
                    () =>  MyTextField(
                      password: controller.hidePassword.value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          if (!RegExp(r'[a-z]').hasMatch(value)) {
                            return 'example Abc@1234';
                          }
                          if (!RegExp(r'[A-Z]').hasMatch(value)) {
                            return 'example Abc@1234';
                          }
                          if (!RegExp(r'\d').hasMatch(value)) {
                            return 'example Abc@1234';
                          }
                          if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                            return 'example Abc@1234';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        sufixTap: () {
                          controller.passwordHide();
                        },
                        hint: 'Confirm Password',
                        sufixIcon: (controller.hidePassword.value) ? CupertinoIcons.eye_slash : Icons.remove_red_eye,
                        prefixIcon: Icons.lock_open,
                        controller: controller.txtConfirmPassword),
                  ),
                ),
                FadeInUp(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10,
                      top: 8,
                    ),
                    child: GestureDetector(
                      onTap: () async{
                        bool res = controller.signUpformkey.currentState!.validate();
                        if(res)
                          {
                            if (controller.txtPassword.text ==
                                controller.txtConfirmPassword.text) {
                              try {
                                await AuthServices.authServices.createAccountWithEmailAndPassword(
                                  controller.txtEmail.text,
                                  controller.txtPassword.text,
                                );
                                UserModal userModal = UserModal(
                                 name:  controller.txtName.text,
                                  image:  '',
                                  email : controller.txtEmail.text,
                                  token:  '',
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
                                controller.txtPhone.clear();
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
                              // Show error if passwords do not match
                              Get.snackbar(
                                "Password Mismatch",
                                "The passwords you entered do not match.",
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
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xff888996)
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
