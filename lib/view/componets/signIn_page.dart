import 'package:animate_do/animate_do.dart';
import 'package:chat_app/view/componets/signUp_page.dart';
import 'package:chat_app/view/componets/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../services/auth_services.dart';


var controller = Get.put(AuthController());

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: controller.signInformkey,
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
                    'Sign In',
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
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                      },
                      hint: 'Enter email',
                      prefixIcon: Icons.email_outlined,
                      controller: controller.txtEmail),
                ),
                const SizedBox(height: 8),
                FadeInLeft(
                  child: Obx(() => MyTextField(
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

                InkWell(onTap: () {
                 Get.to(SignupPage());
                },child: Text("You have don't account.. ",style: TextStyle(fontSize: 20,color: Colors.blue,),)),
                const SizedBox(height: 30),
                FadeInRight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (controller.signInformkey.currentState!.validate()) {
                          String res = await AuthServices.authServices
                              .signInWithEmailAndPassword(
                              controller.txtEmail.text,
                              controller.txtPassword.text);

                          User? user = AuthServices.authServices.getCurrentUser();
                          if (user != null && res == 'Success') {
                            Get.toNamed('/home');
                          } else {
                            Get.snackbar("Sign In Failed!", res);
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blueAccent,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
