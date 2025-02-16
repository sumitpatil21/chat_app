import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/view/componets/signIn_page.dart';
import 'package:chat_app/view/screen/home_page.dart';
import 'package:flutter/material.dart';

class AuthMange extends StatelessWidget {
  const AuthMange({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthServices.authServices.getCurrentUser() == null ? SigninPage() : HomePage();
  }
}
