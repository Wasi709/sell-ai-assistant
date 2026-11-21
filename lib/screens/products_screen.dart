import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'product_details_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  static const Color purple = Color(0xFF6C4DFF);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Products',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('listings')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: purple,
              ),
            );
          }

          if (snapshot.hasError) {
            return _errorState(context);
          }

          final products = snapshot.data?.docs ?? [];

          if (products.isEmpty) {
            return _emptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              30,
            ),
            itemCount: products.length,

            itemBuilder: (context, index) {
              final document = products[index];

              return _ProductCard(
                productId: document.id,
                product: document.data(),
              );
            },
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // ERROR STATE
  // ------------------------------------------------------------

  Widget _errorState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 45,
              color: Colors.grey,
            ),

            const SizedBox(height: 14),

            Text(
              'Could not load products',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _emptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 85,
              width: 85,

              decoration: BoxDecoration(
                color: purple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(25),
              ),

              child: const Icon(
                Icons.inventory_2_outlined,
                size: 42,
                color: purple,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'No products yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your saved listings will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },

              icon: const Icon(Icons.add),

              label: const Text(
                'Create Listing',
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
                elevation: 0,

                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PRODUCT CARD
// ============================================================

class _ProductCard extends StatelessWidget {
  final String productId;
  final Map<String, dynamic> product;

  const _ProductCard({
    required this.productId,
    required this.product,
  });

  static const Color purple = Color(0xFF6C4DFF);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final title =
        product['title']?.toString().trim() ?? '';

    final description =
        product['description']?.toString().trim() ?? '';

    final category =
        product['category']?.toString().trim() ?? '';

    final price =
        product['price']?.toString().trim() ?? '';

    final displayTitle =
        title.isEmpty ? 'Untitled Product' : title;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),

        boxShadow: theme.brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ----------------------------------------------------
          // TOP ROW
          // ----------------------------------------------------

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Container(
                height: 52,
                width: 52,

                decoration: BoxDecoration(
                  color: purple.withOpacity(0.09),
                  borderRadius:
                      BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: purple,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      displayTitle,

                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,

                      style: theme.textTheme.bodyLarge
                          ?.copyWith(
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    if (category.isNotEmpty) ...[
                      const SizedBox(height: 5),

                      Text(
                        category,

                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: purple,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 5),

              PopupMenuButton<String>(
                tooltip: 'More options',

                onSelected: (value) {
                  if (value == 'edit') {
                    _editProduct(context);
                  }

                  if (value == 'delete') {
                    _deleteProduct(context);
                  }
                },

                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 'edit',

                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 19,
                          ),

                          SizedBox(width: 10),

                          Text('Edit'),
                        ],
                      ),
                    ),

                    const PopupMenuItem(
                      value: 'delete',

                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 19,
                            color: Colors.red,
                          ),

                          SizedBox(width: 10),

                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),

          // ----------------------------------------------------
          // DESCRIPTION
          // ----------------------------------------------------

          if (description.isNotEmpty) ...[
            const SizedBox(height: 14),

            Text(
              description,

              maxLines: 3,
              overflow: TextOverflow.ellipsis,

              style: theme.textTheme.bodyMedium
                  ?.copyWith(
                color: theme.textTheme.bodyMedium
                    ?.color
                    ?.withOpacity(0.65),

                fontSize: 13.5,
                height: 1.45,
              ),
            ),
          ],

          const SizedBox(height: 15),

          // ----------------------------------------------------
          // PRICE + DETAILS
          // ----------------------------------------------------

          Row(
            children: [
              if (price.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),

                  decoration: BoxDecoration(
                    color: purple.withOpacity(0.08),
                    borderRadius:
                        BorderRadius.circular(9),
                  ),

                  child: Text(
                    'Rs. $price',

                    style: const TextStyle(
                      color: purple,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),

              const Spacer(),

              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailsScreen(
                        productId: productId,
                        product: product,
                      ),
                    ),
                  );
                },

                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 17,
                ),

                label: const Text(
                  'View Details',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // EDIT PRODUCT
  // ==========================================================

  void _editProduct(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final titleController =
        TextEditingController(
      text: product['title']?.toString() ?? '',
    );

    final descriptionController =
        TextEditingController(
      text:
          product['description']?.toString() ?? '',
    );

    final categoryController =
        TextEditingController(
      text:
          product['category']?.toString() ?? '',
    );

    final priceController =
        TextEditingController(
      text: product['price']?.toString() ?? '',
    );

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (sheetContext) {
        final sheetTheme =
            Theme.of(sheetContext);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext)
                .viewInsets
                .bottom,
          ),

          child: Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              25,
            ),

            decoration: BoxDecoration(
              color: sheetTheme
                  .scaffoldBackgroundColor,

              borderRadius:
                  const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // ------------------------------------------
                  // HEADER
                  // ------------------------------------------

                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Edit Product',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.pop(
                            sheetContext,
                          );
                        },

                        icon: const Icon(
                          Icons.close_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ------------------------------------------
                  // FIELDS
                  // ------------------------------------------

                  _EditField(
                    controller:
                        titleController,
                    label: 'Title',
                  ),

                  _EditField(
                    controller:
                        descriptionController,
                    label: 'Description',
                    maxLines: 4,
                  ),

                  _EditField(
                    controller:
                        categoryController,
                    label: 'Category',
                  ),

                  _EditField(
                    controller:
                        priceController,
                    label: 'Price',
                    keyboardType:
                        TextInputType.number,
                  ),

                  const SizedBox(height: 5),

                  // ------------------------------------------
                  // SAVE BUTTON
                  // ------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: ElevatedButton(
                      onPressed: () async {
                        final title =
                            titleController.text
                                .trim();

                        if (title.isEmpty) {
                          ScaffoldMessenger.of(
                            sheetContext,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Product title cannot be empty.',
                              ),
                            ),
                          );

                          return;
                        }

                        try {
                          await FirebaseFirestore
                              .instance
                              .collection(
                                'listings',
                              )
                              .doc(productId)
                              .update({
                            'title': title,

                            'description':
                                descriptionController
                                    .text
                                    .trim(),

                            'category':
                                categoryController
                                    .text
                                    .trim(),

                            'price':
                                priceController
                                    .text
                                    .trim(),

                            'updatedAt':
                                FieldValue
                                    .serverTimestamp(),
                          });

                          if (!sheetContext.mounted) {
                            return;
                          }

                          Navigator.pop(
                            sheetContext,
                          );

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Product updated successfully.',
                              ),
                            ),
                          );
                        } catch (e) {
                          if (!sheetContext.mounted) {
                            return;
                          }

                          ScaffoldMessenger.of(
                            sheetContext,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Could not update product.',
                              ),
                            ),
                          );

                          debugPrint(
                            'UPDATE PRODUCT ERROR: $e',
                          );
                        }
                      },

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor:
                            Colors.white,
                        elevation: 0,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                      ),

                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // DELETE PRODUCT
  // ==========================================================

  void _deleteProduct(BuildContext context) {
    final title =
        product['title']?.toString().trim() ?? '';

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete product?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),

          content: Text(
            'Are you sure you want to delete '
            '"${title.isEmpty ? 'this product' : title}"?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text(
                'Cancel',
              ),
            ),

            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                try {
                  await FirebaseFirestore
                      .instance
                      .collection('listings')
                      .doc(productId)
                      .delete();

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Product deleted.',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Could not delete product.',
                      ),
                    ),
                  );

                  debugPrint(
                    'DELETE PRODUCT ERROR: $e',
                  );
                }
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
  }
}

// ============================================================
// EDIT FIELD
// ============================================================

class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final TextInputType? keyboardType;

  const _EditField({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),

      child: TextField(
        controller: controller,

        maxLines: maxLines,

        keyboardType: keyboardType,

        decoration: InputDecoration(
          labelText: label,

          filled: true,

          fillColor: colors.surface,

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(14),

            borderSide: BorderSide.none,
          ),

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}