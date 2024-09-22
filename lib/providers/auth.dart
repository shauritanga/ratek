import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authService = Provider<AuthService>((ref) {
  return AuthService();
});

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes,
);

enum AuthState { authenticated, unauthenticated, loading }

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final authStateProvider = StreamProvider<AuthState>((ref) {
    return ref.watch(authService).authStateChanges();
  });

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<AuthState> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((firebase) {
      if (firebase != null) {
        return AuthState.authenticated;
      } else {
        return AuthState.unauthenticated;
      }
    });
  }

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      //final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      //final User? user = userCredential.user;

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
