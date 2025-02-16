import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/modal/user_modal.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/firebase_cloud_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoggleService {
  static GoggleService goggleService = GoggleService._();

  GoggleService._();

  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication authentication =
       await googleSignInAccount.authentication;

      print("\n\n\nobject Work\n\n\n");

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken);
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = AuthServices.authServices.getCurrentUser();

      // Handling null values safely
      String displayName = userCredential.user?.displayName ?? 'Unknown';
      String photoURL = userCredential.user?.photoURL ?? '';
      String email = userCredential.user?.email ?? 'No email';
      // Handling null values safely
      // String displayName = user!.displayName ?? 'Unknown';
      // String photoURL = user.photoURL ?? '';
      // String email = user.email ?? 'No email';

      await FirebaseCloudService.firebaseCloudService.insertUserIntoFireStore(
        UserModal(
          name:  displayName,
          image:  photoURL,
          email:  email,
          token: "---",
          isOnline: false,
          isTyping: false,
          timestamp: Timestamp.now(),
        ),
      );
    }
    Get.toNamed('/home');
  }

  Future<void> googleSignOut() async {
    await googleSignIn.signOut();
  }
}
