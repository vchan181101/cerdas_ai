import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cerdas_ai/data/models/gemini_tier.dart';
import 'package:cerdas_ai/data/service/ai_service.dart';

class ChatMessage {
  final String id;
  String text;
  final bool isUser;
  final DateTime timestamp;
  final String? imagePath;
  bool isStreaming;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imagePath,
    this.isStreaming = false,
  });
}

class ChatProvider extends ChangeNotifier {
  final AiService _aiService = AiService();

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  GeminiTier _selectedTier = GeminiTier.free;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  GeminiTier get selectedTier => _selectedTier;

  /// Mengubah Tier Gemini (Free, Plus, Pro, Ultra)
  void setTier(GeminiTier tier) {
    _selectedTier = tier;
    notifyListeners();
  }

  /// 1. Mengirim Pesan Teks ke AI (Balasan Utuh Sekaligus)
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    // Tambah pesan user
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final aiResponse = await _aiService.generateText(
        trimmed,
        tier: _selectedTier,
      );

      final aiMsg = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(aiMsg);
    } catch (e) {
      _errorMessage = 'Gagal memproses pesan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 2. Mengirim Pesan Teks dengan Efek Mengetik / Streaming Respons
  Future<void> sendMessageStream(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);

    final aiMsg = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
      isStreaming: true,
    );
    _messages.add(aiMsg);

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final stream = _aiService.generateTextStream(
        trimmed,
        tier: _selectedTier,
      );

      await for (final chunk in stream) {
        aiMsg.text += chunk;
        notifyListeners();
      }
    } catch (e) {
      aiMsg.text += '\n\n[Terjadi kesalahan saat memproses streaming: $e]';
      _errorMessage = e.toString();
    } finally {
      aiMsg.isStreaming = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 3. Mengirim Gambar + Teks Pertanyaan (Multimodal)
  Future<void> sendImageMessage({
    required File imageFile,
    required String prompt,
  }) async {
    final trimmedPrompt = prompt.trim().isEmpty ? 'Jelaskan gambar ini' : prompt.trim();

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmedPrompt,
      isUser: true,
      timestamp: DateTime.now(),
      imagePath: imageFile.path,
    );
    _messages.add(userMsg);

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final aiResponse = await _aiService.generateFromImage(
        imageFile: imageFile,
        prompt: trimmedPrompt,
        tier: _selectedTier,
      );

      final aiMsg = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(aiMsg);
    } catch (e) {
      _errorMessage = 'Gagal memproses gambar: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 4. Hapus Riwayat Percakapan
  void clearChat() {
    _messages.clear();
    _errorMessage = null;
    notifyListeners();
  }
}
