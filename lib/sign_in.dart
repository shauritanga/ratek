// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home.dart';
import 'cooperate.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

final roleProvider = FutureProvider<String>(
  (ref) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final role = preferences.getString("role");
      return role ?? "unknown";
    } catch (e) {
      print(e);
      return "unknown";
    }
  },
);

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  String cooperateCode = "";
  String username = "";
  String password = "";
  bool hidePassword = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInUsingEmailAndPassword(
      String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sharedPreferences.setBool('isLoggedIn', true);
      User? user = userCredential.user;
      if (user != null) {
        // Fetch additional user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("farmers")
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?;

          await userCredential.user?.updateDisplayName(userData?["name"]);
          await userCredential.user?.updatePhotoURL(userData?["photo"]);
          sharedPreferences.setBool("isLoggedIn", true);
          sharedPreferences.setString("userId", userCredential.user?.uid ?? "");
          sharedPreferences.setString(
              "email", userCredential.user?.email ?? "");
          sharedPreferences.setString("displayName", userData?["name"] ?? "");
          sharedPreferences.setString("photoURL", userData?["photo"] ?? "");
          sharedPreferences.setString(
              "accessToken", userCredential.credential?.accessToken ?? "");
        }
        return userCredential;
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No user found for that email.")));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Wrong password provided for that user.")));
      } else if (e.code == "network-request-failed") {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Check your internet connection.")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Server error: ${e.code}")));
      }
      return null; // Return null in case of an error
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      await preferences.setBool('isLoggedIn', true);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
    } catch (e) {
      debugPrint('General Sign-In Error: $e');
    }
    return null; // Return null in case of an error
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final asyncValue = ref.watch(roleProvider);
    return asyncValue.when(
      loading: () => const Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Text("$error"),
      data: (data) {
        final role = data;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: role == 'cooperative'
              ? Container(
                  height: size.height,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(27),
                      topRight: Radius.circular(27),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          const Text("Namba ya ushirika"),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Jaza namba ya ushirika",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onSaved: (value) => cooperateCode = value!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Jaza namba ya ushitika";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                          const Text("Jina"),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Jaza jina la mtumiaji",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onSaved: (value) => username = value!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Jaza jina la mtumiaji";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                          const Text("Password"),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Jaza password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                icon: Icon(
                                  hidePassword
                                      ? FontAwesomeIcons.eyeSlash
                                      : FontAwesomeIcons.eye,
                                ),
                              ),
                            ),
                            onSaved: (value) => password = value!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Jaza password";
                              }
                              return null;
                            },
                            obscureText: hidePassword,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                          MaterialButton(
                            onPressed: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();

                                if (!(cooperateCode == "g45e") ||
                                    !(username.toLowerCase() == "uwamambo") ||
                                    !(password == "Uwamambo@!#24")) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Taarifa ulizojaza sio sahihi. Jaribu tena"),
                                    ),
                                  );
                                  return;
                                }
                                await preferences.setBool("isLoggedIn", true);
                                await showDialog(
                                  context: context,
                                  builder: (context) => FutureProgressDialog(
                                    Future.delayed(
                                      const Duration(seconds: 3),
                                    ),
                                    message: const Text('Inapakua...'),
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CooperativeScreen(),
                                  ),
                                );
                              }
                            },
                            height: 56,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            minWidth: double.infinity,
                            color: Theme.of(context).colorScheme.primary,
                            child: Text(
                              "Ingia",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          UserCredential? userCredential =
                              await signInWithGoogle();

                          debugPrint(userCredential.toString());
                          if (userCredential != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          // Handle specific FirebaseAuth errors
                          if (e.code ==
                              'account-exists-with-different-credential') {
                            debugPrint(
                                'Account already exists with a different credential.');
                          } else if (e.code == 'invalid-credential') {
                            debugPrint('Invalid credential provided.');
                          } else {
                            debugPrint('FirebaseAuthException: ${e.message}');
                          }
                        } catch (e) {
                          debugPrint('General error: $e');
                        }
                      },
                      child: Image.asset("assets/images/eg.png"),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
