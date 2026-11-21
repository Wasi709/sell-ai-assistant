import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'add_product_screen.dart';
import 'product_details_screen.dart';
import 'products_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final ThemeMode currentTheme;
  final Future<void> Function(ThemeMode) onThemeChanged;

  const HomeScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  static const Color primaryColor =
      Color(0xFF6C4DFF);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildHeader(context),

              const SizedBox(height: 30),

              Text(
                _getGreeting(),
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'Turn your products into better listings.',
                style: TextStyle(
                  fontSize: 15,
                  color: theme
                      .colorScheme
                      .onSurface
                      .withOpacity(0.60),
                ),
              ),

              const SizedBox(height: 25),

              _buildCreateListingCard(context),

              const SizedBox(height: 30),

              _buildQuickActions(context),

              const SizedBox(height: 30),

              _buildRecentListings(context),
            ],
          ),
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,

        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const ProductsScreen(),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(
                  currentTheme: currentTheme,
                  onThemeChanged:
                      onThemeChanged,
                ),
              ),
            );
          }
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.inventory_2_outlined,
            ),
            selectedIcon: Icon(
              Icons.inventory_2,
            ),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
            ),
            selectedIcon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // GREETING
  // ------------------------------------------------------------

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good morning 👋';
    }

    if (hour >= 12 && hour < 17) {
      return 'Good afternoon 👋';
    }

    if (hour >= 17 && hour < 21) {
      return 'Good evening 👋';
    }

    return 'Good night 🌙';
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius:
                BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 25,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'SellAI',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: theme
                      .colorScheme
                      .onSurface,
                ),
              ),

              Text(
                'AI-powered selling',
                style: TextStyle(
                  fontSize: 12,
                  color: theme
                      .colorScheme
                      .onSurface
                      .withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),

        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius:
                BorderRadius.circular(13),
            border: Border.all(
              color: theme.dividerColor
                  .withOpacity(0.15),
            ),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: theme
                .colorScheme
                .onSurface,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // CREATE LISTING CARD
  // ------------------------------------------------------------

  Widget _buildCreateListingCard(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6C4DFF),
            Color(0xFF8B6CFF),
          ],
        ),
        borderRadius:
            BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.18),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Create a listing with AI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Upload your product photos and let SellAI generate your selling content.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const AddProductScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons
                    .add_photo_alternate_outlined,
              ),
              label: const Text(
                'Add Product',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.white,
                foregroundColor:
                    primaryColor,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // QUICK ACTIONS
  // ------------------------------------------------------------

  Widget _buildQuickActions(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: theme
                .colorScheme
                .onSurface,
          ),
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: _quickAction(
                context: context,
                icon:
                    Icons.description_outlined,
                title: 'Listing',
                subtitle: 'Generate',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const AddProductScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _quickAction(
                context: context,
                icon:
                    Icons.video_library_outlined,
                title: 'Reels',
                subtitle: 'Create',
                onTap: () {
                  _showComingSoon(
                    context,
                    'Reels',
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _quickAction(
                context: context,
                icon:
                    Icons.campaign_outlined,
                title: 'Ads',
                subtitle: 'Write',
                onTap: () {
                  _showComingSoon(
                    context,
                    'Ads',
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // RECENT LISTINGS
  // ------------------------------------------------------------

  Widget _buildRecentListings(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Listings',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: theme
                    .colorScheme
                    .onSurface,
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ProductsScreen(),
                  ),
                );
              },
              child: const Text(
                'See all',
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        StreamBuilder<
            QuerySnapshot<
                Map<String, dynamic>>>(
          stream: FirebaseFirestore
              .instance
              .collection('listings')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .limit(3)
              .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Padding(
                padding:
                    EdgeInsets.symmetric(
                  vertical: 30,
                ),
                child: Center(
                  child:
                      CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return _errorCard(context);
            }

            final documents =
                snapshot.data?.docs ?? [];

            if (documents.isEmpty) {
              return _emptyRecentListings(
                context,
              );
            }

            return Column(
              children:
                  documents.map((document) {
                return _recentListingItem(
                  context: context,
                  productId: document.id,
                  listing:
                      document.data(),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // RECENT LISTING ITEM
  // ------------------------------------------------------------

  Widget _recentListingItem({
    required BuildContext context,
    required String productId,
    required Map<String, dynamic> listing,
  }) {
    final theme = Theme.of(context);

    final title =
        listing['title']
                ?.toString()
                .trim() ??
            '';

    final category =
        listing['category']
                ?.toString()
                .trim() ??
            '';

    final displayTitle =
        title.isEmpty
            ? 'Untitled Product'
            : title;

    final displaySubtitle =
        category.isEmpty
            ? 'AI generated listing'
            : category;

    return InkWell(
      borderRadius:
          BorderRadius.circular(17),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProductDetailsScreen(
              productId: productId,
              product: listing,
            ),
          ),
        );
      },

      child: Container(
        margin:
            const EdgeInsets.only(
          bottom: 10,
        ),
        padding:
            const EdgeInsets.all(14),
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
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color:
                    primaryColor.withOpacity(
                  0.10,
                ),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child: const Icon(
                Icons
                    .inventory_2_outlined,
                color: primaryColor,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    displayTitle,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w700,
                      color: theme
                          .colorScheme
                          .onSurface,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    displaySubtitle,
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
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: theme
                  .colorScheme
                  .onSurface
                  .withOpacity(0.45),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // EMPTY
  // ------------------------------------------------------------

  Widget _emptyRecentListings(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme
            .colorScheme
            .surface,
        borderRadius:
            BorderRadius.circular(17),
      ),
      child: const Column(
        children: [
          Icon(
            Icons
                .inventory_2_outlined,
            size: 40,
            color: primaryColor,
          ),

          SizedBox(height: 10),

          Text(
            'No listings yet',
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          SizedBox(height: 5),

          Text(
            'Create your first AI listing.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ERROR
  // ------------------------------------------------------------

  Widget _errorCard(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme
            .colorScheme
            .surface,
        borderRadius:
            BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          const Icon(
            Icons
                .error_outline_rounded,
            color: Colors.redAccent,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Unable to load recent listings.',
              style: TextStyle(
                color: theme
                    .colorScheme
                    .onSurface
                    .withOpacity(0.60),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // QUICK ACTION WIDGET
  // ------------------------------------------------------------

  Widget _quickAction({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(18),

      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 17,
        ),
        decoration: BoxDecoration(
          color: theme
              .colorScheme
              .surface,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: theme.dividerColor
                .withOpacity(0.08),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 26,
              color: primaryColor,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: TextStyle(
                fontWeight:
                    FontWeight.w700,
                color: theme
                    .colorScheme
                    .onSurface,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: theme
                    .colorScheme
                    .onSurface
                    .withOpacity(0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // COMING SOON
  // ------------------------------------------------------------

  void _showComingSoon(
    BuildContext context,
    String feature,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '$feature creation is coming soon 🚀',
        ),
      ),
    );
  }
}