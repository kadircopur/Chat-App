import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in anonym
  Future<User?> signInAnonym() async {
    try {
      final UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  String getCurrentUserName() {
    if (_auth.currentUser != null && _auth.currentUser!.displayName != null) {
      return _auth.currentUser!.displayName!;
    } else {
      return "";
    }
  }
}
