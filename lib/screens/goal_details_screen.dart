import 'package:flutter/material.dart';

class GoalDetailsScreen extends StatefulWidget {
  const GoalDetailsScreen({super.key});

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  final TextEditingController _goalController = TextEditingController();

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back arrow
            Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF4A4949),
                    size: 24,
                  ),
                ),
              ),
            ),
            
            // Content with side padding
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    
                    // Title
                    Text(
                      "Goal Details",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4949),
                      ),
                    ),
                    
                    SizedBox(height: 32),
                    
                    // Subtitle question
                    Text(
                      "What are your top\n1-3 goals right now?",
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF4A4949),
                        height: 1.5,
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Goal examples
                    Text(
                      "1. Improve self-care",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF4A4949),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    Text(
                      "2. Exercise 3x / week",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF4A4949),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    Spacer(),
                    
                    // Input field
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFADADAD),
                            width: 3,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: _goalController,
                        decoration: InputDecoration(
                          hintText: "Enter goal",
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF4A4949),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 32),
            
            // Skip button
            Padding(
              padding: EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/recorder'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4949),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 24,
                      color: Color(0xFF4A4949),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}