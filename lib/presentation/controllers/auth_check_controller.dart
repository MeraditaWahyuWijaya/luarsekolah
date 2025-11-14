import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/main.dart';

class AuthCheckController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) Get.offAllNamed(AppRoutes.login);
      else Get.offAllNamed(AppRoutes.mainDashboard);
    });
  }
}
