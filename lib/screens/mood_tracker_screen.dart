import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodTrackerScreen extends StatefulWidget {
  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController _noteController = TextEditingController();

  String? _selectedMood;
  bool _loading = true;
  bool _saving = false;

  List<Map<String, dynamic>> _moodHistory = [];

  @override
  void initState() {
    super.initState();
    _loadMoodHistory();
  }

  Future<void> _loadMoodHistory() async {
    setState(() => _loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid ?? "guest";

      final snapshot = await _db
          .collection('moods')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      setState(() {
        _moodHistory = snapshot.docs.map((doc) {
          return {
            'mood': doc['mood'] ?? "neutral",
            'date': doc['date'] ?? Timestamp.now(),
          };
        }).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error loading moods: $e")));
    }
  }

  Future<void> _saveMood() async {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please select a mood")));
      return;
    }

    setState(() => _saving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid ?? "guest";

      await _db.collection('moods').add({
        'mood': _selectedMood,
        'note': _noteController.text,
        'date': Timestamp.now(),
        'userId': userId,
      });

      _noteController.clear();
      _selectedMood = null;

      await _loadMoodHistory();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Mood saved!")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error saving mood: $e")));
    }

    setState(() => _saving = false);
  }

  Widget _moodButton(String mood, String emoji) {
    final bool isSelected = _selectedMood == mood;

    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(isSelected ? 18 : 12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.purple.shade200 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.purple.shade700 : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.purple.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ]
              : [],
        ),
        child: Text(
          emoji,
          style: TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  int _moodToIndex(String mood) {
    switch (mood) {
      case "anxious":
        return 0;
      case "sad":
        return 1;
      case "neutral":
        return 2;
      case "happy":
        return 3;
      default:
        return 2;
    }
  }

  Widget _buildChart() {
    if (_moodHistory.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
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
        child: Text(
          "No mood history yet.",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final data = _moodHistory.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        _moodToIndex(entry.value['mood']).toDouble(),
      );
    }).toList();

    return Container(
      height: 230,
      padding: EdgeInsets.all(12),
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
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(
            border: Border.all(color: Colors.purple.shade700),
          ),
          gridData: FlGridData(show: true, drawVerticalLine: false),
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              color: Colors.white,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.3), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[700]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Text(
                "Track Your Mood",
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _moodButton("happy", "😄"),
                  _moodButton("neutral", "🙂"),
                  _moodButton("sad", "😢"),
                  _moodButton("anxious", "😰"),
                ],
              ),

              if (_selectedMood != null) ...[
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "You feel ${_selectedMood!.toUpperCase()}",
                    style: TextStyle(
                        color: Colors.purple.shade700,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],

              SizedBox(height: 25),

              ElevatedButton(
                onPressed: _saving ? null : _saveMood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  foregroundColor: Colors.white,
                  padding:
                  EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _saving
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  "Save Mood",
                  style: TextStyle(fontSize: 18),
                ),
              ),

              SizedBox(height: 30),

              Text(
                "Mood History",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              _buildChart(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
