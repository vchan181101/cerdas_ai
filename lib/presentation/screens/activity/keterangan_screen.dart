import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cerdas_ai/presentation/widgets/background_wrapper.dart';

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

  // Tag Controllers
  final List<TextEditingController> _tagControllers =
      List.generate(3, (_) => TextEditingController());

  bool _isEditing = false;
  bool _isInitialized = false;
  bool _showCustomTagInputs = false;

  // Permanent Tags
  String _tag1 = "Kategori";
  String _tag2 = "Tingkat";
  String _tag3 = "Mapel";

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
        _titleController.text = args?['EXTRA_TITLE'] ?? "Analisis AI: Sejarah Indonesia";
      }
      if (_contentController.text.isEmpty) {
        _contentController.text = args?['EXTRA_CONTENT'] ??
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut wisi at enim ad minim veniam, quis nostrud exercidio ullamco analysuat sejarah indonesia, ecnasietute gcade dolore dunt ut labriamdo consetuat.";
      }

      // Initialize Permanent Tags from arguments
      _tag1 = args?['EXTRA_KATEGORI'] ?? "Kategori";
      _tag2 = args?['EXTRA_TINGKAT'] ?? "Tingkat";
      _tag3 = args?['EXTRA_MAPEL'] ?? "Mapel";

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    for (var controller in _tagControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String? displayImageUri = widget.imageUri ?? args?['EXTRA_IMAGE_URI'];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWrapper(
        child: SafeArea(
          child: Column(
            children: [
              // 1. Top Bar: Back Button & "Keterangan Detail"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Text(
                      "Keterangan Detail",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Title & Delete Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _isEditing
                          ? TextField(
                              controller: _titleController,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Nama Dokumen",
                                hintStyle: TextStyle(
                                  color: isDark ? Colors.white38 : Colors.black38,
                                ),
                                border: InputBorder.none,
                              ),
                            )
                          : Text(
                              _titleController.text,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                    _buildDeleteButton(context, isDark),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Scrollable Content Area
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner 3-Elemen (Left Card, Mascot, Right Card) Sesuai Referensi Gambar
                      _buildShowcaseBanner(context, isDark, displayImageUri),

                      const SizedBox(height: 24),

                      // 4. Deskripsi Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deskripsi",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
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
                                    maxLength: 350,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                      height: 1.5,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Masukkan deskripsi...",
                                      hintStyle: TextStyle(
                                        color: isDark ? Colors.white38 : Colors.black38,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: isDark ? const Color(0xFF253358) : Colors.grey.shade300,
                                        ),
                                      ),
                                      counterText: "",
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${_getWordCount(_contentController.text)} kata",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? const Color(0xFF64748B) : Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                _contentController.text,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155),
                                  height: 1.5,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 5. Tags Section (#Kategori, #Tingkat, #Mapel, Add Tags +)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                // Permanent Tags (#Kategori, #Tingkat, #Mapel)
                                _buildTag(context, _tag1, isPermanent: true),
                                _buildTag(context, _tag2, isPermanent: true),
                                _buildTag(context, _tag3, isPermanent: true),

                                // Custom Tags
                                if (!_showCustomTagInputs)
                                  ..._tagControllers
                                      .where((c) => c.text.isNotEmpty)
                                      .map((c) => _buildTag(context, c.text)),

                                // Add Tags Button
                                if (!_showCustomTagInputs)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _showCustomTagInputs = true;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      child: Text(
                                        "Add Tags +",
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            // Custom Tag Inputs (Muncul saat Add Tags diklik)
                            if (_showCustomTagInputs) ...[
                              const SizedBox(height: 14),
                              Text(
                                "Tambah hingga 3 Tag kustom:",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: List.generate(3, (index) {
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: TextField(
                                        controller: _tagControllers[index],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark ? Colors.white : Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "#tag${index + 4}",
                                          hintStyle: TextStyle(
                                            color: isDark ? Colors.white38 : Colors.grey,
                                          ),
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: isDark ? const Color(0xFF253358) : Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _showCustomTagInputs = false;
                                    });
                                  },
                                  child: const Text("Selesai"),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // 6. Action Buttons (Share, Download, Edit, Export)
              _buildActionButtons(context, isDark),

              // 7. Footer: Cerdas AI
              const SizedBox(height: 6),
              Text(
                "Cerdas AI",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // WIDGET BUILDERS
  // ==========================================================================

  Widget _buildDeleteButton(BuildContext context, bool isDark) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131A2E) : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF253358) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.delete_outline_rounded,
          size: 20,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Menghapus dokumen...")),
          );
        },
      ),
    );
  }

  Widget _buildShowcaseBanner(BuildContext context, bool isDark, String? displayImageUri) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0E162B) : const Color(0xFFEDF2F7).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? const Color(0xFF223055) : Colors.black.withValues(alpha: 0.04),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 550;

            final mascotWidget = Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF1E2846),
                          const Color(0xFF0F172A),
                        ]
                      : [
                          const Color(0xFFE0F7FA),
                          const Color(0xFFEDE9FE),
                        ],
                ),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF6366F1).withValues(alpha: 0.6)
                      : Colors.white,
                  width: isDark ? 1.5 : 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? const Color(0xFF6366F1) : const Color(0xFF8B5CF6))
                        .withValues(alpha: isDark ? 0.4 : 0.15),
                    blurRadius: 18,
                    spreadRadius: isDark ? 1 : 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Center(
                  child: _buildImageWidget(displayImageUri),
                ),
              ),
            );

            final leftCard = _buildSummaryCard(
              isDark: isDark,
              text:
                  "Lorem ipsum dolor sit amet, consectetur. adipiscing elit, niusmod nonumyang sangunului duot indiruta magna Indonesia tudoramgum attya.",
              bullets: const [
                "Summary dnrm sejarah Indonesia",
                "Pelajaran dalam Indonesia",
                "Mock-data",
              ],
            );

            final rightCard = _buildSummaryCard(
              isDark: isDark,
              text:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, niasmod norrumyang sanganului duot indiiiuta magna indonesia truloramgum attya.",
              bullets: const [
                "Pelajaran pernsearan Indonesia",
                "Pelajaran dalam Indonesia",
                "Mock-data",
              ],
            );

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: leftCard),
                  const SizedBox(width: 16),
                  mascotWidget,
                  const SizedBox(width: 16),
                  Expanded(child: rightCard),
                ],
              );
            } else {
              // Responsif untuk layar kecil / mobile vertikal
              return Column(
                children: [
                  mascotWidget,
                  const SizedBox(height: 16),
                  leftCard,
                  const SizedBox(height: 12),
                  rightCard,
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required bool isDark,
    required String text,
    required List<String> bullets,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131C35) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF253358) : Colors.black.withValues(alpha: 0.04),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
              height: 1.4,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• ",
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF818CF8) : const Color(0xFF6366F1),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        b,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String rawLabel, {bool isPermanent = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final label = rawLabel.startsWith('#') ? rawLabel : '#$rawLabel';
    final lower = rawLabel.toLowerCase().replaceAll('#', '');

    final Color bg;
    final Color textCol;
    final Border? border;
    final List<BoxShadow>? shadows;

    if (lower.contains('kategori')) {
      bg = isDark ? const Color(0xFF2E1A47) : const Color(0xFFF3E8FF);
      textCol = isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA);
      border = isDark ? Border.all(color: const Color(0xFFA855F7).withValues(alpha: 0.5), width: 1) : null;
      shadows = isDark
          ? [
              BoxShadow(
                color: const Color(0xFFA855F7).withValues(alpha: 0.35),
                blurRadius: 10,
              ),
            ]
          : null;
    } else if (lower.contains('tingkat') ||
        lower.contains('sd') ||
        lower.contains('smp') ||
        lower.contains('sma')) {
      bg = isDark ? const Color(0xFF132D24) : const Color(0xFFDCFCE7);
      textCol = isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
      border = isDark ? Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.5), width: 1) : null;
      shadows = isDark
          ? [
              BoxShadow(
                color: const Color(0xFF22C55E).withValues(alpha: 0.35),
                blurRadius: 10,
              ),
            ]
          : null;
    } else if (lower.contains('mapel') ||
        lower.contains('matematika') ||
        lower.contains('ipa') ||
        lower.contains('ips')) {
      bg = isDark ? const Color(0xFF102844) : const Color(0xFFE0F2FE);
      textCol = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);
      border = isDark ? Border.all(color: const Color(0xFF0EA5E9).withValues(alpha: 0.5), width: 1) : null;
      shadows = isDark
          ? [
              BoxShadow(
                color: const Color(0xFF0EA5E9).withValues(alpha: 0.35),
                blurRadius: 10,
              ),
            ]
          : null;
    } else {
      bg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
      textCol = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);
      border = isDark ? Border.all(color: const Color(0xFF334155), width: 1) : null;
      shadows = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: border,
        boxShadow: shadows,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: textCol,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            context,
            icon: Icons.send_rounded,
            label: "Share",
            isDark: isDark,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Membagikan dokumen ke aplikasi lain...")),
              );
            },
          ),
          _buildActionButton(
            context,
            icon: Icons.arrow_downward_rounded,
            label: "Download",
            isDark: isDark,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Menyimpan berkas ke penyimpanan internal...")),
              );
            },
          ),
          _buildActionButton(
            context,
            icon: _isEditing ? Icons.check_rounded : Icons.edit_rounded,
            label: _isEditing ? "Save" : "Edit",
            isDark: isDark,
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
            icon: Icons.ios_share_rounded,
            label: "Export",
            isDark: isDark,
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
    required bool isDark,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? const Color(0xFF131A2E) : Colors.white,
              border: Border.all(
                color: isDark ? const Color(0xFF253358) : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: isDark
                  ? [
                      BoxShadow(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.18),
                        blurRadius: 12,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Icon(
              icon,
              size: 24,
              color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String? path) {
    if (path == null || path.isEmpty) {
      return Image.asset(
        'asset/ic_logo_aicerdas.png',
        width: 88,
        height: 88,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.school_rounded, color: Colors.blueAccent, size: 55),
      );
    }
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(
          'asset/ic_logo_aicerdas.png',
          width: 88,
          height: 88,
          fit: BoxFit.contain,
        ),
      );
    } else if (path.startsWith('asset')) {
      return Image.asset(
        path == 'asset/ic_logo_aicerdas.jpg' ? 'asset/ic_logo_aicerdas.png' : path,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(
          'asset/ic_logo_aicerdas.png',
          width: 88,
          height: 88,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(
          'asset/ic_logo_aicerdas.png',
          width: 88,
          height: 88,
          fit: BoxFit.contain,
        ),
      );
    }
  }

  int _getWordCount(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }
}
