import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loginpage/loginpage.dart';

class Signpage extends StatefulWidget {
  const Signpage({super.key});

  @override
  State<Signpage> createState() => _SignpageState();
}

class _SignpageState extends State<Signpage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _signUpWithEmail() async {
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Get the user ID
      String uid = userCredential.user!.uid;

      // Store user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'created_at': FieldValue.serverTimestamp(), // Better timestamp method
      });
      FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: false,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-up Successful! Please log in.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "This email is already registered.";
          break;
        case "invalid-email":
          errorMessage = "The email address is not valid.";
          break;
        case "weak-password":
          errorMessage = "The password is too weak.";
          break;
        default:
          errorMessage = "An error occurred: ${e.message}";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred.")),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Loginpage()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Text(
                    "Start your journey to success\nlet’s get you set up!",
                    style: GoogleFonts.anton(
                        fontWeight: FontWeight.bold, fontSize: 22),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            Center(
                child: Image.asset(
              "assets/pngtree-online-registration-or-sign-up-login-for-account-on-smartphone-app-picture-image_7926965.png",
              height: 150,
            )),
            Container(
              width: 330,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_sharp), // Email icon
                    labelText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: 330,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email), // Email icon
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: 330,
              child: TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock), // Password icon
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: 330,
              child: TextField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.lock_outline), // Confirm Password icon
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            SizedBox(height: 10),
            Container(
                width: 330,
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: _signUpWithEmail,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )),
            SizedBox(height: 15),
            Center(child: Text("or continue with")),
            SizedBox(height: 15),
            Container(
                width: 330,
                child: FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  onPressed: _signInWithGoogle,
                  child: Text(
                    "Google Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )),
            SizedBox(height: 15),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Already have an Account?"),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Loginpage()));
                  },
                  child: Text(
                    " Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
