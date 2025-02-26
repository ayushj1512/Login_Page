import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:loginpage/loginpage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  User? user;
  Map<String, dynamic>? userData;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _isUploading = true;
    });

    File file = File(image.path);
    String filePath = 'profile_pictures/${user!.uid}.jpg';
    try {
      await _storage.ref(filePath).putFile(file);
      String downloadURL = await _storage.ref(filePath).getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'profilePic': downloadURL});
      setState(() {
        userData?["profilePic"] = downloadURL;
        _isUploading = false;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print("Error uploading image: $e");
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Loginpage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 130,
          ),
          Align(
            // 🔥 Everything is centered
            child: userData == null
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // ✅ Centers everything vertically
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: _pickAndUploadImage,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: userData?["profilePic"] != null
                                  ? NetworkImage(userData?["profilePic"])
                                  : const AssetImage(
                                          "assets/image-removebg-preview (1).png")
                                      as ImageProvider,
                            ),
                          ),
                          if (_isUploading)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                userData?["name"] ?? "N/A",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                user?.email ?? "N/A",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Logout",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
