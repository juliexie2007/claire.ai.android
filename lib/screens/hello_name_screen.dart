import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelloNameScreen extends StatelessWidget {
  const HelloNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String name =
        ModalRoute.of(context)!.settings.arguments as String? ?? "NAME";

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4A4949)),
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              // Add some top spacing
              const SizedBox(height: 140),
              
              // HELLO text - no longer wrapped in a sized container
              Text(
                "HELLO, $name!",
                style: GoogleFonts.nunito(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: 3.0,
                ),
                textAlign: TextAlign.center,
              ),

              // Small gap between hello and icons (adjust this to match Figma exactly)
              const SizedBox(height: 80),

              // Icons row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/clock.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(width: 30),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFF4D2),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.black87.withOpacity(0.8),
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Image.asset(
                    'assets/images/heart.png',
                    width: 80,
                    height: 80,
                  ),
                ],
              ),

              // Gap between icons and description text
              const SizedBox(height: 50),

              // Description text
              const Text(
                "Claire learns from \nyour habits and routines \nto help optimize your \ndaily life — from \nscheduling to self-care.",
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF4A4949),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/privacy');
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "Continue",
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4949),
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Color(0xFF4A4949), size: 24),
          ],
        ),
      ),
    );
  }
}