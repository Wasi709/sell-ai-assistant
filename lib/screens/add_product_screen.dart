import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'listing_result_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ImagePicker picker = ImagePicker();
  final List<XFile> images = [];

  bool isGenerating = false;
  String selectedLanguage = 'English + Urdu';

  static const Color purple = Color(0xFF6C4DFF);

  Future<void> takePhoto() async {
    if (images.length >= 3) {
      showMessage('You can upload up to 3 photos.');
      return;
    }

    if (isGenerating) return;

    try {
      final photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo == null) return;

      setState(() {
        images.add(photo);
      });
    } catch (e) {
      debugPrint('Camera error: $e');
      showMessage('Could not open camera.');
    }
  }

  Future<void> pickImages() async {
    if (images.length >= 3) {
      showMessage('You can upload up to 3 photos.');
      return;
    }

    if (isGenerating) return;

    try {
      final pickedImages = await picker.pickMultiImage(
        imageQuality: 85,
      );

      if (pickedImages.isEmpty) return;

      final remaining = 3 - images.length;

      setState(() {
        images.addAll(pickedImages.take(remaining));
      });

      if (pickedImages.length > remaining) {
        showMessage('You can upload up to 3 photos.');
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
      showMessage('Could not select photos.');
    }
  }

  void removeImage(int index) {
    if (isGenerating) return;

    setState(() {
      images.removeAt(index);
    });
  }

  Future<void> generateListing() async {
    if (images.isEmpty) {
      showMessage('Please add at least one product photo.');
      return;
    }

    if (isGenerating) return;

    setState(() {
      isGenerating = true;
    });

    try {
      showMessage('SellAI is analyzing your product... 🤖');

      final List<Map<String, String>> imageData = [];

      for (final image in images) {
        final bytes = await image.readAsBytes();

        if (bytes.isEmpty) {
          throw Exception('Could not read image.');
        }

        imageData.add({
          'base64': base64Encode(bytes),
          'mimeType': getMimeType(image.path),
        });
      }

      if (imageData.isEmpty) {
        showMessage('Could not prepare product images.');
        return;
      }

      final requestBody = {
        'images': imageData,
        'language': selectedLanguage,
      };

      final response = await http
          .post(
            Uri.parse(
              'https://sellai-api.wasirashid2007.workers.dev/',
            ),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 120),
          );

      if (!mounted) return;

      debugPrint('Server status: ${response.statusCode}');
      debugPrint('Server response: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ListingResultScreen(
                listing: decoded,
                images: images
                    .map((image) => File(image.path))
                    .toList(),
              ),
            ),
          );
        } else {
          showMessage('Invalid response from server.');
        }
      } else {
        String errorMessage = 'Something went wrong.';

        try {
          final errorData = jsonDecode(response.body);

          if (errorData is Map<String, dynamic>) {
            errorMessage =
                errorData['details']?.toString() ??
                errorData['error']?.toString() ??
                errorData['message']?.toString() ??
                errorMessage;
          }
        } catch (_) {}

        debugPrint(
          'Server error ${response.statusCode}: ${response.body}',
        );

        showMessage(errorMessage);
      }
    } on SocketException catch (e) {
      debugPrint('Socket error: $e');

      if (mounted) {
        showMessage('Could not connect to the server.');
      }
    } on http.ClientException catch (e) {
      debugPrint('HTTP error: $e');

      if (mounted) {
        showMessage('Network error. Please try again.');
      }
    } on FormatException catch (e) {
      debugPrint('JSON error: $e');

      if (mounted) {
        showMessage('Invalid response from server.');
      }
    } catch (e) {
      debugPrint('Generate listing error: $e');

      if (mounted) {
        showMessage(
          'Something went wrong. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isGenerating = false;
        });
      }
    }
  }

  String getMimeType(String path) {
    final extension = path.toLowerCase().split('.').last;

    switch (extension) {
      case 'png':
        return 'image/png';

      case 'webp':
        return 'image/webp';

      case 'gif':
        return 'image/gif';

      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';

      default:
        return 'image/jpeg';
    }
  }

  void showMessage(String message) {
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
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: isGenerating
              ? null
              : () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Product',
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
            const Text(
              'Product photos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Take a photo with your camera or choose up to 3 photos from your gallery.',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 22),

            if (images.isEmpty)
              buildEmptyPicker()
            else
              buildImageSection(),

            const SizedBox(height: 30),

            const Text(
              'Listing language',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.15),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  isExpanded: true,
                  dropdownColor: colorScheme.surface,
                  items: const [
                    DropdownMenuItem(
                      value: 'English + Urdu',
                      child: Text('English + Urdu'),
                    ),
                    DropdownMenuItem(
                      value: 'English',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'Urdu',
                      child: Text('Urdu'),
                    ),
                  ],
                  onChanged: isGenerating
                      ? null
                      : (value) {
                          if (value == null) return;

                          setState(() {
                            selectedLanguage = value;
                          });
                        },
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: images.isEmpty || isGenerating
                    ? null
                    : generateListing,
                icon: isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  isGenerating
                      ? 'Generating...'
                      : 'Generate with AI',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      colorScheme.surfaceContainerHighest,
                  disabledForegroundColor:
                      colorScheme.onSurfaceVariant,
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

  Widget buildEmptyPicker() {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: isGenerating ? null : takePhoto,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    size: 48,
                    color: purple,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Take Photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Use camera',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: GestureDetector(
            onTap: isGenerating ? null : pickImages,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    size: 48,
                    color: purple,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Choose photos',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImageSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: images.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.file(
                      File(images[index].path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: isGenerating
                        ? null
                        : () => removeImage(index),
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        if (images.length < 3) ...[
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isGenerating
                      ? null
                      : takePhoto,
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                  ),
                  label: const Text('Camera'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: purple,
                    side: const BorderSide(
                      color: purple,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isGenerating
                      ? null
                      : pickImages,
                  icon: const Icon(
                    Icons.photo_library_outlined,
                  ),
                  label: const Text('Gallery'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: purple,
                    side: const BorderSide(
                      color: purple,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 8),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${images.length}/3 photos selected',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}