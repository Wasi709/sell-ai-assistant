import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  final ThemeMode currentTheme;
  final Future<void> Function(ThemeMode) onThemeChanged;

  const SignupScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static const Color purple = Color(0xFF6C4DFF);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword =
        confirmPasswordController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully! 🎉',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = 'Could not create account.';

      switch (e.code) {
        case 'email-already-in-use':
          message =
              'An account already exists with this email.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'weak-password':
          message = 'Please choose a stronger password.';
          break;
      }

      _showMessage(message);
    } catch (e) {
      debugPrint('SIGNUP ERROR: $e');
      _showMessage(
        'Something went wrong. Please try again.',
      );
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
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            20,
            24,
            30,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 68,
                    width: 68,
                    decoration: BoxDecoration(
                      color: purple.withOpacity(0.13),
                      borderRadius:
                          BorderRadius.circular(21),
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: purple,
                      size: 34,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    'Create your SellAI account',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Create an account to save and manage your listings.',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 30),

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
                    keyboardType:
                        TextInputType.emailAddress,
                    textInputAction:
                        TextInputAction.next,
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
                    textInputAction:
                        TextInputAction.next,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'At least 6 characters',
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

                  const SizedBox(height: 20),

                  Text(
                    'Confirm Password',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller:
                        confirmPasswordController,
                    obscureText:
                        obscureConfirmPassword,
                    textInputAction:
                        TextInputAction.done,
                    onSubmitted: (_) => _signup(),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Re-enter your password',
                      prefixIcon: const Icon(
                        Icons.lock_reset_outlined,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword =
                                !obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      filled: true,
                      fillColor: fieldColor,
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final newMode =
                            theme.brightness ==
                                    Brightness.dark
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

                  const SizedBox(height: 15),

                  Center(
                    child: Text(
                      'By creating an account, you can save and manage your AI-generated listings.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 12,
                        height: 1.4,
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