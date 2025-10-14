import 'package:flutter/material.dart';
import '../theme/claire_theme.dart';
import 'sign_in_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ClaireTheme.gradientTop, ClaireTheme.gradientBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud, size: 96, color: Colors.white),
                const SizedBox(height: 20),
                const Text("Hi, I'm Claire,", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const Text("your personalized AI assistant.", textAlign: TextAlign.center),
                const SizedBox(height: 40),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: "What’s your name?",
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const SignInScreen(),
                    ));
                  },
                  child: const Text("Continue"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
