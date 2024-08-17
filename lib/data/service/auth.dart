import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  static Future<void> signOutUser() async {
    await auth.signOut();
  }

  static Future<void> deleteUser() async {
    User? user = auth.currentUser;
    user?.delete();
  }
}
