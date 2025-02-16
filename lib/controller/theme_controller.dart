import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {

  RxBool isDarkMode= false.obs;

  @override
  void onInit() {
    super.onInit();
    getDarkandLightModeForPrefernce();
  }
  Future<void> themeMode()
  async {
    isDarkMode.value = !isDarkMode.value;
    await setDarkandLightModeForPrefernce(isDarkMode.value);
  }

  Future<void> setDarkandLightModeForPrefernce(bool isDark)
  async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('Dark', isDark);
  }

  Future<void> getDarkandLightModeForPrefernce()
  async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isDarkMode.value = sharedPreferences.getBool('Dark') ?? false ;
  }
}

