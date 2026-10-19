import 'package:flutter/material.dart';
import '../helpers/camera_card_helper.dart';
import '../values/colors.dart';

class CameraScanCardWidget extends StatefulWidget {
  const CameraScanCardWidget({super.key});

  @override
  State<CameraScanCardWidget> createState() => _CameraScanCardWidgetState();
}

class _CameraScanCardWidgetState extends State<CameraScanCardWidget> {
  bool _isScanning = false;

  void _toggleScanning() {
    setState(() {
      _isScanning = !_isScanning;
    });

    // Simulasi proses pemindaian selama 3 detik
    if (_isScanning) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isScanning = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pemindaian selesai!')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      // Menerapkan dekorasi dari CameraCardHelper
      decoration: CameraCardHelper.getCardDecoration(isScanning: _isScanning),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isScanning ? Icons.document_scanner : Icons.camera_alt_outlined,
            size: 48,
            color: _isScanning ? Colors.green.shade700 : AppColors.indigoPrimary,
          ),
          const SizedBox(height: 12),

          // Menerapkan teks status dari CameraCardHelper
          Text(
            CameraCardHelper.getStatusText(isScanning: _isScanning),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _isScanning ? Colors.green.shade700 : AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _toggleScanning,
            icon: Icon(_isScanning ? Icons.stop : Icons.camera),
            label: Text(_isScanning ? 'Batal' : 'Mulai Pindai'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isScanning ? Colors.redAccent : AppColors.indigoPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}