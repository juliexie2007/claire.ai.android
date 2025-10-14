import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _pwdCtrl, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => const DashboardScreen(),
                ));
              },
              child: const Text("Continue"),
            )
          ],
        ),
      ),
    );
  }
}
