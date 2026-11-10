import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:cerdas_ai/core/app_constants.dart';
import 'package:cerdas_ai/core/helpers/helpers.dart';
import 'package:cerdas_ai/menu/menu.dart';
import 'package:cerdas_ai/data/service/gemini_service.dart';
import 'package:cerdas_ai/core/values/colors.dart';
import 'package:cerdas_ai/core/values/strings.dart';
import 'package:cerdas_ai/presentation/widgets/ai_response_card.dart';
import 'package:cerdas_ai/presentation/widgets/attachment_preview_card.dart';
import 'package:cerdas_ai/presentation/widgets/circular_image_view.dart';
import 'package:cerdas_ai/presentation/widgets/bottom_navigation_view_widget.dart';
import 'package:cerdas_ai/presentation/widgets/language_option_widget.dart';
import 'package:cerdas_ai/presentation/widgets/background_wrapper.dart';
import 'package:cerdas_ai/presentation/widgets/cerdas_ai_logo_badge.dart';
import 'package:cerdas_ai/presentation/widgets/avatar_character_picker.dart';
import 'custom_camera_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

// State untuk History
class ChatHistoryItem {
  final String question;
  final String answer;
  final String? fileName;
  final String? filePath;
  final String? fileType;
  final String? timestamp;

  ChatHistoryItem({
    required this.question,
    required this.answer,
    this.fileName,
    this.filePath,
    this.fileType,
    this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'q': question,
    'a': answer,
    if (fileName != null) 'fileName': fileName,
    if (filePath != null) 'filePath': filePath,
    if (fileType != null) 'fileType': fileType,
    if (timestamp != null) 'timestamp': timestamp,
  };

  factory ChatHistoryItem.fromJson(Map<String, dynamic> json) => 
      ChatHistoryItem(
        question: json['q'] ?? '',
        answer: json['a'] ?? '',
        fileName: json['fileName'] ?? json['file_name'],
        filePath: json['filePath'] ?? json['file_path'],
        fileType: json['fileType'] ?? json['file_type'],
        timestamp: json['timestamp'],
      );
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _promptController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final ImagePicker _imagePicker = ImagePicker();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  // State variabel
  File? _attachmentFile;
  String? _attachmentImagePath;
  bool _isAttachmentNetwork = false;
  String _attachmentName = '';
  IconData _attachmentIcon = Icons.insert_drive_file;
  bool _isImageAttachment = false;

  bool _showResponseCard = false;
  bool _isAiThinking = false;
  String _aiResponseText = '';

  final int _currentBottomNavIndex = 0;
  bool _isListening = false;
  bool _isArgumentsHandled = false;
  final FocusNode _promptFocusNode = FocusNode();

  String? _cachedAnswer;

  // State untuk History
  final List<ChatHistoryItem> _chatHistory = [];
  bool _isLoadingHistory = false;

  @override
  void initState() {
    super.initState();
    UserProfileHelper.loadSavedProfile();
    _loadChatHistory();
    _initTextToSpeech();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isArgumentsHandled) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String && args.isNotEmpty) {
        _promptController.text = args;
        // Focus the text field when receiving a question from another screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _promptFocusNode.requestFocus();
        });
      } else if (args is Map) {
        final title = (args['title'] ?? args['EXTRA_TITLE'] ?? '') as String;
        final image = (args['image'] ?? args['EXTRA_IMAGE_URI']) as String?;
        final isNetwork = args['isNetwork'] == true || args['isNetwork'] == 'true';

        if (title.isNotEmpty) {
          _promptController.text = title;
        }

        if (image != null && image.isNotEmpty) {
          _attachmentImagePath = image;
          _isAttachmentNetwork = isNetwork;
          _attachmentName = title.isNotEmpty ? title : 'Gambar Materi';
          _attachmentIcon = Icons.image;
          _isImageAttachment = true;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _promptFocusNode.requestFocus();
        });
      }
      _isArgumentsHandled = true;
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    _promptFocusNode.dispose();
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

  // 2. Memuat Riwayat Percakapan dari SharedPreferences
  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(AppConstants.keyChatHistory);
    
    if (historyJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(historyJson);
        setState(() {
          _chatHistory.clear();
          _chatHistory.addAll(decoded.map((item) => ChatHistoryItem.fromJson(item)).toList());
        });
      } catch (e) {
        debugPrint('Error loading chat history: $e');
      }
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_chatHistory.map((item) => item.toJson()).toList());
    await prefs.setString(AppConstants.keyChatHistory, encoded);
  }

  // 3. Penanganan Akses Media & Dokumen
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _showAttachmentPreview(
        file: File(image.path),
        name: image.name,
        icon: Icons.image,
        isImage: true,
      );
    }
  }

  Future<void> _takePhotoWithCamera() async {
    final XFile? photo = await Navigator.push<XFile>(
      context,
      MaterialPageRoute(builder: (context) => const CustomCameraScreen()),
    );

    if (photo != null) {
      _showAttachmentPreview(
        file: File(photo.path),
        name: photo.name,
        icon: Icons.camera_alt,
        isImage: true,
      );
    }
  }

  Future<void> _pickDocument(List<String> allowedExtensions) async {
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensions.contains('*') ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions.contains('*') ? null : allowedExtensions,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final fileName = result.files.single.name.toLowerCase();
      
      bool isImage = fileName.endsWith('.jpg') || 
                    fileName.endsWith('.jpeg') || 
                    fileName.endsWith('.png') || 
                    fileName.endsWith('.webp');

      IconData icon = Icons.description;
      if (isImage) {
        icon = Icons.image;
      } else if (fileName.endsWith('.pdf')) {
        icon = Icons.picture_as_pdf;
      } else if (fileName.endsWith('.xls') || fileName.endsWith('.xlsx')) {
        icon = Icons.table_chart;
      } else if (fileName.endsWith('.ppt') || fileName.endsWith('.pptx')) {
        icon = Icons.slideshow;
      } else if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) {
        icon = Icons.description;
      }

      _showAttachmentPreview(
        file: file,
        name: result.files.single.name,
        icon: icon,
        isImage: isImage,
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
      _attachmentImagePath = null;
      _isAttachmentNetwork = false;
      _attachmentName = name;
      _attachmentIcon = icon;
      _isImageAttachment = isImage;
    });
  }

  void _clearAttachment() {
    setState(() {
      _attachmentFile = null;
      _attachmentImagePath = null;
      _isAttachmentNetwork = false;
      _attachmentName = '';
      _isImageAttachment = false;
    });
  }

  // 3. Input Suara (Speech-to-Text)
  Future<void> _startVoiceInput() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          debugPrint('STT Status: $status');
          if (status == 'done' || status == 'notListening') {
            if (mounted) setState(() => _isListening = false);
          }
        },
        onError: (errorNotification) {
          debugPrint('STT Error: ${errorNotification.errorMsg}');
          if (mounted) {
            setState(() => _isListening = false);
            context.showSnackBar('${AppStrings.micErrorPrefix}: ${errorNotification.errorMsg}');
          }
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _promptController.text = result.recognizedWords;
              // Jika ini hasil akhir (user berhenti bicara), hentikan listening
              if (result.finalResult) {
                _isListening = false;
                context.showSnackBar('Suara berhasil direkam dan dikonversi!');
              }
            });
          },
          listenOptions: stt.SpeechListenOptions(
            cancelOnError: true,
            partialResults: true,
            localeId: appLocaleNotifier.value.languageCode == 'id' ? 'id_ID' : 'en_US',
          ),
        );
      } else {
        if (mounted) {
          context.showSnackBar(AppStrings.micFeatureAlert);
        }
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  // 4. Modal Bottom Sheet (Lampiran Modern)
  void _showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final surfaceColor = ScreenColorHelper.getSurfaceColor(context);
        final bodyColor = ScreenColorHelper.getBodyText(context);

        return Container(
          padding: const EdgeInsets.only(bottom: 32),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: bodyColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Baris Item Lampiran (Foto, Kamera, File, Google Drive)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHorizontalItem(
                      imageAsset: 'asset/ic_image.png',
                      label: AppStrings.labelFoto,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImageFromGallery();
                      },
                    ),
                    _buildHorizontalItem(
                      imageAsset: 'asset/ic_camera.png',
                      label: AppStrings.labelKamera,
                      onTap: () {
                        Navigator.pop(context);
                        _takePhotoWithCamera();
                      },
                    ),
                    _buildHorizontalItem(
                      imageAsset: 'asset/ic_file.png',
                      label: AppStrings.labelFile,
                      onTap: () {
                        Navigator.pop(context);
                        _pickDocument(['*']);
                      },
                    ),
                    _buildHorizontalItem(
                      imageAsset: 'asset/ic_repository.png',
                      label: AppStrings.labelRepository,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/repository');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHorizontalItem({
    IconData? icon,
    String? imageAsset,
    required String label,
    required VoidCallback onTap,
  }) {
    final bodyColor = ScreenColorHelper.getBodyText(context);
    final primaryColor = ScreenColorHelper.getPrimaryAction(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              padding: imageAsset != null ? const EdgeInsets.all(12) : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
                border: Border.all(color: bodyColor.withValues(alpha: 0.1)),
              ),
              child: imageAsset != null
                  ? Image.asset(imageAsset, fit: BoxFit.contain)
                  : Icon(icon, color: primaryColor, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: bodyColor),
            ),
          ],
        ),
      ),
    );
  }

  static final List<ChatHistoryItem> _defaultMockHistory = [
    ChatHistoryItem(
      question: 'Sejarah Indonesia',
      answer: 'Diskusi mengenai sejarah dan budaya Indonesia',
    ),
    ChatHistoryItem(
      question: 'Analisis AI: hallo selamat pagi',
      answer: 'Percakapan awal dengan asisten AI pagi hari',
    ),
    ChatHistoryItem(
      question: 'hallo selamat pagi',
      answer: 'Sapaan hangat dan respon asisten cerdas',
    ),
    ChatHistoryItem(
      question: 'hello everybody',
      answer: 'Pesan pengantar dalam forum obrolan',
    ),
    ChatHistoryItem(
      question: 'Analisis AI: Biologi: Struktur Sel Manusia',
      answer: 'Pembahasan mendalam tentang organel sel',
    ),
    ChatHistoryItem(
      question: 'Biologi: Struktur Sel Manusia',
      answer: 'Materi pembelajaran mengenai biologi',
    ),
  ];

  void _showHistorySheet() {
    String searchQuery = "";
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final surfaceColor = ScreenColorHelper.getSurfaceColor(context);
        final headingColor = ScreenColorHelper.getHeadingText(context);
        final bodyColor = ScreenColorHelper.getBodyText(context);

        return StatefulBuilder(
          builder: (context, setModalState) {
            final sourceHistory = _chatHistory.isNotEmpty ? _chatHistory : _defaultMockHistory;
            final filteredHistory = sourceHistory
                .where((item) =>
                    item.question.toLowerCase().contains(searchQuery.toLowerCase()) ||
                    item.answer.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                height: MediaQuery.of(context).size.height * 0.82,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF12192F) : surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? const Color(0xFF253358) : bodyColor.withValues(alpha: 0.1),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag Handle
                    Container(
                      width: 44,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF475569) : bodyColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.btnHistoryChat,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : headingColor,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_rounded, color: isDark ? Colors.white70 : headingColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    // Search Bar inside History
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F1528) : bodyColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? const Color(0xFF1E2848) : Colors.transparent,
                          ),
                        ),
                        child: TextField(
                          style: TextStyle(color: isDark ? Colors.white : headingColor, fontSize: 13.5),
                          decoration: InputDecoration(
                            hintText: AppStrings.historySearchHint,
                            hintStyle: TextStyle(
                              color: isDark ? const Color(0xFF64748B) : bodyColor.withValues(alpha: 0.5),
                              fontSize: 13.5,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 20,
                              color: isDark ? const Color(0xFF64748B) : bodyColor,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: InputBorder.none,
                          ),
                          onChanged: (val) {
                            setModalState(() {
                              searchQuery = val;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!_isLoadingHistory && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                            setModalState(() => _isLoadingHistory = true);
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) {
                                setModalState(() {
                                  _chatHistory.addAll([
                                    ChatHistoryItem(question: "Pertanyaan lama #1", answer: "Jawaban lama #1 dari server..."),
                                    ChatHistoryItem(question: "Pertanyaan lama #2", answer: "Jawaban lama #2 dari server..."),
                                    ChatHistoryItem(question: "Pertanyaan lama #3", answer: "Jawaban lama #3 dari server..."),
                                  ]);
                                  _isLoadingHistory = false;
                                  _saveChatHistory();
                                });
                                setState(() {});
                              }
                            });
                          }
                          return true;
                        },
                        child: filteredHistory.isEmpty 
                          ? Center(
                              child: Text(
                                AppStrings.historyEmptyResult, 
                                style: TextStyle(color: isDark ? const Color(0xFF8E9BB0) : bodyColor),
                              ),
                            )
                          : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            itemCount: filteredHistory.length + (_isLoadingHistory ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == filteredHistory.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              final item = filteredHistory[index];
                              final isFirstItem = index == 0;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _promptController.text = item.question;
                                    _cachedAnswer = item.answer;
                                    _showResponseCard = false;
                                  });
                                  Navigator.pop(context);
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? (isFirstItem ? const Color(0xFF131D38) : const Color(0xFF141C34))
                                        : bodyColor.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isDark
                                          ? (isFirstItem ? const Color(0xFF2563EB) : const Color(0xFF1E2848))
                                          : bodyColor.withValues(alpha: 0.1),
                                      width: isFirstItem && isDark ? 1.5 : 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: isDark ? const Color(0xFF1C2542) : bodyColor.withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.person_outline_rounded,
                                          size: 20,
                                          color: isDark ? const Color(0xFF94A3B8) : bodyColor,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.question,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.bold,
                                                color: isDark ? Colors.white : headingColor,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              item.answer,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                color: isDark ? const Color(0xFF8E9BB0) : bodyColor.withValues(alpha: 0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 5. Menu Profil Modern (3 Kolom: Notifikasi, Setting, Keluar)
  void _showProfileMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = ScreenColorHelper.getSurfaceColor(context);
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            padding: EdgeInsets.only(
              top: 8,
              left: 18,
              right: 18,
              bottom: MediaQuery.of(sheetContext).padding.bottom + 18,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF12192F) : surfaceColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? const Color(0xFF253358) : bodyColor.withValues(alpha: 0.1),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF475569) : bodyColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Profil Header Mini Card
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        ValueListenableBuilder<String?>(
                          valueListenable: userPhotoNotifier,
                          builder: (context, photoPath, _) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? const Color(0xFF818CF8) : AppColors.navyPrimary,
                                  width: 2,
                                ),
                                boxShadow: isDark
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                                          blurRadius: 10,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: photoPath != null && File(photoPath).existsSync()
                                  ? ClipOval(
                                      child: Image.file(
                                        File(photoPath),
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : photoPath != null && photoPath.startsWith('avatar:')
                                      ? ClipOval(
                                          child: AvatarCharacterWidget(
                                            character: AvatarCharacterList.getById(
                                              photoPath.replaceFirst('avatar:', ''),
                                            ),
                                            size: 48,
                                          ),
                                        )
                                      : ClipOval(
                                          child: Image.asset(
                                            'asset/img.png',
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => const CircularImageView(
                                              imagePath: 'asset/ic_user.png',
                                              size: 48,
                                            ),
                                          ),
                                        ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Akun Pengguna',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : headingColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C3AED),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'Pro',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: isDark ? Colors.white70 : bodyColor.withValues(alpha: 0.6),
                          ),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),
                  Divider(
                    color: isDark ? const Color(0xFF1E2948) : Colors.black.withValues(alpha: 0.08),
                    height: 1,
                  ),
                  const SizedBox(height: 14),

                  // Label Pilihan Kolom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12, left: 4),
                    child: Text(
                      'PILIHAN MENU PROFIL (3 KOLOM)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: isDark ? const Color(0xFF8E9BB0) : bodyColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ),

                  // 3 Kolom Pilihan (Side by Side Card Columns)
                  Row(
                    children: [
                      // Kolom 1: Notifikasi
                      Expanded(
                        child: _buildProfileMenuColumnCard(
                          key: const ValueKey('profile_menu_col_notifikasi'),
                          context: sheetContext,
                          title: 'Notifikasi',
                          icon: Icons.notifications_none_rounded,
                          iconColor: const Color(0xFF3B82F6),
                          bgColor: isDark ? const Color(0xFF111D38) : const Color(0xFF3B82F6).withValues(alpha: 0.08),
                          borderColor: isDark ? const Color(0xFF2563EB).withValues(alpha: 0.5) : const Color(0xFF3B82F6).withValues(alpha: 0.3),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            Navigator.pushNamed(context, '/notifikasi');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Kolom 2: Setting
                      Expanded(
                        child: _buildProfileMenuColumnCard(
                          key: const ValueKey('profile_menu_col_setting'),
                          context: sheetContext,
                          title: 'Setting',
                          icon: Icons.settings_outlined,
                          iconColor: const Color(0xFF10B981),
                          bgColor: isDark ? const Color(0xFF0F2624) : const Color(0xFF10B981).withValues(alpha: 0.08),
                          borderColor: isDark ? const Color(0xFF10B981).withValues(alpha: 0.5) : const Color(0xFF10B981).withValues(alpha: 0.3),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            Navigator.pushNamed(context, '/setting');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Kolom 3: Keluar
                      Expanded(
                        child: _buildProfileMenuColumnCard(
                          key: const ValueKey('profile_menu_col_keluar'),
                          context: sheetContext,
                          title: 'Keluar',
                          icon: Icons.logout_rounded,
                          iconColor: const Color(0xFFEF4444),
                          bgColor: isDark ? const Color(0xFF2A1520) : const Color(0xFFEF4444).withValues(alpha: 0.08),
                          borderColor: isDark ? const Color(0xFFEF4444).withValues(alpha: 0.5) : const Color(0xFFEF4444).withValues(alpha: 0.3),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            _handleLogout(context);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Daftar Item Menu Vertikal Detail
                  _buildProfileMenuItemTile(
                    key: const ValueKey('profile_menu_tile_notifikasi'),
                    context: sheetContext,
                    title: 'Notifikasi',
                    subtitle: 'Buka tampilan notifikasi & pesan aktivitas',
                    icon: Icons.notifications_none_rounded,
                    color: const Color(0xFF3B82F6),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      Navigator.pushNamed(context, '/notifikasi');
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildProfileMenuItemTile(
                    key: const ValueKey('profile_menu_tile_setting'),
                    context: sheetContext,
                    title: 'Setting',
                    subtitle: 'Buka tampilan setting, tema & akun',
                    icon: Icons.settings_outlined,
                    color: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      Navigator.pushNamed(context, '/setting');
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildProfileMenuItemTile(
                    key: const ValueKey('profile_menu_tile_keluar'),
                    context: sheetContext,
                    title: 'Keluar',
                    subtitle: 'Keluar akun dengan proses loading otomatis',
                    icon: Icons.logout_rounded,
                    color: const Color(0xFFEF4444),
                    isDestructive: true,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _handleLogout(context);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileMenuColumnCard({
    Key? key,
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor = ScreenColorHelper.getHeadingText(context);

    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: isDark ? 0.2 : 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : headingColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItemTile({
    Key? key,
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor = ScreenColorHelper.getHeadingText(context);
    final bodyColor = ScreenColorHelper.getBodyText(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: key,
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDestructive
                ? (isDark
                    ? const Color(0xFF201524)
                    : const Color(0xFFFEF2F2))
                : (isDark
                    ? const Color(0xFF141C34)
                    : Colors.black.withValues(alpha: 0.02)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDestructive
                  ? const Color(0xFFEF4444).withValues(alpha: 0.35)
                  : (isDark
                      ? const Color(0xFF222C4A)
                      : Colors.black.withValues(alpha: 0.06)),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDestructive
                            ? const Color(0xFFEF4444)
                            : (isDark ? Colors.white : headingColor),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDestructive
                            ? const Color(0xFFEF4444).withValues(alpha: 0.8)
                            : (isDark ? const Color(0xFF8E9BB0) : bodyColor),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isDestructive
                    ? const Color(0xFFEF4444)
                    : (isDark ? Colors.white38 : bodyColor.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 6. Penanganan Keluar Akun (Loading & Navigasi ke Login)
  Future<void> _handleLogout(BuildContext context) async {
    // Tampilkan Dialog Loading Proses Keluar Akun
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        final isDark = Theme.of(dialogCtx).brightness == Brightness.dark;
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.navyPrimary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const CircularProgressIndicator(
                      strokeWidth: 3.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.navyPrimary),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sedang Keluar Akun...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Memproses sesi dan mengamankan akun Anda...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      // 1. Bersihkan status login dan token di SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyIsLoggedIn, false);
      await prefs.remove(AppConstants.keyAuthToken);
    } catch (e) {
      debugPrint('Error saat membersihkan sesi: $e');
    }

    // 2. Beri jeda loading agar animasi proses terlihat jelas & natural
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!context.mounted) return;

    // 3. Tutup dialog loading
    Navigator.of(context, rootNavigator: true).pop();

    // 4. Beri feedback snackbar
    context.showSnackBar('Berhasil keluar dari akun');

    // 5. Arahkan otomatis ke LoginScreen dan bersihkan backstack
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // 7. Pemrosesan Pertanyaan AI
  Future<void> _processUserQuery() async {
    final prompt = _promptController.text.trim();

    if (prompt.isEmpty && _attachmentFile == null && _attachmentImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.promptEmptyAlert),
        ),
      );
      return;
    }

    setState(() {
      _showResponseCard = true;
      _isAiThinking = true;
      _aiResponseText = (_attachmentFile != null || _attachmentImagePath != null)
          ? AppStrings.aiAnalyzingText
          : AppStrings.aiThinkingText;
    });

    _promptController.clear();

    // Jika ini adalah pertanyaan dari history yang baru diklik, gunakan jawaban yang sudah ada
    if (_cachedAnswer != null) {
      final answer = _cachedAnswer!;
      setState(() {
        _isAiThinking = false;
        _aiResponseText = answer;
        _cachedAnswer = null; // Reset setelah digunakan
        
        // Pindahkan ke paling atas riwayat jika sudah ada, atau tambahkan jika belum
        _chatHistory.removeWhere((item) => item.question == prompt);
        _chatHistory.insert(0, ChatHistoryItem(question: prompt, answer: answer));
      });
      await _saveChatHistory(); // Simpan pembaruan posisi
      _speakText(_aiResponseText);
      return;
    }

    final String? currentAttachmentName = _attachmentName.isNotEmpty ? _attachmentName : null;
    final String? currentAttachmentPath = _attachmentFile?.path ?? _attachmentImagePath;
    String? currentFileType;
    if (currentAttachmentName != null) {
      currentFileType = currentAttachmentName.contains('.')
          ? currentAttachmentName.split('.').last.toUpperCase()
          : 'DOKUMEN';
    } else if (_isImageAttachment) {
      currentFileType = 'JPG';
    }

    final String effectivePrompt = prompt.isNotEmpty
        ? prompt
        : (_attachmentName.isNotEmpty 
            ? "Analisis dokumen $_attachmentName" 
            : "Analisis gambar ini secara detail.");

    String response;
    try {
      if (_attachmentFile != null && _isImageAttachment) {
        // Analisis Gambar + Teks (Multimodal)
        response = await GeminiService.generateFromImage(
          imageFile: _attachmentFile!,
          prompt: prompt.isEmpty ? "Analisis gambar ini secara detail." : prompt,
        );
      } else {
        // Analisis Teks Saja / Dokumen
        response = await GeminiService.generateText(effectivePrompt);
      }
    } catch (e) {
      response = "Terjadi kesalahan: $e";
    }

    if (!mounted) return;

    final String historyQuestion = prompt.isNotEmpty 
        ? prompt 
        : (currentAttachmentName ?? (_isImageAttachment ? "Analisis Gambar" : "Analisis Dokumen"));

    setState(() {
      _isAiThinking = false;
      _aiResponseText = response;
      
      // Simpan otomatis ke Riwayat Percakapan (Tambahkan ke paling atas)
      _chatHistory.removeWhere((item) => item.question == historyQuestion);
      _chatHistory.insert(
        0,
        ChatHistoryItem(
          question: historyQuestion,
          answer: response,
          fileName: currentAttachmentName,
          filePath: currentAttachmentPath,
          fileType: currentFileType,
          timestamp: 'Baru saja',
        ),
      );
    });

    await _saveChatHistory(); // Simpan secara permanen

    // Simpan otomatis ke UPLOADED_DOCUMENTS jika terdapat upload file/dokumen/gambar
    if (currentAttachmentName != null || _attachmentFile != null || _attachmentImagePath != null) {
      await _saveUploadedDocument(
        fileName: currentAttachmentName ?? (_isImageAttachment ? "Foto_Unggahan.jpg" : "Dokumen_Unggahan.pdf"),
        filePath: currentAttachmentPath ?? '',
        fileSnippet: response,
        fileType: currentFileType ?? 'DOKUMEN',
        isImage: _isImageAttachment,
      );
    }

    if (mounted) {
      context.showSnackBar(AppStrings.chatSavedAlert);
    }

    _speakText(response);
    _clearAttachment();
  }

  Future<void> _saveUploadedDocument({
    required String fileName,
    required String filePath,
    required String fileSnippet,
    required String fileType,
    required bool isImage,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? existingJson = prefs.getString(AppConstants.keyUploadedDocuments);
      List<dynamic> list = [];
      if (existingJson != null) {
        try {
          list = jsonDecode(existingJson);
        } catch (_) {}
      }
      
      final String ext = fileType.toUpperCase();
      String category = 'DOKUMEN';
      if (['PNG', 'JPG', 'JPEG', 'WEBP'].contains(ext)) {
        category = 'FOTO';
      } else if (['XLS', 'XLSX'].contains(ext)) {
        category = 'EXCEL';
      } else if (['DOC', 'DOCX'].contains(ext)) {
        category = 'WORD';
      } else if (['PPT', 'PPTX'].contains(ext)) {
        category = 'PPT';
      } else if (ext == 'PDF') {
        category = 'PDF';
      }

      final newItem = {
        'id': 'up_${DateTime.now().millisecondsSinceEpoch}',
        'title': fileName,
        'category': category,
        'ext': ext,
        'filePath': filePath,
        'snippet': fileSnippet.length > 200 ? '${fileSnippet.substring(0, 200)}...' : fileSnippet,
        'timestamp': 'Baru saja',
      };

      list.removeWhere((item) => item['title'] == fileName);
      list.insert(0, newItem);
      await prefs.setString(AppConstants.keyUploadedDocuments, jsonEncode(list));
    } catch (e) {
      debugPrint('Error saving uploaded document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFEFF5FE),
      body: SizedBox.expand(
        child: BackgroundWrapper(
          child: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Salam & Foto Profil (Posisi Permanen Kiri & Kanan)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.greetingUser,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : ScreenColorHelper.getHeadingText(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.subtitleDashboard,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: isDark ? const Color(0xFF8E9BB0) : ScreenColorHelper.getBodyText(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Icon Pen / Magic Wand untuk membuat baris baru
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _promptController.text += '\n';
                      });
                      _promptFocusNode.requestFocus();
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161E38) : ScreenColorHelper.getSurfaceColor(context),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? const Color(0xFF2E3D6E) : AppColors.navyPrimary.withValues(alpha: 0.2),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? const Color(0xFF6366F1).withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.05),
                            blurRadius: isDark ? 10 : 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'asset/ic_pen.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.auto_fix_high_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ValueListenableBuilder<String?>(
                    valueListenable: userPhotoNotifier,
                    builder: (context, photoPath, child) {
                      return GestureDetector(
                        key: const ValueKey('dashboard_profile_avatar_btn'),
                        onTap: () {
                          _showProfileMenu(context);
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? const Color(0xFF818CF8) : AppColors.navyPrimary,
                              width: 2,
                            ),
                            boxShadow: isDark
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.45),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: photoPath != null && File(photoPath).existsSync()
                              ? ClipOval(
                            child: Image.file(
                              File(photoPath),
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                            ),
                          )
                              : photoPath != null && photoPath.startsWith('avatar:')
                                  ? ClipOval(
                                      child: AvatarCharacterWidget(
                                        character: AvatarCharacterList.getById(
                                          photoPath.replaceFirst('avatar:', ''),
                                        ),
                                        size: 44,
                                      ),
                                    )
                                  : ClipOval(
                                      child: Image.asset(
                                        'asset/img.png',
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const CircularImageView(
                                          imagePath: 'asset/ic_user.png',
                                          size: 44,
                                        ),
                                      ),
                                    ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // 2. Logo Cerdas AI di Tengah (Sesuai Referensi Gambar 1)
              const Center(
                child: CerdasAiLogoBadge(size: 165),
              ),

              const SizedBox(height: 50),

              // 3. Card Box Input Pertanyaan
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131A32) : ScreenColorHelper.getSurfaceColor(context),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? const Color(0xFF222E54) : Colors.black.withValues(alpha: 0.06),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
                      blurRadius: isDark ? 24 : 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Preview Lampiran Berkas
                    if (_attachmentFile != null || (_attachmentImagePath != null && _attachmentImagePath!.isNotEmpty))
                      AttachmentPreviewCard(
                        file: _attachmentFile,
                        imagePath: _attachmentImagePath,
                        isNetwork: _isAttachmentNetwork,
                        fileName: _attachmentName,
                        icon: _attachmentIcon,
                        isImage: _isImageAttachment,
                        onRemove: _clearAttachment,
                      ),

                    // Input Text (Mengikuti kolom tanpa garis/border inset terpisah)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: TextField(
                        controller: _promptController,
                        focusNode: _promptFocusNode,
                        maxLines: null,
                        minLines: 2,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : ScreenColorHelper.getHeadingText(context),
                        ),
                        decoration: InputDecoration(
                          hintText: AppStrings.hintTypeQuestion,
                          hintStyle: TextStyle(
                            color: isDark ? const Color(0xFF64748B) : ScreenColorHelper.getBodyText(context).withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Baris Tombol Lampirkan (+), Riwayat Percakapan, Mic, & Kirim Gradient Pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Tombol (+) Tambah Lampiran
                            InkWell(
                              onTap: _showAttachmentSheet,
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E284A) : ScreenColorHelper.getPrimaryAction(context).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF2E3E6E) : Colors.transparent,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: isDark ? const Color(0xFF818CF8) : ScreenColorHelper.getPrimaryAction(context),
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Tombol Riwayat Percakapan
                            InkWell(
                              onTap: _showHistorySheet,
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                                child: Row(
                                  children: [
                                    Text(
                                      AppStrings.btnHistoryChat,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : ScreenColorHelper.getHeadingText(context),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(
                                      Icons.history_rounded,
                                      size: 18,
                                      color: isDark ? const Color(0xFF8E9BB0) : ScreenColorHelper.getBodyText(context).withValues(alpha: 0.6),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Icon Rekam Suara (Mic)
                            InkWell(
                              onTap: _startVoiceInput,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: _isListening
                                      ? Colors.redAccent.withValues(alpha: 0.2)
                                      : (isDark ? const Color(0xFF1A2342) : Colors.transparent),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _isListening
                                        ? Colors.redAccent
                                        : (isDark ? const Color(0xFF2E3D6E) : Colors.transparent),
                                  ),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'asset/ic_microphone.png',
                                    width: 20,
                                    height: 20,
                                    color: _isListening ? Colors.redAccent : (isDark ? const Color(0xFF818CF8) : null),
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      Icons.mic_rounded,
                                      size: 20,
                                      color: _isListening ? Colors.redAccent : (isDark ? const Color(0xFF818CF8) : AppColors.iconTint),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Tombol Kirim Gradient Pill
                            InkWell(
                              onTap: _processUserQuery,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 38,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFA855F7), Color(0xFF3B82F6)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.45),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 4. Card Respon AI (Jawaban di bawah kolom pertanyaan)
              if (_showResponseCard) ...[
                const SizedBox(height: 16),
                AiResponseCard(
                  response: _aiResponseText,
                  isThinking: _isAiThinking,
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
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
}
