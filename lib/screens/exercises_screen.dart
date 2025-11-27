import 'package:flutter/material.dart';
import 'dart:math';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExercisesScreen extends StatefulWidget {
  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  List<String> mindfulnessPrompts = [
    "Take a deep breath and notice how your body feels right now.",
    "Name three things in this room you can see that make you feel calm.",
    "What emotion are you feeling the most right now?",
    "Think of a person who makes you happy. What would you like to say to them?",
    "List three things you’re grateful for today.",
  ];

  String _currentPrompt = "Tap to generate a mindfulness prompt";

  TextEditingController gratitudeController = TextEditingController();
  DateTime _selectedDay = DateTime.now();

  final String userId = "12345"; // Replace with your user ID

  @override
  void initState() {
    super.initState();

    _breathingController =
    AnimationController(vsync: this, duration: Duration(seconds: 4))
      ..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 80, end: 150).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  void generateMindfulnessPrompt() {
    final rand = Random();
    setState(() {
      _currentPrompt =
      mindfulnessPrompts[rand.nextInt(mindfulnessPrompts.length)];
    });
  }

  Future<void> _saveGratitude() async {
    if (gratitudeController.text.trim().isEmpty) return;

    final journalRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('journal');

    final dateString =
        "${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}";

    final entryData = {
      'date': dateString,
      'entry': gratitudeController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    await journalRef.add(entryData);

    gratitudeController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gratitude entry saved 📝")),
    );
  }

  Stream<QuerySnapshot> _entriesStream(DateTime day) {
    final journalRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('journal');

    final dateString =
        "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";

    return journalRef
        .where('date', isEqualTo: dateString)
        .orderBy('timestamp', descending: true)
        .snapshots();
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
            padding: EdgeInsets.all(16),
            children: [
              Text(
                "Exercises",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // Breathing Exercise
              _buildPurpleCard(
                child: Column(
                  children: [
                    Text(
                      "Breathing Exercise",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: AnimatedBuilder(
                        animation: _breathingController,
                        builder: (_, child) {
                          double size = _breathingAnimation.value;
                          return Container(
                            height: 150,
                            alignment: Alignment.center,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/images/breathing.jpg",
                                height: size,
                                width: size,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Follow the circle.\nInhale 4s • Hold 4s • Exhale 4s",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // Mindfulness Prompt
              _buildPurpleCard(
                child: Column(
                  children: [
                    Text(
                      "Mindfulness Prompt",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _currentPrompt,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 14),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                      ),
                      onPressed: generateMindfulnessPrompt,
                      child: Text("New Prompt"),
                    )
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Gratitude Journal + Calendar
              _buildPurpleCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gratitude Journal",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _selectedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(day, _selectedDay),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() => _selectedDay = selectedDay);
                        },
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                              color: Colors.purple.shade300,
                              shape: BoxShape.circle),
                          selectedDecoration: BoxDecoration(
                              color: Colors.purple, shape: BoxShape.circle),
                          defaultTextStyle: TextStyle(color: Colors.white),
                          weekendTextStyle: TextStyle(color: Colors.white),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle:
                          TextStyle(color: Colors.white, fontSize: 18),
                          leftChevronIcon:
                          Icon(Icons.chevron_left, color: Colors.white),
                          rightChevronIcon:
                          Icon(Icons.chevron_right, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: gratitudeController,
                      maxLines: 2,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "What are you grateful for?",
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple),
                      onPressed: _saveGratitude,
                      child: Text("Save Entry"),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              StreamBuilder<QuerySnapshot>(
                stream: _entriesStream(_selectedDay),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  final entries = snapshot.data!.docs;

                  if (entries.isEmpty)
                    return Text(
                      "No entries for ${_selectedDay.month}/${_selectedDay.day}/${_selectedDay.year}",
                      style: TextStyle(color: Colors.white),
                    );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Entries for ${_selectedDay.month}/${_selectedDay.day}/${_selectedDay.year}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade900),
                      ),
                      SizedBox(height: 10),
                      ...entries.map(
                            (doc) => _buildPurpleCard(
                          child: Text(
                            doc['entry'].toString(),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurpleCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade700,
            Colors.purple.shade300,
          ],
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
    );
  }
}
