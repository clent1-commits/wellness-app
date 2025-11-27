import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData purpleMindfulnessTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.deepPurple, // Main color
    scaffoldBackgroundColor: Color(0xFFF5F0FA), // Light background color

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepPurple, // AppBar color
      foregroundColor: Colors.white, // Text color in AppBar
      elevation: 4, // AppBar shadow
    ),

    textTheme: TextTheme(
      // Body text style
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Colors.black87, // Main body text color
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Colors.black87, // Smaller body text color
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold, // Bold headline text
        color: Colors.deepPurple, // Headline color
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold, // Smaller headline text
        color: Colors.deepPurple, // Headline color
      ),
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: Colors.deepPurple, // Default button color
      textTheme: ButtonTextTheme.primary, // Button text color
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple, // Use backgroundColor instead of primary
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners for buttons
        ),
        textStyle: TextStyle(
          color: Colors.white, // Text color inside button
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Rounded input fields
      ),
      labelStyle: TextStyle(
        color: Colors.deepPurple, // Label text color
      ),
      hintStyle: TextStyle(
        color: Colors.grey, // Hint text color
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple, // FAB color
      foregroundColor: Colors.white, // FAB icon color
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white, // Bottom nav bar background color
      selectedItemColor: Colors.deepPurple, // Selected item color
      unselectedItemColor: Colors.grey, // Unselected item color
    ),
  );
}
