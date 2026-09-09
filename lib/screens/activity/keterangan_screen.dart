import 'dart:io';
import 'package:flutter/material.dart';
import '../../helpers/color/screen_color_helper.dart';
import '../../values/colors.dart';

class KeteranganScreen extends StatefulWidget {
  final String? title;
  final String? content;
  final String? imageUri;
  final List<String>? tags;

  const KeteranganScreen({
    super.key,
    this.title,
    this.content,
    this.imageUri,
    this.tags,
  });

  @override
  State<KeteranganScreen> createState() => _KeteranganScreenState();
}

class _KeteranganScreenState extends State<KeteranganScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isEditing = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final Map<String, dynamic>? args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      
      if (_titleController.text.isEmpty) {
        _titleController.text = args?['EXTRA_TITLE'] ?? "Nama Dokumen";
      }
      if (_contentController.text.isEmpty) {
        _contentController.text = args?['EXTRA_CONTENT'] ?? 
            "Ini adalah deskripsi detail mengenai dokumen yang dianalisis oleh AI.";
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String? displayImageUri = widget.imageUri ?? args?['EXTRA_IMAGE_URI'];
    final List<String> displayTags = widget.tags ?? (args?['EXTRA_TAGS'] as List<String>?) ?? 
        ["#tag1", "#tag2", "#tag3", "#tag4", "#tag5", "#tag6"];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Bar: Back Button & Keterangan Detail
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Text(
                    "Keterangan Detail",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Title & Delete Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _isEditing
                        ? TextField(
                            controller: _titleController,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Nama Dokumen",
                              border: InputBorder.none,
                            ),
                          )
                        : Text(
                            _titleController.text,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                  _buildDeleteButton(context),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Scrollable Content Area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 3. Image Preview Container
                    _buildImagePreview(displayImageUri),
                    
                    const SizedBox(height: 24),

                    // 4. Deskripsi Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Deskripsi",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_isEditing)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextField(
                                  controller: _contentController,
                                  maxLines: null,
                                  maxLength: 200,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    height: 1.5,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Masukkan deskripsi...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    counterText: "", // Hide default counter
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${_getWordCount(_contentController.text)}/200 kata",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              _contentController.text,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // 5. Tags Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: displayTags.map((tag) => _buildTag(context, tag)).toList(),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // 6. Action Buttons (Bottom)
            _buildActionButtons(context),

            // 7. Footer: Cerdas AI
            const SizedBox(height: 8),
            const Text(
              "Cerdas AI",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // WIDGET BUILDERS
  // ==========================================================================

  Widget _buildDeleteButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.black87),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Menghapus dokumen...")),
          );
        },
      ),
    );
  }

  Widget _buildImagePreview(String? imageUri) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _buildImageWidget(imageUri),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String label) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tag $label diklik")),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            context,
            icon: Icons.send_outlined,
            label: "Share",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Membagikan dokumen ke aplikasi lain...")),
              );
            },
          ),
          _buildActionButton(
            context,
            icon: Icons.download_outlined,
            label: "Download",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Menyimpan berkas ke penyimpanan internal...")),
              );
            },
          ),
          _buildActionButton(
            context,
            icon: _isEditing ? Icons.check_circle_outline : Icons.edit_outlined,
            label: _isEditing ? "Save" : "Edit",
            onTap: () {
              setState(() {
                if (_isEditing) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Perubahan disimpan")),
                  );
                }
                _isEditing = !_isEditing;
              });
            },
          ),
          _buildActionButton(
            context,
            icon: Icons.ios_share,
            label: "Export",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Mengekspor dokumen ke PDF/Word...")),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 28, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildImageWidget(String? path) {
    if (path == null || path.isEmpty) {
      return const Center(
        child: Icon(Icons.description_outlined, color: Colors.black26, size: 60),
      );
    }
    if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.contain);
    } else if (path.startsWith('assets/')) {
      return Image.asset(path, fit: BoxFit.contain);
    } else {
      return Image.file(File(path), fit: BoxFit.contain);
    }
  }

  int _getWordCount(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }
}
