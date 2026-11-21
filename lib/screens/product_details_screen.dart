import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> product;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  static const Color purple = Color(0xFF6C4DFF);

  late Map<String, dynamic> product;

  @override
  void initState() {
    super.initState();

    product = Map<String, dynamic>.from(widget.product);
  }

  String _text(String key) {
    return product[key]?.toString().trim() ?? '';
  }

  List<String> _list(String key) {
    final value = product[key];

    if (value is List) {
      return value
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList();
    }

    return [];
  }

  Future<void> _deleteProduct() async {
    final title = _text('title');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete product?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to delete '
            '"${title.isEmpty ? 'this product' : title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('listings')
          .doc(widget.productId)
          .delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Product deleted successfully',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('DELETE PRODUCT ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not delete product',
          ),
        ),
      );
    }
  }

  void _showFullText(
    String title,
    String content,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);

        return Container(
          height: MediaQuery.of(sheetContext).size.height * 0.75,
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 45,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface
                        .withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    IconData? icon,
  }) {
    if (value.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: purple.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: purple,
                size: 21,
              ),
            ),

            const SizedBox(width: 13),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: purple,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 12,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = _text('title');
    final description = _text('description');
    final category = _text('category');
    final price = _text('price');
    final urduTitle = _text('urduTitle');
    final urduDescription = _text('urduDescription');

    final features = _list('features');
    final tags = _list('tags');

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Product Details',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Delete',
            onPressed: _deleteProduct,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          35,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------
            // MAIN PRODUCT CARD
            // --------------------------------------------------

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6C4DFF),
                    Color(0xFF8B6CFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    title.isEmpty
                        ? 'Untitled Product'
                        : title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),

                  if (category.isNotEmpty) ...[
                    const SizedBox(height: 8),

                    Text(
                      category,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],

                  if (price.isNotEmpty) ...[
                    const SizedBox(height: 18),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.16),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Rs. $price',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --------------------------------------------------
            // DESCRIPTION
            // --------------------------------------------------

            if (description.isNotEmpty) ...[
              _sectionTitle('Description'),

              _infoCard(
                title: 'Product Description',
                value: description,
                icon: Icons.description_outlined,
              ),
            ],

            // --------------------------------------------------
            // FEATURES
            // --------------------------------------------------

            if (features.isNotEmpty) ...[
              _sectionTitle('Features'),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: features.map((feature) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons
                                .check_circle_rounded,
                            color: purple,
                            size: 19,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              feature,
                              style:
                                  const TextStyle(
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            // --------------------------------------------------
            // TAGS
            // --------------------------------------------------

            if (tags.isNotEmpty) ...[
              _sectionTitle('Tags'),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((tag) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: purple.withOpacity(0.10),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(
                        color: purple,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            // --------------------------------------------------
            // URDU LISTING
            // --------------------------------------------------

            if (urduTitle.isNotEmpty ||
                urduDescription.isNotEmpty) ...[
              _sectionTitle('Urdu Listing'),

              if (urduTitle.isNotEmpty)
                _infoCard(
                  title: 'Urdu Title',
                  value: urduTitle,
                  icon: Icons.translate_rounded,
                ),

              if (urduDescription.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _showFullText(
                      'Urdu Description',
                      urduDescription,
                    );
                  },
                  child: _infoCard(
                    title: 'Urdu Description',
                    value: urduDescription,
                    icon: Icons.language_rounded,
                  ),
                ),
            ],

            const SizedBox(height: 10),

            // --------------------------------------------------
            // DELETE BUTTON
            // --------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _deleteProduct,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
                label: const Text(
                  'Delete Product',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.red.withOpacity(0.25),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
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