import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../core/app_constants.dart';
import '../../helpers/helpers.dart';
import '../../menu/menu.dart';
import '../../service/gemini_service.dart';
import '../../values/colors.dart';
import '../../values/strings.dart';
import '../../widgets/ai_response_card.dart';
import '../../widgets/attachment_preview_card.dart';
import '../../widgets/circular_image_view.dart';
import '../../widgets/bottom_navigation_view_widget.dart';
import '../../widgets/language_option_widget.dart';
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
  ChatHistoryItem({required this.question, required this.answer});

  Map<String, dynamic> toJson() => {'q': question, 'a': answer};
  factory ChatHistoryItem.fromJson(Map<String, dynamic> json) => 
      ChatHistoryItem(question: json['q'], answer: json['a']);
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _promptController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final ImagePicker _imagePicker = ImagePicker();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  // State variabel
  File? _attachmentFile;
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

      _showAttachmentPreview(
        file: file,
        name: result.files.single.name,
        icon: isImage ? Icons.image : Icons.description,
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
          localeId: appLocaleNotifier.value.languageCode == 'id' ? 'id_ID' : 'en_US',
          listenOptions: stt.SpeechListenOptions(
            cancelOnError: true,
            partialResults: true,
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
                      imageAsset: 'asset/ic_drive.png',
                      label: AppStrings.labelDrive,
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppStrings.driveFeatureAlert)),
                        );
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

  void _showHistorySheet() {
    String searchQuery = "";

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
            final filteredHistory = _chatHistory
                .where((item) =>
                    item.question.toLowerCase().contains(searchQuery.toLowerCase()) ||
                    item.answer.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
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
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.btnHistoryChat,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: headingColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: headingColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Search Bar inside History
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: TextField(
                      style: TextStyle(color: headingColor, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: AppStrings.historySearchHint,
                        hintStyle: TextStyle(color: bodyColor.withValues(alpha: 0.5)),
                        prefixIcon: Icon(Icons.search_rounded, size: 20, color: bodyColor),
                        filled: true,
                        fillColor: bodyColor.withValues(alpha: 0.05),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) {
                        setModalState(() {
                          searchQuery = val;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!_isLoadingHistory && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                          // Simulasi Loading Saat Scroll ke Bawah
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
                              setState(() {}); // Update state utama juga agar data sinkron
                            }
                          });
                        }
                        return true;
                      },
                      child: filteredHistory.isEmpty 
                        ? Center(
                            child: Text(
                              AppStrings.historyEmptyResult, 
                              style: TextStyle(color: bodyColor),
                            ),
                          )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredHistory.length + (_isLoadingHistory ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == filteredHistory.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            final item = filteredHistory[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _promptController.text = item.question;
                                  _cachedAnswer = item.answer;
                                  _showResponseCard = false; // Reset respon dulu, tunggu tombol "Kirim"
                                });
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: bodyColor.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: bodyColor.withValues(alpha: 0.1)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Baris Pertanyaan
                                    Row(
                                      children: [
                                        const Icon(Icons.person_outline, size: 16, color: Colors.blueGrey),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.question,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: headingColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Baris Jawaban AI
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.psychology, size: 16, color: ScreenColorHelper.getPrimaryAction(context)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.answer,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 13, color: headingColor),
                                          ),
                                        ),
                                      ],
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
            );
          },
        );
      },
    );
  }

  // 5. Pemrosesan Pertanyaan AI
  Future<void> _processUserQuery() async {
    final prompt = _promptController.text.trim();

    if (prompt.isEmpty && _attachmentFile == null) {
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
      _aiResponseText = _attachmentFile != null
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
      
      // Simpan otomatis ke Riwayat Percakapan (Tambahkan ke paling atas)
      final String historyQuestion = prompt.isNotEmpty 
          ? prompt 
          : (_isImageAttachment ? "Analisis Gambar" : "Analisis Dokumen");
          
      // Hapus jika sudah ada (agar pindah ke atas)
      _chatHistory.removeWhere((item) => item.question == historyQuestion);
      _chatHistory.insert(0, ChatHistoryItem(question: historyQuestion, answer: response));
    });

    await _saveChatHistory(); // Simpan secara permanen

    if (mounted) {
      context.showSnackBar(AppStrings.chatSavedAlert);
    }

    _speakText(response);
    _clearAttachment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ScreenColorHelper.getHeadingText(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.subtitleDashboard,
                          style: TextStyle(
                            fontSize: 13,
                            color: ScreenColorHelper.getBodyText(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ValueListenableBuilder<String?>(
                    valueListenable: userPhotoNotifier,
                    builder: (context, photoPath, child) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/setting');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.navyPrimary, width: 2),
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
                              : const CircularImageView(
                            imagePath: 'asset/ic_user.png',
                            size: 44,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // 2. Logo Cerdas AI di Tengah
              Center(
                child: Image.asset(
                  AppConstants.logoPath,
                  width: 180,
                  height: 180,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.psychology_rounded,
                      size: 140,
                      color: AppColors.tealAccent,
                    );
                  },
                ),
              ),

              const SizedBox(height: 60),

              // 3. Card Box Input Pertanyaan
              Card(
                elevation: 2,
                color: ScreenColorHelper.getSurfaceColor(context),
                shadowColor: ScreenColorHelper.getPrimaryAction(context).withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Preview Lampiran Berkas
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
                        focusNode: _promptFocusNode,
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

                      // Tombol Lampirkan, Mic, & Kirim
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.add_circle_outline, color: ScreenColorHelper.getPrimaryAction(context), size: 28),
                                onPressed: _showAttachmentSheet,
                                tooltip: AppStrings.descAttachment,
                              ),
                              // Tombol History Chat
                              InkWell(
                                onTap: _showHistorySheet,
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        AppStrings.btnHistoryChat,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ScreenColorHelper.getHeadingText(context),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.history_rounded,
                                        size: 18,
                                        color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.6),
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
                              IconButton(
                                icon: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _isListening ? Colors.redAccent.withValues(alpha: 0.1) : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'asset/ic_microphone.png',
                                    width: 24,
                                    height: 24,
                                    color: _isListening ? Colors.redAccent : null,
                                    errorBuilder: (context, error, stackTrace) => 
                                        Icon(Icons.mic_rounded, color: _isListening ? Colors.redAccent : AppColors.iconTint),
                                  ),
                                ),
                                onPressed: _startVoiceInput,
                                tooltip: _isListening ? 'Berhenti Rekam' : 'Rekam Suara',
                              ),
                              const SizedBox(width: 8),
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
                    ],
                  ),
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