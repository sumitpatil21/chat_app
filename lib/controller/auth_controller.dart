import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController
{
  var txtEmail = TextEditingController();
  var txtPassword = TextEditingController();
  var txtName = TextEditingController();
  var txtConfirmPassword = TextEditingController();
  var txtPhone = TextEditingController();
  var txtImage = TextEditingController();
  var txtToken = TextEditingController();
  GlobalKey<FormState> signInformkey = GlobalKey();
  GlobalKey<FormState> signUpformkey = GlobalKey();

  RxBool  hidePassword = true.obs;

  void passwordHide()
  {
    // hidePassword.value != hidePassword.value;
    if(hidePassword.value)
      {
        hidePassword.value = false;
      }
    else
      {
        hidePassword.value = true;
      }

  }
}