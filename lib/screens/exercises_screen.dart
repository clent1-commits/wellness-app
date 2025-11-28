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
    "Close your eyes and notice the sounds around you for 30 seconds.",
    "What is one thing you can do today to be kind to yourself?",
    "Reflect on a recent challenge and what you learned from it.",
    "Take a slow breath in for 4 counts, hold for 4, out for 4.",
    "Name three positive qualities about yourself.",
    "Think of a time you overcame a difficult situation. How did it feel?",
    "Describe a place where you feel safe and calm.",
    "Write down one thing you want to accomplish this week.",
    "Notice the sensations in your feet as they touch the ground.",
    "Think about a favorite memory and why it makes you happy.",
    "What is one thing you can let go of today?",
    "Name one thing that made you smile today.",
    "Take a mindful walk and notice how your body moves.",
    "Describe your feelings in one word.",
    "Write down one thing that is within your control right now.",
    "Notice the temperature of the room and how it feels on your skin.",
    "Think about someone you appreciate. Could you send them a message?",
    "Take a slow sip of water and notice its taste and temperature.",
    "Name a personal strength you can use this week.",
    "Write a positive affirmation for yourself today.",
    "Notice how your shoulders feel. Are they tense? Relax them.",
    "What is one small thing you can do to reduce stress right now?",
    "Visualize a peaceful place in your mind.",
    "What is one thing you’ve done recently that you’re proud of?",
    "Take a deep breath and imagine releasing all tension.",
    "Name one thing you’re looking forward to this week.",
    "Write down something that made you laugh recently.",
    "Think about a time when you helped someone. How did it feel?",
    "Close your eyes and notice the rise and fall of your chest as you breathe.",
    "Name three things you can see, hear, and feel in this moment.",
    "Write down one way you can show kindness to a classmate today.",
    "Take a moment to stretch and notice how your body feels.",
    "Reflect on a goal you’re working towards and a step you can take today.",
    "Think of one thing you can do to improve your study habits.",
    "What is one way to calm your mind before an exam or stressful situation?",
    "Notice your thoughts without judgment for one minute.",
    "Think about a skill you want to develop. What’s a small step you can take?",
    "Write down a happy memory from this past month.",
    "Name one way you can take care of your mental health today.",
    "Focus on your breathing for 10 slow breaths.",
    "List three things you like about yourself.",
    "Think about a problem you’re facing. What is one thing you can control?",
    "Visualize yourself succeeding in something important to you.",
    "Write down something you can forgive yourself for today.",
    "Take a deep breath and notice the sensations in your hands.",
    "What is one way to be more present in your classes?",
    "Think about someone who inspires you. Why do they inspire you?",
    "Notice the tension in your jaw. Relax it as you breathe out.",
    "List three things that make your school environment positive.",
    "Take a moment to observe the sky or nature outside.",
    "Write down a compliment you received recently.",
    "Think about a healthy habit you can start today.",
    "Name one thing you enjoy doing after school.",
    "Reflect on a mistake you made and what you learned from it.",
    "Take a slow deep breath and feel it reach your stomach.",
    "List three things that make you feel safe at school.",
    "Think about a time you felt proud of a school achievement.",
    "Name one thing that calms you when you’re stressed.",
    "Take a moment to notice the colors around you.",
    "Write down one thing you can do to help a friend today.",
    "Think about a skill you improved recently and how it feels.",
    "Name three things that make you happy outside school.",
    "Take a deep breath and imagine a positive energy filling you.",
    "Write down one goal for the day and one step to achieve it.",
    "Notice the rhythm of your heartbeat for 30 seconds.",
    "Think about a teacher or mentor who supports you.",
    "Name one thing that makes your morning routine enjoyable.",
    "Write down one thing you’re grateful for about school.",
    "Reflect on a time you felt anxious. What helped you calm down?",
    "Take a mindful bite of food and notice its taste and texture.",
    "Think about a challenge you overcame this year.",
    "Name one thing you can do to improve your focus in class.",
    "Notice your posture and adjust it for comfort.",
    "Write a positive note to yourself and keep it in your pocket.",
    "Think about a friend who made you laugh recently.",
    "Name one thing you learned this week that excites you.",
    "Take three slow breaths and release any tension in your body.",
    "Write down one thing you’re proud of accomplishing today.",
    "Reflect on a time someone helped you and how it felt.",
    "Notice the sensation of your clothes against your skin.",
    "List three things that inspire you at school.",
    "Write down one way you can be more patient today.",
    "Think about a hobby that makes you happy.",
    "Name one quality you admire in yourself.",
    "Take a moment to imagine a peaceful place and visualize it.",
    "Write down one thing you can do to improve a friendship.",
    "Reflect on a recent compliment you gave or received.",
    "Name three things that make you feel confident.",
    "Think about a favorite teacher and why you like their class.",
    "Take a mindful walk and notice the details around you.",
    "Write down one thing that brings you comfort when stressed.",
    "Reflect on a time you helped someone feel better.",
    "Name one way you can improve your organization skills.",
    "Take a deep breath and feel your body relax.",
    "Write down one thing you can do to make your classroom more positive.",
    "Think about a personal value that guides your decisions.",
    "Name three things that make you feel motivated.",
    "Take a slow breath in, hold, and release stress as you exhale.",
    "Write down one thing you want to remember from today.",
    "Reflect on a recent challenge and a solution you found.",
    "Name one small act of kindness you can do today.",
    "Think about a success you had this week and celebrate it.",
    "Write down one positive thing you can say to yourself right now.",
    "Take a moment to notice the movement of your hands.",
    "List three things that make"
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
