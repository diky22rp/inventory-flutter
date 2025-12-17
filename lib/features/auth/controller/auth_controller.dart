import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rxn<User> firebaseUser = Rxn<User>();
  final isLoading = false.obs;

  // LOGIN
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser.value = cred.user;
      Get.snackbar('Login Success', 'Welcome ${cred.user?.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message ?? 'Unknown error');
    } finally {
      isLoading.value = false;
    }
  }

  // REGISTER
  Future<void> register(String email, String password) async {
    try {
      isLoading.value = true;

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser.value = cred.user;
      Get.snackbar('Register Success', 'Welcome ${cred.user?.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Register Failed', e.message ?? 'Unknown error');
    } finally {
      isLoading.value = false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    firebaseUser.value = null;
  }

  // GET CURRENT USER
  User? get currentUser => firebaseUser.value;
}
