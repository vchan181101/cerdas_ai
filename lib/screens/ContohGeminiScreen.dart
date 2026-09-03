import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cerdas_ai/service/gemini_service.dart'; // Sesuaikan path

class ContohGeminiScreen extends StatefulWidget {
  const ContohGeminiScreen({super.key});

  @override
  State<ContohGeminiScreen> createState() => _ContohGeminiScreenState();
}

class _ContohGeminiScreenState extends State<ContohGeminiScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _hasilAI = "Hasil analisis AI akan muncul di sini...";
  bool _isLoading = false;

  // Fungsi memanggil API Teks
  Future<void> _kirimPromptTeks() async {
    if (_promptController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasilAI = "Sedang berpikir...";
    });

    final response = await GeminiService.generateText(_promptController.text);

    setState(() {
      _hasilAI = response;
      _isLoading = false;
    });
  }

  // Fungsi memanggil Analisis Gambar (Misal untuk dokumen di InformasiScreen)
  Future<void> _analisisGambarDokumen(String imagePath) async {
    setState(() {
      _isLoading = true;
      _hasilAI = "Menganalisis dokumen...";
    });

    final File file = File(imagePath);
    final response = await GeminiService.generateFromImage(
      imageFile: file,
      prompt: "Analisis isi dokumen ini dan berikan ringkasan pentingnya.",
    );

    setState(() {
      _hasilAI = response;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tanya Gemini AI")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: "Tulis pertanyaan...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _kirimPromptTeks,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Kirim ke Gemini"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _hasilAI,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}