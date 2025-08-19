import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cloud icon - reduced bottom margin
              Container(
                width: 150,
                height: 120,
                margin: const EdgeInsets.only(bottom: 20), // halved from 40
                child: Image.asset(
                  'assets/images/cloud.png',
                  width: 120,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),

              // Main greeting text
              const Text(
                'Hi, I\'m Claire,',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D1D1F),
                  height: 1.2,
                ),
              ),
              const Text(
                'your personalized',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D1D1F),
                  height: 1.2,
                ),
              ),
              const Text(
                'AI assistant.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D1D1F),
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 32),

              // Description text
              const Text(
                'Let\'s get to know each other.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6E6E73),
                  height: 1.3,
                ),
              ),
              const Text(
                'What\'s your name?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6E6E73),
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 40),

              // Underline-only input field with square check button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter name',
                        hintStyle: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF3A3A3C), // dark gray
                            width: 2, // thicker line
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF3A3A3C), // dark gray
                            width: 2, // thicker line
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1D1D1F),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Check button with tap action
                  GestureDetector(
                    onTap: () {
                      String name = _nameController.text.trim();
                      if (name.isNotEmpty) {
                        Navigator.pushNamed(context, '/hello',
                            arguments: name);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter your name"),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA2CFFE),
                        borderRadius: BorderRadius.circular(8), // square w/ rounded corners
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
