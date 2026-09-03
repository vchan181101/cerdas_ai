import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../helpers/color/color_helper.dart';
import '../../helpers/xml/toolbar_helper.dart';
import '../../menu/menu.dart';
import '../../service/gemini_service.dart';
import '../../values/colors.dart';
import '../../values/strings.dart';
import '../../widgets/ai_response_card.dart';
import '../../widgets/attachment_preview_card.dart';
import '../../widgets/circular_image_view.dart';
import '../../widgets/bottom_navigation_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  // State variabel
  String _userName = 'Pengguna';
  String? _photoPath;
  File? _attachmentFile;
  String _attachmentName = '';
  IconData _attachmentIcon = Icons.insert_drive_file;
  bool _isImageAttachment = false;

  bool _showResponseCard = false;
  bool _isAiThinking = false;
  String _aiResponseText = '';

  final int _currentBottomNavIndex = 0;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _initTextToSpeech();
  }

  @override
  void dispose() {
    _promptController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  // 1. Inisialisasi Text To Speech
  Future<void> _initTextToSpeech() async {
    await _flutterTts.setLanguage("id-ID");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speakText(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.stop();
      await _flutterTts.speak(text);
    }
  }

  // 2. Memuat Profil Pengguna dari SharedPreferences
  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('USER_NAME') ?? 'Pengguna';
      _photoPath = prefs.getString('USER_PHOTO_URI');
    });
  }

  // 3. Penanganan Akses Media & Dokumen
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _showAttachmentPreview(
        file: File(image.path),
        name: 'Gambar Galeri (${image.name})',
        icon: Icons.image,
        isImage: true,
      );
    }
  }

  Future<void> _takePhotoWithCamera() async {
    final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      _showAttachmentPreview(
        file: File(photo.path),
        name: 'Foto Kamera Terambil',
        icon: Icons.camera_alt,
        isImage: true,
      );
      _processUserQuery();
    }
  }

  Future<void> _pickDocument(List<String> allowedExtensions) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      _showAttachmentPreview(
        file: file,
        name: result.files.single.name,
        icon: Icons.description,
        isImage: false,
      );
    }
  }

  void _showAttachmentPreview({
    required File file,
    required String name,
    required IconData icon,
    required bool isImage,
  }) {
    setState(() {
      _attachmentFile = file;
      _attachmentName = name;
      _attachmentIcon = icon;
      _isImageAttachment = isImage;
    });
  }

  void _clearAttachment() {
    setState(() {
      _attachmentFile = null;
      _attachmentName = '';
      _isImageAttachment = false;
    });
  }

  // 4. Input Suara (Speech-to-Text)
  Future<void> _startVoiceInput() async {
    bool available = await _speechToText.initialize(
      onError: (val) => debugPrint('STT Error: $val'),
      onStatus: (val) => debugPrint('STT Status: $val'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(
        listenOptions: stt.SpeechListenOptions(localeId: 'id_ID'),
        onResult: (val) {
          setState(() {
            _promptController.text = val.recognizedWords;
            _isListening = false;
          });
        },
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur suara tidak didukung di perangkat ini')),
      );
    }
  }

  // 5. Pemrosesan Pertanyaan AI
  Future<void> _processUserQuery() async {
    final prompt = _promptController.text.trim();

    if (prompt.isEmpty && _attachmentFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ketik pertanyaan atau unggah foto/file terlebih dahulu'),
        ),
      );
      return;
    }

    setState(() {
      _showResponseCard = true;
      _isAiThinking = true;
      _aiResponseText = _attachmentFile != null
          ? 'Cerdas AI sedang menganalisis foto/dokumen Anda...'
          : 'Cerdas AI sedang berpikir dan menganalisis...';
    });

    _promptController.clear();

    String response;
    try {
      if (_attachmentFile != null && _isImageAttachment) {
        // Analisis Gambar + Teks (Multimodal)
        response = await GeminiService.generateFromImage(
          imageFile: _attachmentFile!,
          prompt: prompt.isEmpty ? "Analisis gambar ini secara detail." : prompt,
        );
      } else {
        // Analisis Teks Saja
        response = await GeminiService.generateText(prompt);
      }
    } catch (e) {
      response = "Terjadi kesalahan: $e";
    }

    if (!mounted) return;

    setState(() {
      _isAiThinking = false;
      _aiResponseText = response;
    });

    _speakText(response);
    _clearAttachment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      appBar: ToolbarHelper.buildToolbar(
        context: context,
        title: AppStrings.appName,
        showBack: false,
        onRefresh: () {
          setState(() {
            _clearAttachment();
            _showResponseCard = false;
          });
          _loadUserProfile();
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Salam & Foto Profil
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Halo, $_userName!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ScreenColorHelper.getHeadingText(context),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/setting').then((_) => _loadUserProfile());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.navyPrimary, width: 2),
                    ),
                    child: _photoPath != null && File(_photoPath!).existsSync()
                        ? ClipOval(
                      child: Image.file(
                        File(_photoPath!),
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const CircularImageView(
                      imagePath: 'asset/ic_user.png',
                      size: 44,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Subtitle
            Text(
              AppStrings.subtitleDashboard,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ScreenColorHelper.getHeadingText(context),
              ),
            ),

            const SizedBox(height: 12),

            // Card Box Input Pertanyaan
            Card(
              elevation: 2,
              color: ScreenColorHelper.getSurfaceColor(context),
              shadowColor: ScreenColorHelper.getPrimaryAction(context).withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Preview Lampiran Berkas menggunakan widget reusable
                    if (_attachmentFile != null)
                      AttachmentPreviewCard(
                        file: _attachmentFile!,
                        fileName: _attachmentName,
                        icon: _attachmentIcon,
                        isImage: _isImageAttachment,
                        onRemove: _clearAttachment,
                      ),

                    // Input Text
                    TextField(
                      controller: _promptController,
                      maxLines: null,
                      minLines: 2,
                      style: TextStyle(fontSize: 14, color: ScreenColorHelper.getHeadingText(context)),
                      decoration: InputDecoration(
                        hintText: AppStrings.hintTypeQuestion,
                        hintStyle: TextStyle(color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.5), fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Tombol Lampirkan & Kirim
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, color: ScreenColorHelper.getPrimaryAction(context), size: 28),
                          onPressed: () => _pickDocument(['*']),
                          tooltip: AppStrings.descAttachment,
                        ),
                        FloatingActionButton.small(
                          onPressed: _processUserQuery,
                          backgroundColor: ScreenColorHelper.getPrimaryAction(context),
                          elevation: 2,
                          child: const Icon(Icons.send_rounded, color: AppColors.white, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Card Respon AI menggunakan widget reusable
            if (_showResponseCard) ...[
              const SizedBox(height: 16),
              AiResponseCard(
                response: _aiResponseText,
                isThinking: _isAiThinking,
              ),
            ],

            const SizedBox(height: 20),

            // 3 Grid Features (Kamera, Suara, Galeri)
            Row(
              children: [
                _buildFeatureTile(
                  title: AppStrings.btnKamera,
                  subtitle: 'Foto & Analisis',
                  icon: Icons.camera_alt_rounded,
                  iconColor: AppColors.navyPrimary,
                  onTap: _takePhotoWithCamera,
                ),
                const SizedBox(width: 8),
                _buildFeatureTile(
                  title: AppStrings.btnSuara,
                  subtitle: _isListening ? 'Mendengarkan...' : 'Tanya Lewat Suara',
                  icon: _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                  iconColor: AppColors.orangeAccent,
                  onTap: _startVoiceInput,
                ),
                const SizedBox(width: 8),
                _buildFeatureTile(
                  title: AppStrings.btnGaleri,
                  subtitle: 'Unggah Gambar',
                  icon: Icons.photo_library_rounded,
                  iconColor: AppColors.navyPrimary,
                  onTap: _pickImageFromGallery,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section Upload Dokumen
            Text(
              AppStrings.sectionUploadDokumen,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ScreenColorHelper.getHeadingText(context),
              ),
            ),

            const SizedBox(height: 12),

            // Card Dokumen Word
            _buildDocumentTile(
              title: 'Dokumen Word & Text',
              subtitle: 'Format .doc, .docx (MS Word / WPS)',
              icon: Icons.edit_document,
              iconColor: AppColors.navyPrimary,
              onTap: () => _pickDocument(['doc', 'docx', 'txt']),
            ),

            const SizedBox(height: 8),

            // Card Dokumen Presentation PowerPoint
            _buildDocumentTile(
              title: 'Presentasi PowerPoint',
              subtitle: 'Format .ppt, .pptx (MS Office / WPS)',
              icon: Icons.slideshow,
              iconColor: AppColors.orangeAccent,
              onTap: () => _pickDocument(['ppt', 'pptx']),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationViewWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          BottomNavMenu.handleNavigation(context, _currentBottomNavIndex, index);
        },
      ),
    );
  }

  // Helper Custom Grid Tile
  Widget _buildFeatureTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: ScreenColorHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        shadowColor: ScreenColorHelper.getPrimaryAction(context).withValues(alpha: 0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.inputBorder.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.1 : 0.5)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: iconColor),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: ScreenColorHelper.getHeadingText(context),
                  ),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: ScreenColorHelper.getBodyText(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Custom Document Tile
  Widget _buildDocumentTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      color: ScreenColorHelper.getSurfaceColor(context),
      shadowColor: ScreenColorHelper.getPrimaryAction(context).withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ScreenColorHelper.getHeadingText(context),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11, color: ScreenColorHelper.getBodyText(context)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.5), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}