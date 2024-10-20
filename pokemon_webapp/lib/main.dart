import 'package:flutter/material.dart';
import 'package:pokemon_webapp/auth/login_or_register.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCndRx1n18TA_7YVOxnSCPAHTc__eyD29g",
      authDomain: "pokemonswipe.firebaseapp.com",
      projectId: "pokemonswipe",
      storageBucket: "pokemonswipe.appspot.com",
      messagingSenderId: "442595098655",
      appId: "1:442595098655:web:2dac6f0bbc5070d5a5552a",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginOrRegister(),
    );
  }
}
