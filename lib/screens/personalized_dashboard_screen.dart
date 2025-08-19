import 'package:flutter/material.dart';

class PersonalizedDashboardScreen extends StatelessWidget {
  const PersonalizedDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Center( // CENTER THE CARD
        child: Container(
          width: 280,
          height: 360,
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                
                // Title
                Text(
                  "Personalized\nDashboard",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                ),
                
                SizedBox(height: 12),
                
                // Subtitle
                Text(
                  "What goals would\nyou like Claire to help\nyou achieve?\n\nSetting Goals\nDaily Check-ins\nProgress Tracking\nCustom\nRecommendations\n\nDashboard\nComing Soon",
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
                
                Spacer(),
                
                // Continue button
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/recorder'),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF2196F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}