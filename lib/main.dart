import 'package:chat_app/controller/theme_controller.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/view/auth/auth_mange.dart';
import 'package:chat_app/view/componets/Theme/dark_theme.dart';
import 'package:chat_app/view/componets/atach_file.dart';
import 'package:chat_app/view/componets/signIn_page.dart';
import 'package:chat_app/view/componets/signUp_page.dart';
import 'package:chat_app/view/screen/chat_page.dart';
import 'package:chat_app/view/screen/home_page.dart';
import 'package:chat_app/view/screen/settings_page.dart';
import 'package:chat_app/view/screen/splach_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var theme = Get.put(ThemeController());
  theme.getDarkandLightModeForPrefernce();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        // theme: themeController.themeData,
        theme: GlobalTheme.lightTheme,
        darkTheme: GlobalTheme.darkTheme,
        themeMode:
        themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        // initialRoute: '/splash',
        getPages: [
          // GetPage(
          //   name: '/',
          //   page: () => SplachPage(),
          //   transition: Transition.rightToLeft,
          // ),
          GetPage(
            name: '/',
            page: () => AuthMange(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
              name: '/SignIn',
              page: () => const SigninPage(),
              transition: Transition.leftToRight),
          GetPage(
              name: '/signUp',
              page: () => const SignupPage(),
              transition: Transition.leftToRight),
          GetPage(
            name: '/home',
            page: () => const HomePage(),
          ),
          GetPage(
            name: '/settigs',
            page: () => const SettingsPage(),
          ),
          GetPage(
            name: '/chat',
            page: () =>  ChatPage(),
            transition: Transition.rightToLeft,
          ),
        ],
      ),
    );
  }
}

final ThemeController themeController = Get.put(ThemeController());
