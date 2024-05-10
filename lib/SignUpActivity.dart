import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kosh/CreateProfileActivity.dart';
import 'package:kosh/MainActivity.dart';

class SignUpActivity extends StatefulWidget {
  const SignUpActivity({super.key});

  @override
  State<SignUpActivity> createState() => _SignUpActivityState();
}

class _SignUpActivityState extends State<SignUpActivity> {
  @override
  Widget build(BuildContext context) {
    //SignInWithGooglee signInWithGooglee=SignInWithGooglee();
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Card(
            margin: const EdgeInsets.all(10),
            elevation: 10,
            color: Colors.white,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                    height: 80,
                    child: IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      color: Colors.red,
                      icon: Image.asset('assets/images/splashimage.png'),
                      autofocus: true,
                      iconSize: 10,
                      onPressed: () {},
                    )),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  "SignIn",
                  style: TextStyle(
                      color: Color(0xff3067A7),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () async {
                    //signInWithGoogle();
                    //then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>const MainActivity())));
                    final GoogleSignIn g_signIn = GoogleSignIn();

                    try {
                      final GoogleSignInAccount? g_SignIn_Account =
                          await g_signIn.signIn();

                      if (g_SignIn_Account != null) {
                        final GoogleSignInAuthentication? g_SignIn_auth =
                            await g_SignIn_Account?.authentication;

                        final AuthCredential credential =
                            GoogleAuthProvider.credential(
                          accessToken: g_SignIn_auth?.accessToken,
                          idToken: g_SignIn_auth?.idToken,
                        );
                        await FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((value) {
                          User? user = FirebaseAuth.instance.currentUser;
                          String? em = FirebaseAuth.instance.currentUser?.email;
                          if (user != null) {
                            FirebaseFirestore.instance
                                .collection("Users")
                                .doc(user.uid)
                                .set({
                              "userid": user.uid,
                              "name": "",
                              "number": "",
                              "image": "",
                              "village":"",
                              "email": user.email
                            }).then((value) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateProfileActivity(
                                              email: "asd123")));
                            });
                          }
                        });
                      }
                    } catch (e) {
                      print('$e');
                    }
                  },
                  child: Ink(
                    color: const Color(0xFF397AF3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Image.asset("assets/images/google.png",
                              width: 40, height: 40),
                          const SizedBox(width: 12),
                          const Text(
                            'Sign in with Google',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
