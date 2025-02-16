import 'dart:async';

import 'package:chat_app/view/auth/auth_mange.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplachPage extends StatelessWidget {
  const SplachPage({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      Get.to(AuthMange());
    },);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 200,),
            Container(
              height: h * 0.5,
              width: w * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/logo/logo_app-removebg-preview (1).png'),
                ),
              ),
            ),
            Spacer(),
            Text('Power By',style: TextStyle(color: Colors.white70,fontSize: 18),),
            SizedBox(height: 8,),
            Text('Meta',style: TextStyle(color: Colors.white70,fontSize: 18),),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
