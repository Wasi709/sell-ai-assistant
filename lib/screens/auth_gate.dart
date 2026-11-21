import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  final ThemeMode currentTheme;
  final Future<void> Function(ThemeMode) onThemeChanged;

  const AuthGate({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C4DFF),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return HomeScreen(
            currentTheme: currentTheme,
            onThemeChanged: onThemeChanged,
          );
        }

        return LoginScreen(
          currentTheme: currentTheme,
          onThemeChanged: onThemeChanged,
        );
      },
    );
  }
}