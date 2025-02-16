
import 'package:animate_do/animate_do.dart';
import 'package:chat_app/view/componets/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../services/auth_services.dart';
import '../../services/goggle_services.dart';

var controller = Get.put(AuthController());

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff202126),
      body: Form(
        key: controller.signInformkey,
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
                      height: 130,
                      width: 130,
                      child: Image.asset(
                          fit: BoxFit.cover,
                          'assets/images/logo1-removebg-preview.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FadeInDown(
                  child: const Center(
                    child: Text(
                      textAlign: TextAlign.left,
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInLeft(
                  child: MyTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email or Phone is required';
                        }
                        if (!value.contains('@gmail.com')) {
                          return 'Must Be Enter @gmail.com';
                        }
                        if (value.contains(' ')) {
                          return 'Do not enter the sapce';
                        }
                        if (RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Entre the must be lowercase requried';
                        }
                        if (value.toString() == '@gmail.com') {
                          return 'emaple : abc@gmail.com';
                        }
                      },
                      hint: 'Enter email',
                      prefixIcon: Icons.email_outlined,
                      controller: controller.txtEmail),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(
                      left: 10.0, right: 10, bottom: 10, top: 10),
                  child: Obx(() => FadeInLeft(
                    child: TextFormField(
                      obscureText: controller.hidePassword.value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Password one lowercase letter';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password one uppercase letter';
                        }
                        if (!RegExp(r'\d').hasMatch(value)) {
                          return 'Password  one nummeric';
                        }
                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                          return 'Password must contain at least one special character';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      controller: controller.txtPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_open,
                          color: Colors.white,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            controller.passwordHide();
                          },
                          child:(controller.hidePassword.value)? Icon(
                            CupertinoIcons.eye_slash,
                            color: Colors.white,
                          ) : Icon(
                            CupertinoIcons.eye,
                            color: Colors.white,
                          ),
                        ),
                        fillColor: Color(0xff232732),
                        filled: true,
                        hintText: 'Enter Password',
                        hintStyle: const TextStyle(color: Colors.white70),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xff232732), width: 1.5)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.white, width: 2.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),)
                ),
                FadeInLeft(
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Reset Password'),
                            content: TextFormField(
                              controller: controller.txtEmail,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  String res = await AuthServices.authServices.forgotPassword(controller.txtEmail.text);
                                  if (res == 'Success') {
                                    Get.snackbar('Success', 'Password reset email sent!',
                                        snackPosition: SnackPosition.BOTTOM);
                                    print('-------yasu------');

                                  } else {
                                    Get.snackbar('Error', res,
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                  print('-------yasu------');
                                  Get.back(); // Close the dialog
                                },
                                child: Text('Send'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back(); // Close the dialog
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white70, fontSize: 17),
                    ),
                  ),
                ),

                SizedBox(height: 30,),
                FadeInRight(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10,
                      top: 8,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        bool response =
                        controller.signInformkey.currentState!.validate();
                        if (response) {
                          String res = await AuthServices.authServices
                              .signInWithEmailAndPassword(
                              controller.txtEmail.text,
                              controller.txtPassword.text);

                          User? user = AuthServices.authServices.getCurrentUser();
                          if (user != null && res == 'Success') {
                            Get.toNamed('/home');
                          } else {
                            Get.snackbar("Sign In Failed !", res);
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xff888996),
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
                FadeInRight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have account?",
                        style: TextStyle(color: Colors.white70, fontSize: 17),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.toNamed('/signUp');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.blue, fontSize: 17),
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          height: 1, // Divider thickness
                          color: Colors.grey, // Divider color
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                      ), // Text or any widget
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                FadeInUp(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff232732)),
                        alignment: Alignment.center,
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                  image: AssetImage('assets/images/facebook (1).png'))                        ),
                        ),
                      ),
                      GestureDetector(
                        onTap: ()  {
                           GoggleService.goggleService.signInWithGoogle();
                          User? user = AuthServices.authServices.getCurrentUser();
                          if (user != null) {
                            Get.offAndToNamed("/home");
                          }
                        },
                        child:  Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff232732)),
                          alignment: Alignment.center,
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                    image: AssetImage('assets/images/google (1).png'))                        ),
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                        color: Color(0xff232732)),
                        alignment: Alignment.center,
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                              image: const DecorationImage(
                                  image: AssetImage('assets/images/apple.png'))                        ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
