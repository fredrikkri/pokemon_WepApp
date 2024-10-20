import 'package:flutter/material.dart';
import 'package:pokemon_webapp/components/button.dart';
import 'package:pokemon_webapp/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logo
                const Icon(
                  Icons.auto_awesome_sharp,
                  size: 100,
                ),

                const SizedBox(
                  height: 50,
                ),

                // Welcome back message
                Text(
                  "Welcome to PokemonSwipe!",
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(
                  height: 25,
                ),

                // email text field
                MyTextField(
                    controller: emailTextController,
                    hintText: "Email",
                    obscureText: false),

                const SizedBox(
                  height: 10,
                ),

                // password textfield
                MyTextField(
                    controller: passwordTextController,
                    hintText: "Password",
                    obscureText: true),

                const SizedBox(
                  height: 25,
                ),

                // sign in button
                MyButton(onTap: () {}, text: "Sign In"),

                const SizedBox(
                  height: 25,
                ),

                // go to registrer page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Registrer now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
