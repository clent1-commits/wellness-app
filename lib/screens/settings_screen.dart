import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  bool _darkMode = false;
  bool _notifications = true;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _loadSettings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      _notifications = prefs.getBool('notifications') ?? true;
    });

    _animationController.forward();
  }

  Future<void> _clearLocalFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('local_favorites');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Local favorites cleared.")),
    );
  }

  Widget _buildCard({required Widget child, required int index}) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1 * index, 0.6 + 0.1 * index, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.2 * (index + 1)),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        )),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade700, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.shade200.withOpacity(0.4),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade700, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 24),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Account Placeholder
              _buildCard(
                index: 2,
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.white),
                  title: Text("Account", style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    "Sign in to sync favorites across devices",
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Sign-in screen coming soon")),
                    );
                  },
                ),
              ),

              // Clear Local Favorites
              _buildCard(
                index: 3,
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red.shade200),
                  title: Text("Clear Local Favorites",
                      style: TextStyle(color: Colors.white)),
                  onTap: _clearLocalFavorites,
                ),
              ),

              // About App
              _buildCard(
                index: 4,
                child: ListTile(
                  leading: Icon(Icons.info, color: Colors.white),
                  title: Text("About App", style: TextStyle(color: Colors.white)),
                  subtitle: Text("Mental Wellness Tips • v1.0",
                      style: TextStyle(color: Colors.white70)),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: "Mental Wellness Tips",
                      applicationVersion: "1.0.0",
                      applicationIcon: Icon(Icons.spa, color: Colors.white),
                      children: [
                        Text(
                          "A mindfulness and mental-wellness app that helps you build positive habits.",
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Logout Button
              _buildCard(
                index: 5,
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.white),
                  title: Text("Log Out", style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Confirm Logout"),
                        content: Text("Are you sure you want to log out?"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text("Cancel")),
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text("Log Out")),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
