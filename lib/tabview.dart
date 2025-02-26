import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/home.dart';
import 'package:loginpage/loginpage.dart';
import 'package:loginpage/profile.dart';
import 'package:loginpage/settings.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Home', icon: Icon(Icons.home)),
              Tab(text: 'Profile', icon: Icon(Icons.person)),
              Tab(text: 'Settings', icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Home(),
            Profile(),
            Settings(),
          ],
        ),
      ),
    );
  }
}
