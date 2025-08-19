import 'package:flutter/material.dart';

Widget _buildCheckboxCard({
    required String text,
    required bool isChecked,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16), // Add left margin to align with toggle
              width: 40,        // Adjust checkbox size here
              height: 40,       // Adjust checkbox size here
              decoration: BoxDecoration(
                color: isChecked ? const Color(0xFF4CAF50) : Colors.transparent,
                border: Border.all(
                  color: isChecked ? const Color(0xFF4CAF50) : const Color(0xFFCCCCCC),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isChecked
                  ? const Icon(
                      Icons.check,
                      size: 30,        // Adjust check icon size here
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.check,
                      size: 30,        // Adjust check icon size here
                      color: Color(0xFF666666),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF374151),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildImageCard({
    required String imagePath,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16), // Add left margin to align with toggle
              width: 40,        // Adjust container size
              height: 40,       // Adjust container size
              child: Image.asset(
                imagePath,
                width: 32,      // Adjust actual image size
                height: 32,     // Adjust actual image size
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF374151),
                  height: 1.4,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

class PrivacyPreferencesScreen extends StatefulWidget {
  const PrivacyPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPreferencesScreen> createState() => _PrivacyPreferencesScreenState();
}

class _PrivacyPreferencesScreenState extends State<PrivacyPreferencesScreen> {
  bool _allowDataAccess = false;
  bool _startFresh = true;
  bool _privacyPolicyAgreed = false;

  // Check if all required conditions are met
  bool get _canContinue => _privacyPolicyAgreed && (_allowDataAccess || _startFresh);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
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
              const SizedBox(height: 80),
              
              // Centered main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      "Privacy & Data\nPreferences",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A1A),
                        height: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Privacy policy option
                    _buildImageCard(
                      imagePath: 'assets/images/lock.png',
                      text: "I agree with the\nprivacy policy",
                      isSelected: _privacyPolicyAgreed,
                      onTap: () {
                        setState(() {
                          _privacyPolicyAgreed = !_privacyPolicyAgreed;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Data access option with toggle
                    _buildToggleCard(
                      text: "Allow Claire to access\nmy past data (emails,\ncalendar, fitness, etc)",
                      isEnabled: _allowDataAccess,
                      onToggle: (value) {
                        setState(() {
                          _allowDataAccess = value;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Start fresh option
                    _buildCheckboxCard(
                      text: "I prefer to start fresh",
                      isChecked: _startFresh,
                      onTap: () {
                        setState(() {
                          _startFresh = !_startFresh;
                        });
                      },
                    ),
                  ],
                ),
              ),
              
              // Continue button at bottom right
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _canContinue ? () {
                        Navigator.pushNamed(context, '/account');
                      } : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: _canContinue ? Colors.black87 : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward, 
                            color: _canContinue ? Colors.black87 : Colors.grey, 
                            size: 24
                          ),
                        ],
                      ),
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

  Widget _buildToggleCard({
    required String text,
    required bool isEnabled,
    required Function(bool) onToggle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1, // Increase this to make toggle bigger (1.5, 1.8, etc.)
            child: Switch(
              value: isEnabled,
              onChanged: onToggle,
              activeColor: Colors.white,
              activeTrackColor: const Color.fromARGB(255, 169, 207, 235),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF374151),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}