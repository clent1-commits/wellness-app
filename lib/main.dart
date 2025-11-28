import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart'; // Custom theme
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MentalWellnessTips());
}

class MentalWellnessTips extends StatelessWidget {
  const MentalWellnessTips({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mental Wellness Tips",
      theme: AppTheme.purpleMindfulnessTheme,
      debugShowCheckedModeBanner: false,

      // Listen to auth state changes
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // While checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Not logged in
          if (!snapshot.hasData) {
            return LoginScreen();
          }

          // Logged in → show main app
          return const MainNavigationScreen();
        },
      ),
    );
  }
}

// Main app WITHOUT bottom navigation and app bar
class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar here
      body: HomeScreen(), // Just show the HomeScreen directly
      // No bottomNavigationBar here
    );
  }
}
