import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';
import 'screens/hello_name_screen.dart';
import 'screens/privacy_preferences_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/personalized_dashboard_screen.dart';
import 'screens/goal_details_screen.dart';
// import 'screens/claire_ai_screen.dart';
// import 'screens/todays_tasks_screen.dart';
// import 'screens/task_reminders_screen.dart';
// import 'screens/congratulations_screen.dart';
// import 'screens/smart_insights_screen.dart';
// import 'screens/suggestions_screen.dart';
// import 'screens/settings_screen.dart';
import 'screens/audio_recorder_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Claire AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Nunito',
      ),
      home: IntroScreen(), // Start with the intro screen
      debugShowCheckedModeBanner: false,
      routes: {
        '/intro': (context) => IntroScreen(),
        '/hello': (context) => HelloNameScreen(),
        '/privacy': (context) => PrivacyPreferencesScreen(),
        '/account': (context) => CreateAccountScreen(),
        '/dashboard': (context) => PersonalizedDashboardScreen(),
        '/goals': (context) => GoalDetailsScreen(),
        // '/claire': (context) => ClaireAIScreen(),
        // '/tasks': (context) => TodaysTasksScreen(),
        // '/reminders': (context) => TaskRemindersScreen(),
        // '/congratulations': (context) => CongratulationsScreen(),
        // '/insights': (context) => SmartInsightsScreen(),
        // '/suggestions': (context) => SuggestionsScreen(),
        // '/settings': (context) => SettingsScreen(),
        '/recorder': (context) => AudioRecorderScreen(),
      },
    );
  }
}