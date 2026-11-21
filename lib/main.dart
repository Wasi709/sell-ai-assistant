import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'screens/auth_gate.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final preferences = await SharedPreferences.getInstance();

  final savedTheme = preferences.getString('themeMode');

  ThemeMode initialTheme;

  switch (savedTheme) {
    case 'dark':
      initialTheme = ThemeMode.dark;
      break;

    case 'system':
      initialTheme = ThemeMode.system;
      break;

    case 'light':
    default:
      initialTheme = ThemeMode.light;
  }

  runApp(
    SellAI(
      initialTheme: initialTheme,
    ),
  );
}

class SellAI extends StatefulWidget {
  final ThemeMode initialTheme;

  const SellAI({
    super.key,
    required this.initialTheme,
  });

  @override
  State<SellAI> createState() => _SellAIState();
}

class _SellAIState extends State<SellAI> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();

    _themeMode = widget.initialTheme;
  }

  Future<void> changeTheme(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });

    final preferences = await SharedPreferences.getInstance();

    String themeValue;

    switch (mode) {
      case ThemeMode.dark:
        themeValue = 'dark';
        break;

      case ThemeMode.system:
        themeValue = 'system';
        break;

      case ThemeMode.light:
        themeValue = 'light';
        break;
    }

    await preferences.setString(
      'themeMode',
      themeValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'SellAI',

      themeMode: _themeMode,

      // --------------------------------------------------------
      // LIGHT THEME
      // --------------------------------------------------------

      theme: ThemeData(
        useMaterial3: true,

        fontFamily: 'Arial',

        brightness: Brightness.light,

        scaffoldBackgroundColor:
            const Color(0xFFF7F7FA),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C4DFF),
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F7FA),
          foregroundColor: Colors.black,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),

        navigationBarTheme:
            const NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Color(0xFFE8E3FF),
        ),

        cardTheme: const CardThemeData(
          color: Colors.white,
        ),

        inputDecorationTheme:
            InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,

        fontFamily: 'Arial',

        brightness: Brightness.dark,

        scaffoldBackgroundColor:
            const Color(0xFF121212),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C4DFF),
          brightness: Brightness.dark,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),

        navigationBarTheme:
            const NavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          indicatorColor: Color(0xFF3D3470),
        ),

        cardTheme: const CardThemeData(
          color: Color(0xFF1E1E1E),
        ),

        inputDecorationTheme:
            InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      home: AuthGate(
        currentTheme: _themeMode,
        onThemeChanged: changeTheme,
      ),
    );
  }
}