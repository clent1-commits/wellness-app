import 'dart:math';
import 'package:flutter/material.dart';

class MotivationalQuotesScreen extends StatefulWidget {
  @override
  _MotivationalQuotesScreenState createState() =>
      _MotivationalQuotesScreenState();
}

class _MotivationalQuotesScreenState extends State<MotivationalQuotesScreen>
    with SingleTickerProviderStateMixin {
  List<String> _quotes = [
    "Believe you can and you're halfway there.",
    "Every day is a second chance.",
    "You are stronger than you think.",
    "Do something today that your future self will thank you for.",
    "Small steps every day lead to big changes.",
    "The best way to get started is to quit talking and begin doing.",
    "Don’t watch the clock; do what it does. Keep going.",
    "Believe in yourself and all that you are.",
    "The only limit to our realization of tomorrow is our doubts of today.",
    "Push yourself, because no one else is going to do it for you.",
    "Your mind is a powerful thing. When you fill it with positive thoughts, your life will start to change.",
    "Don’t wait for opportunity. Create it.",
    "Success is not final, failure is not fatal: It is the courage to continue that counts.",
    "Start where you are. Use what you have. Do what you can.",
    "You don’t have to be great to start, but you have to start to be great.",
    "Great things never come from comfort zones.",
    "Wake up with determination. Go to bed with satisfaction.",
    "Dream it. Wish it. Do it.",
    "The harder you work for something, the greater you’ll feel when you achieve it.",
    "Don’t stop when you’re tired. Stop when you’re done.",
    "Little by little, day by day, what is meant for you will find its way.",
    "Do something today that scares you.",
    "Don’t limit your challenges. Challenge your limits.",
    "You are capable of more than you know.",
    "Act as if what you do makes a difference. It does.",
    "It always seems impossible until it’s done.",
    "Focus on the step in front of you, not the whole staircase.",
    "Motivation is what gets you started. Habit is what keeps you going.",
    "Believe in your infinite potential.",
    "Your only limit is your mind.",
    "Don’t wait for the perfect moment. Take the moment and make it perfect.",
    "You are your only competition.",
    "Keep going. Be all in.",
    "Push harder than yesterday if you want a different tomorrow.",
    "Don’t let yesterday take up too much of today.",
    "Be stronger than your strongest excuse.",
    "Difficult roads often lead to beautiful destinations.",
    "The best time to plant a tree was 20 years ago. The second best time is now.",
    "Don’t quit. Suffer now and live the rest of your life as a champion.",
    "The secret of getting ahead is getting started.",
    "Challenges are what make life interesting.",
    "Turn your wounds into wisdom.",
    "You are braver than you believe, stronger than you seem, and smarter than you think.",
    "Don’t let what you cannot do interfere with what you can do.",
    "It does not matter how slowly you go as long as you do not stop.",
    "Your future is created by what you do today, not tomorrow.",
    "The pain you feel today will be the strength you feel tomorrow.",
    "Success doesn’t just find you. You have to go out and get it.",
    "Hustle in silence and let your success make the noise.",
    "A little progress each day adds up to big results.",
    "The only way to achieve the impossible is to believe it is possible.",
    "Stop doubting yourself. Work hard and make it happen.",
    "You are stronger than any excuse.",
    "Mistakes are proof that you are trying.",
    "The struggle you’re in today is developing the strength you need tomorrow.",
    "When you feel like quitting, think about why you started.",
    "Do it with passion or not at all.",
    "Your life does not get better by chance, it gets better by change.",
    "The key to success is to focus on goals, not obstacles.",
    "Don’t let fear decide your future.",
    "Make your life a masterpiece.",
    "Set goals. Stay quiet about them. Smash them.",
    "Your limitation—it’s only your imagination.",
    "Dream bigger. Do bigger.",
    "Stay positive, work hard, make it happen.",
    "The expert in anything was once a beginner.",
    "Discipline is choosing between what you want now and what you want most.",
    "Your attitude determines your direction.",
    "You don’t have to see the whole staircase, just take the first step.",
    "Failure is the condiment that gives success its flavor.",
    "Sometimes later becomes never. Do it now.",
    "Don’t count the days. Make the days count.",
    "Good things come to those who hustle.",
    "Don’t let small minds convince you that your dreams are too big.",
    "Act now. The future depends on it.",
    "Success is the sum of small efforts repeated day in and day out.",
    "Make each day your masterpiece.",
    "Your potential is endless.",
    "Be the energy you want to attract.",
    "Push yourself, because no one else is going to do it for you.",
    "The best way to predict your future is to create it.",
    "Work until your idols become your rivals.",
    "Turn your can’ts into cans and your dreams into plans.",
    "Do what you love and the money will follow.",
    "Stay patient and trust your journey.",
    "Be fearless in the pursuit of what sets your soul on fire.",
    "Everything you’ve ever wanted is on the other side of fear.",
    "Success is not for the lazy.",
    "Your mind is a garden. Your thoughts are the seeds. You can grow flowers or weeds.",
    "The difference between ordinary and extraordinary is that little extra.",
    "It’s going to be hard, but hard does not mean impossible.",
    "Hustle until your haters ask if you’re hiring.",
    "Opportunities don’t happen, you create them.",
    "Don’t wish for it, work for it.",
    "Sometimes the smallest step in the right direction ends up being the biggest step of your life.",
    "Don’t be pushed around by the fears in your mind. Be led by the dreams in your heart.",
    "Your dreams don’t have an expiration date. Take a deep breath and try again.",
    "The harder you work, the luckier you get.",
    "The way to get started is to quit talking and begin doing.",
    "Success is walking from failure to failure with no loss of enthusiasm.",
    "Believe in yourself and all that you are capable of.",
    "Stay focused, go after your dreams, and keep moving toward your goals.",
    "Your only limit is you.",
    "Work hard in silence. Let your success be your noise.",
    "Keep your face always toward the sunshine—and shadows will fall behind you.",
    "Do what you can, with what you have, where you are.",
    "The best revenge is massive success.",
    "Start each day with a positive thought.",
    "Be the change you wish to see in the world.",
    "Success usually comes to those who are too busy to be looking for it.",
    "Don’t let anyone dull your sparkle.",
    "Rise up and attack the day with enthusiasm.",
    "Dreams don’t work unless you do.",
    "Push through the pain, take the risk, and live fully."
  ];

  String _currentQuote = "";
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _generateQuote();

    // Breathing animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateQuote() {
    final rand = Random();
    setState(() {
      _currentQuote = _quotes[rand.nextInt(_quotes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade700,
        title: Text("Motivational Quotes"),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade700, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: screenWidth * 0.9,
                  padding: EdgeInsets.all(16),
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
                    _currentQuote,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateQuote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple.shade700,
                  side: BorderSide(color: Colors.purple.shade700),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text("New Quote"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
