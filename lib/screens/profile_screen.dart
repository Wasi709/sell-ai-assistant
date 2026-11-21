import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final ThemeMode currentTheme;
  final Future<void> Function(ThemeMode)
      onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  static const Color primaryColor =
      Color(0xFF6C4DFF);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final user =
        FirebaseAuth.instance.currentUser;

    final email =
        user?.email ?? 'No email available';

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),
        child: Column(
          children: [
            const SizedBox(height: 15),

            // --------------------------------------------------
            // PROFILE HEADER
            // --------------------------------------------------

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: theme
                    .colorScheme
                    .surface,
                borderRadius:
                    BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Container(
                    height: 82,
                    width: 82,
                    decoration:
                        BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          BorderRadius.circular(
                        26,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    'SellAI User',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight:
                          FontWeight.w800,
                      color: theme
                          .colorScheme
                          .onSurface,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    email,
                    style: TextStyle(
                      color: theme
                          .colorScheme
                          .onSurface
                          .withOpacity(0.55),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --------------------------------------------------
            // ACCOUNT
            // --------------------------------------------------

            _sectionTitle(
              context,
              'Account',
            ),

            const SizedBox(height: 10),

            _profileOption(
              context: context,
              icon:
                  Icons.email_outlined,
              title: 'Email',
              subtitle: email,
              onTap: null,
            ),

            _profileOption(
              context: context,
              icon:
                  Icons.lock_outline_rounded,
              title: 'Password',
              subtitle:
                  'Change your password',
              onTap: () {
                _changePassword(
                  context,
                  email,
                );
              },
            ),

            const SizedBox(height: 20),

            // --------------------------------------------------
            // APP
            // --------------------------------------------------

            _sectionTitle(
              context,
              'App',
            ),

            const SizedBox(height: 10),

            _profileOption(
              context: context,
              icon:
                  Icons.dark_mode_outlined,
              title: 'Appearance',
              subtitle:
                  _themeName(currentTheme),
              onTap: () {
                _showThemeDialog(context);
              },
            ),

            _profileOption(
              context: context,
              icon:
                  Icons.info_outline_rounded,
              title: 'About SellAI',
              subtitle:
                  'AI-powered product listings',
              onTap: () {
                _showAbout(context);
              },
            ),

            _profileOption(
              context: context,
              icon:
                  Icons.logout_rounded,
              title: 'Log out',
              subtitle:
                  'Sign out from your account',
              iconColor:
                  Colors.redAccent,
              onTap: () {
                _logout(context);
              },
            ),

            const SizedBox(height: 25),

            Text(
              'SellAI',
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    FontWeight.w700,
                color: theme
                    .colorScheme
                    .onSurface
                    .withOpacity(0.50),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'AI-powered selling made simple.',
              style: TextStyle(
                fontSize: 12,
                color: theme
                    .colorScheme
                    .onSurface
                    .withOpacity(0.50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTION TITLE
  // ------------------------------------------------------------

  Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    final theme = Theme.of(context);

    return Align(
      alignment:
          Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight:
              FontWeight.w800,
          color: theme
              .colorScheme
              .onSurface,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PROFILE OPTION
  // ------------------------------------------------------------

  Widget _profileOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    Color iconColor = primaryColor,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: theme
            .colorScheme
            .surface,
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color: theme.dividerColor
              .withOpacity(0.08),
        ),
      ),
      child: ListTile(
        onTap: onTap,

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),

        leading: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color:
                iconColor.withOpacity(
              0.09,
            ),
            borderRadius:
                BorderRadius.circular(
              13,
            ),
          ),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),

        title: Text(
          title,
          style: TextStyle(
            fontWeight:
                FontWeight.w700,
            color: theme
                .colorScheme
                .onSurface,
          ),
        ),

        subtitle: Padding(
          padding:
              const EdgeInsets.only(
            top: 3,
          ),
          child: Text(
            subtitle,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: theme
                  .colorScheme
                  .onSurface
                  .withOpacity(0.55),
            ),
          ),
        ),

        trailing: onTap != null
            ? Icon(
                Icons
                    .chevron_right_rounded,
                color: theme
                    .colorScheme
                    .onSurface
                    .withOpacity(0.45),
              )
            : null,
      ),
    );
  }

  // ------------------------------------------------------------
  // THEME NAME
  // ------------------------------------------------------------

  String _themeName(
    ThemeMode mode,
  ) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light mode';

      case ThemeMode.dark:
        return 'Dark mode';

      case ThemeMode.system:
        return 'System default';
    }
  }

  // ------------------------------------------------------------
  // THEME DIALOG
  // ------------------------------------------------------------

  void _showThemeDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Appearance',
            style: TextStyle(
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                value:
                    ThemeMode.light,
                groupValue:
                    currentTheme,
                title:
                    const Text('Light'),
                subtitle:
                    const Text(
                  'Use light theme',
                ),
                secondary:
                    const Icon(
                  Icons
                      .light_mode_outlined,
                ),
                onChanged:
                    (value) {
                  if (value == null) {
                    return;
                  }

                  onThemeChanged(value);

                  Navigator.pop(
                    dialogContext,
                  );
                },
              ),

              RadioListTile<ThemeMode>(
                value:
                    ThemeMode.dark,
                groupValue:
                    currentTheme,
                title:
                    const Text('Dark'),
                subtitle:
                    const Text(
                  'Use dark theme',
                ),
                secondary:
                    const Icon(
                  Icons
                      .dark_mode_outlined,
                ),
                onChanged:
                    (value) {
                  if (value == null) {
                    return;
                  }

                  onThemeChanged(value);

                  Navigator.pop(
                    dialogContext,
                  );
                },
              ),

              RadioListTile<ThemeMode>(
                value:
                    ThemeMode.system,
                groupValue:
                    currentTheme,
                title:
                    const Text(
                  'System default',
                ),
                subtitle:
                    const Text(
                  'Follow device settings',
                ),
                secondary:
                    const Icon(
                  Icons
                      .settings_outlined,
                ),
                onChanged:
                    (value) {
                  if (value == null) {
                    return;
                  }

                  onThemeChanged(value);

                  Navigator.pop(
                    dialogContext,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // PASSWORD
  // ------------------------------------------------------------

  Future<void> _changePassword(
    BuildContext context,
    String email,
  ) async {
    if (email ==
        'No email available') {
      _showMessage(
        context,
        'No email is associated with this account.',
      );
      return;
    }

    try {
      await FirebaseAuth
          .instance
          .sendPasswordResetEmail(
        email: email,
      );

      if (!context.mounted) {
        return;
      }

      _showMessage(
        context,
        'Password reset email sent. Check your inbox.',
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      _showMessage(
        context,
        'Could not send password reset email.',
      );
    }
  }

  // ------------------------------------------------------------
  // LOGOUT
  // ------------------------------------------------------------

  Future<void> _logout(
    BuildContext context,
  ) async {
    final shouldLogout =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Log out?',
            style: TextStyle(
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          content: const Text(
            'Are you sure you want to log out of SellAI?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child:
                  const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Log out',
                style: TextStyle(
                  color:
                      Colors.redAccent,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    try {
      await FirebaseAuth
          .instance
          .signOut();

      if (!context.mounted) {
        return;
      }

      _showMessage(
        context,
        'Logged out successfully.',
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      _showMessage(
        context,
        'Could not log out.',
      );
    }
  }

  // ------------------------------------------------------------
  // ABOUT
  // ------------------------------------------------------------

  void _showAbout(
    BuildContext context,
  ) {
    showAboutDialog(
      context: context,

      applicationName: 'SellAI',

      applicationVersion: '1.0.0',

      applicationIcon:
          Container(
        height: 45,
        width: 45,
        decoration:
            BoxDecoration(
          color: primaryColor,
          borderRadius:
              BorderRadius.circular(
            13,
          ),
        ),
        child: const Icon(
          Icons.auto_awesome,
          color: Colors.white,
        ),
      ),

      children: const [
        Text(
          'SellAI helps sellers create better product listings using AI-generated titles, descriptions, categories and pricing suggestions.',
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // MESSAGE
  // ------------------------------------------------------------

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}