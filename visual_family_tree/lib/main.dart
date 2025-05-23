import 'package:flutter/material.dart';
import './widgets/family_canvas.dart'; // Import FamilyCanvas

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visual Family Tree',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, 
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey, 
          secondary: Colors.amber, // A nice accent color
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardTheme(
          elevation: 2.0, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          // backgroundColor: Colors.blueGrey[700], // Example for further customization
        ),
        appBarTheme: AppBarTheme(
          // backgroundColor: Colors.blueGrey[600], // Example for further customization
          // elevation: 2.0,
        ),
        useMaterial3: true,
      ),
      home: FamilyCanvas(), // FamilyCanvas will provide its own Scaffold
    );
  }
}
