import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_webapp/auth/login_or_register.dart';
import 'package:pokemon_webapp/pages/swipe_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            //print('User is logged in: ${snapshot.data}');

            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              //print("Current user: ${user.email}");
            } else {
              //print("No current user");
            }
            return const SwipePage();
          } else {
            //print('No user is logged in');
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
