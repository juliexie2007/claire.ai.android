import 'package:flutter/material.dart';

class PersonalizedDashboardScreen extends StatefulWidget {
  const PersonalizedDashboardScreen({super.key});

  @override
  State<PersonalizedDashboardScreen> createState() => _PersonalizedDashboardScreenState();
}

class _PersonalizedDashboardScreenState extends State<PersonalizedDashboardScreen> {
  // Track which areas are selected
  Map<String, bool> selectedAreas = {
    'Health & Wellness': true,
    'Time Management': true,
    'Work & Email': false,
    'Learning': true,
    'Home & Finances': false,
    'Relationships & Communication': false,
    'Other': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Color(0xFF4A4949),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Title
              const Text(
                "Personalized\nDashboard",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4949),
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Subtitle
              const Text(
                "What areas would\nyou like Claire to help\nwith?",
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF666666),
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Areas list
              Expanded(
                child: ListView(
                  children: selectedAreas.keys.map((area) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildAreaItem(area, selectedAreas[area]!),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Continue button
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/goals'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'Continue',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAreaItem(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAreas[title] = !selectedAreas[title]!;
        });
      },
      child: Row(
        children: [
          // Custom checkbox
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF87CEEB) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isSelected ? const Color(0xFF87CEEB) : const Color(0xFFCCCCCC),
                width: 2,
              ),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
          
          const SizedBox(width: 16),
          
          // Title text
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                color: Color(0xFF4A4949),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}