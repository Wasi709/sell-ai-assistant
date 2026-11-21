import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListingResultScreen extends StatefulWidget {
  final Map<String, dynamic> listing;
  final List<File> images;

  const ListingResultScreen({
    super.key,
    required this.listing,
    this.images = const [],
  });

  @override
  State<ListingResultScreen> createState() =>
      _ListingResultScreenState();
}

class _ListingResultScreenState extends State<ListingResultScreen> {
  static const Color purple = Color(0xFF6C4DFF);

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController categoryController;
  late final TextEditingController priceController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.listing['title']?.toString() ?? '',
    );

    descriptionController = TextEditingController(
      text: widget.listing['description']?.toString() ?? '',
    );

    categoryController = TextEditingController(
      text: widget.listing['category']?.toString() ?? '',
    );

    priceController = TextEditingController(
      text: widget.listing['suggestedPrice']?.toString() ??
          widget.listing['price']?.toString() ??
          '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _saveListing() async {
    if (isSaving) return;

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final category = categoryController.text.trim();
    final price = priceController.text.trim();

    if (title.isEmpty) {
      _showMessage('Please enter a product title.');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final features = _getList('features');
      final tags = _getList('tags');

      await FirebaseFirestore.instance.collection('listings').add({
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'features': features,
        'tags': tags,
        'urduTitle':
            widget.listing['urduTitle']?.toString() ?? '',
        'urduDescription':
            widget.listing['urduDescription']?.toString() ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listing saved successfully! 🎉'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('SAVE LISTING ERROR: $e');

      if (!mounted) return;

      _showMessage(
        'Could not save listing. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  List<String> _getList(String key) {
    final value = widget.listing[key];

    if (value is List) {
      return value
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList();
    }

    return [];
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

  Widget _field({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark
                ? const Color(0xFF1E1E1E)
                : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: purple,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
  }) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: purple,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final features = _getList('features');
    final tags = _getList('tags');

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: isSaving
              ? null
              : () => Navigator.pop(context),
        ),
        title: const Text(
          'AI Listing',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------
            // PRODUCT IMAGES
            // --------------------------------------------------

            if (widget.images.isNotEmpty) ...[
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.images.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        widget.images[index],
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),
            ],

            // --------------------------------------------------
            // AI READY CARD
            // --------------------------------------------------

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6C4DFF),
                    Color(0xFF8B6CFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 30,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Your AI-generated listing is ready!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // --------------------------------------------------
            // REVIEW
            // --------------------------------------------------

            const Text(
              'Review your listing',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'You can edit anything before saving.',
              style: TextStyle(
                color: theme.colorScheme.onSurface
                    .withOpacity(0.55),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 22),

            // --------------------------------------------------
            // TITLE
            // --------------------------------------------------

            _field(
              label: 'Title',
              controller: titleController,
            ),

            const SizedBox(height: 20),

            // --------------------------------------------------
            // DESCRIPTION
            // --------------------------------------------------

            _field(
              label: 'Description',
              controller: descriptionController,
              maxLines: 6,
            ),

            const SizedBox(height: 20),

            // --------------------------------------------------
            // CATEGORY
            // --------------------------------------------------

            _field(
              label: 'Category',
              controller: categoryController,
            ),

            const SizedBox(height: 20),

            // --------------------------------------------------
            // PRICE
            // --------------------------------------------------

            _field(
              label: 'Suggested Price',
              controller: priceController,
              keyboardType: TextInputType.number,
            ),

            // --------------------------------------------------
            // FEATURES
            // --------------------------------------------------

            if (features.isNotEmpty) ...[
              const SizedBox(height: 25),

              const Text(
                'Features',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              _infoCard(
                title: 'AI detected features',
                value: features
                    .map((item) => '• $item')
                    .join('\n'),
              ),
            ],

            // --------------------------------------------------
            // TAGS
            // --------------------------------------------------

            if (tags.isNotEmpty) ...[
              const SizedBox(height: 5),

              _infoCard(
                title: 'Tags',
                value: tags
                    .map((item) => '#$item')
                    .join('   '),
              ),
            ],

            const SizedBox(height: 20),

            // --------------------------------------------------
            // SAVE BUTTON
            // --------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: isSaving
                    ? null
                    : _saveListing,
                icon: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.save_outlined,
                      ),
                label: Text(
                  isSaving
                      ? 'Saving...'
                      : 'Save Listing',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      Colors.grey.shade700,
                  disabledForegroundColor:
                      Colors.grey.shade400,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}