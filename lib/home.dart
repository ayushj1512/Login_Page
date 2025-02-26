import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 70,
        ),
        Center(
          child: Image.asset(
            "assets/image-removebg-preview.png",
            height: 350,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Hey Welcome back!\nHow's your day going?",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }
}
