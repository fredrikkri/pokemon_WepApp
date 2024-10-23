import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_webapp/components/auth_action_button.dart';
import 'package:pokemon_webapp/components/text_field.dart';
import 'package:pokemon_webapp/service/user_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);
      displayRegistrerMessage("Passwords don't match");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      if (context.mounted) {
        UserService().registrerUser(usernameTextController.text);
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      displayRegistrerMessage(e.code);
    }
  }

  void displayRegistrerMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
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
                    "Lets create an account for you.",
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

                  // username text field
                  MyTextField(
                      controller: usernameTextController,
                      hintText: "Username",
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
                    height: 10,
                  ),

                  // confirm password textfield
                  MyTextField(
                      controller: confirmPasswordTextController,
                      hintText: "Confirm Password",
                      obscureText: true),

                  const SizedBox(
                    height: 25,
                  ),

                  // sign in button
                  AuthActionButton(onTap: signUp, text: "Sign Up"),

                  const SizedBox(
                    height: 25,
                  ),

                  // go to registrer page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login now",
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
      ),
    );
  }
}
