import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final ThemeMode currentTheme;
  final Future<void> Function(ThemeMode) onThemeChanged;

  const LoginScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color purple = Color(0xFF6C4DFF);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter your email and password.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed. Please try again.';

      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          message = 'Invalid email or password.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'user-disabled':
          message = 'This account has been disabled.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
      }

      _showMessage(message);
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final fieldColor = isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    final secondaryText =
        theme.colorScheme.onSurface.withOpacity(0.58);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 82,
                      width: 82,
                      decoration: BoxDecoration(
                        color: purple.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: purple,
                        size: 42,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Center(
                    child: Text(
                      'Welcome back',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      'Sign in to continue using SellAI',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  Text(
                    'Email',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                      ),
                      filled: true,
                      fillColor: fieldColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Password',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _login(),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      filled: true,
                      fillColor: fieldColor,
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: secondaryText,
                        ),
                      ),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SignupScreen(
                                      currentTheme:
                                          widget.currentTheme,
                                      onThemeChanged:
                                          widget.onThemeChanged,
                                    ),
                                  ),
                                );
                              },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: purple,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // THEME BUTTON
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final newMode =
                            theme.brightness == Brightness.dark
                                ? ThemeMode.light
                                : ThemeMode.dark;

                        widget.onThemeChanged(newMode);
                      },
                      icon: Icon(
                        isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                      ),
                      label: Text(
                        isDark
                            ? 'Switch to Light Mode'
                            : 'Switch to Dark Mode',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}