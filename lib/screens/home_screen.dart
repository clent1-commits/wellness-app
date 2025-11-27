import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'mood_tracker_screen.dart';
import 'exercises_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';
import 'motivational_quotes_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _fs = FirestoreService();
  bool _loading = true;
  List<Map<String, dynamic>> _tips = [];
  Map<String, dynamic>? _currentTip;

  @override
  void initState() {
    super.initState();
    _loadTips();
  }

  Future<void> _loadTips() async {
    setState(() => _loading = true);
    final all = await _fs.fetchAllTips();
    setState(() {
      _tips = all;
      _currentTip = _fs.pickRandomTip(all);
      _loading = false;
    });
  }

  void _newTip() {
    setState(() => _currentTip = _fs.pickRandomTip(_tips));
  }

  void _saveTip() async {
    if (_currentTip != null) {
      await _fs.saveFavorite(_currentTip!);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Saved to favorites")));
    }
  }

  /// Bottom nav circle buttons with breathing effect
  Widget _navCircle(String label, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Column(
        children: [
          BreathingCircle(
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.purple.shade700, Colors.purple.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(icon, size: 26, color: Colors.white),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.purple.shade900,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple[700],
        side: BorderSide(color: Colors.purple[700]!),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: Text(label, style: TextStyle(fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[700]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 140),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.settings,
                              color: Colors.white, size: 28),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      ClipOval(
                        child: Image.asset(
                          "assets/images/logo.jpg",
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Mental Wellness App",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.purple[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Your Daily Wellness Tip",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 3),
                      Container(
                        width: screenWidth * 0.90,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade700,
                              Colors.purple.shade300,
                            ],
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
                        child: _loading
                            ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                            : Column(
                          children: [
                            Text(
                              _currentTip?['title'] ?? "",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              _currentTip?['content'] ?? "",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _actionButton("Save", _saveTip),
                          SizedBox(width: 8),
                          _actionButton("New Tip", _newTip),
                        ],
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _navCircle(
                        "Quotes", Icons.format_quote, MotivationalQuotesScreen()),
                    _navCircle("Mood", Icons.mood, MoodTrackerScreen()),
                    _navCircle("Exercise", Icons.spa, ExercisesScreen()),
                    _navCircle("Favorites", Icons.favorite, FavoritesScreen()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// BreathingCircle Widget (only for the circle, not the card)
class BreathingCircle extends StatefulWidget {
  final Widget child;
  const BreathingCircle({required this.child});

  @override
  _BreathingCircleState createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}
