import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/index.dart';
import 'package:myapp/chatroom.dart';
import 'package:myapp/resources.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Light Theme: Calming Blue
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color.fromARGB(255, 111, 176, 179), // Pale Blue
    scaffoldBackgroundColor: const Color(0xFFF1FAEE), // Mint Cream
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 125, 193, 196),
      onPrimary: Color(0xFF1D3557), // Dark Slate Blue
      secondary: Color(0xFF457B9D), // Desaturated Blue
      onSecondary: Color(0xFF1D3557),
      error: Colors.red,
      onError: Colors.white,
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1D3557),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFA8DADC),
      foregroundColor: Color(0xFF1D3557),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF1D3557)),
  );

  // Dark Theme: Deep Calming Blue
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF457B9D), // Desaturated Blue
    scaffoldBackgroundColor: const Color(0xFF1D3557), // Dark Slate Blue
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 21, 44, 58),
      secondary: Color(0xFFA8DADC),
      surface: Color(0xFF457B9D),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF457B9D),
      foregroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quit Quest',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode:
          ThemeMode.system, // Automatically switch based on system settings
      initialRoute: '/',
      routes: {
        '/': (context) => SignUpScreen(),
        '/dashboard': (context) => Dashboard(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/chatroom': (context) => Chatroom(),
        '/resources': (context) => Resources(),
      },
    );
  }
}
