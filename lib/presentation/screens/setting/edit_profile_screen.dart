import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cerdas_ai/core/values/colors.dart';
import 'package:cerdas_ai/core/values/strings.dart';
import 'package:cerdas_ai/presentation/widgets/widgets.dart';
import 'package:cerdas_ai/core/helpers/helpers.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _gender = 'Laki-laki';
  File? _selectedImageFile;
  String? _selectedAvatarId;
  String? _savedPhotoPath;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // 1. Memuat Data Profil dari SharedPreferences
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullNameController.text = prefs.getString('USER_NAME') ?? '';
      _emailController.text = prefs.getString('USER_EMAIL') ?? 'user.cerdas@gmail.com';
      _dobController.text = prefs.getString('USER_DOB') ?? '';
      _phoneController.text = prefs.getString('USER_PHONE') ?? '';

      final storedGender = prefs.getString('USER_GENDER') ?? 'Laki-laki';
      if (storedGender.isNotEmpty) {
        _gender = storedGender;
      }

      _savedPhotoPath = prefs.getString('USER_PHOTO_URI');
      if (_savedPhotoPath != null) {
        if (_savedPhotoPath!.startsWith('avatar:')) {
          _selectedAvatarId = _savedPhotoPath!.replaceFirst('avatar:', '');
          _selectedImageFile = null;
        } else if (File(_savedPhotoPath!).existsSync()) {
          _selectedImageFile = File(_savedPhotoPath!);
          _selectedAvatarId = null;
        }
      }
    });
  }

  // 2. Membuka Modal Bottom Sheet Pemilih Avatar Karakter (Sesuai Gambar 2)
  void _openAvatarPicker() {
    AvatarCharacterPickerSheet.show(
      context: context,
      currentAvatarId: _selectedAvatarId,
      currentCustomFile: _selectedImageFile,
      onSelected: (selectedAvatar, customFile) async {
        setState(() {
          _selectedImageFile = customFile;
          if (customFile != null) {
            _selectedAvatarId = null;
          } else if (selectedAvatar != null) {
            _selectedAvatarId = selectedAvatar.id;
          }
        });
        if (customFile != null) {
          await UserProfileHelper.updatePhoto(customFile.path);
        } else if (selectedAvatar != null) {
          await UserProfileHelper.updatePhoto('avatar:${selectedAvatar.id}');
        }
      },
    );
  }

  // Helper widget untuk merender foto atau avatar terpilih
  Widget _buildProfileAvatar() {
    if (_selectedImageFile != null && _selectedImageFile!.existsSync()) {
      return Image.file(
        _selectedImageFile!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
    if (_selectedAvatarId != null) {
      final character = AvatarCharacterList.getById(_selectedAvatarId!);
      return AvatarCharacterWidget(
        character: character,
        size: 100,
      );
    }
    return Image.asset(
      'asset/img.png',
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'asset/ic_user.png',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }

  // 3. Pemilih Tanggal Lahir (DatePicker)
  Future<void> _selectDateOfBirth() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.indigoPrimary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  // 4. Menyimpan Profil ke SharedPreferences
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('USER_NAME', _fullNameController.text.trim());
    await prefs.setString('USER_DOB', _dobController.text.trim());
    await prefs.setString('USER_PHONE', _phoneController.text.trim());
    await prefs.setString('USER_GENDER', _gender);

    if (_selectedImageFile != null) {
      await UserProfileHelper.updatePhoto(_selectedImageFile!.path);
    } else if (_selectedAvatarId != null) {
      await UserProfileHelper.updatePhoto('avatar:$_selectedAvatarId');
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header / Top Bar
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, size: 24, color: ScreenColorHelper.getHeadingText(context)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.titleEditProfil,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ScreenColorHelper.getHeadingText(context),
                    ),
                  ),
                ],
              ),
            ),

            // Form Konten Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Ubah Foto Profil
                      Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: _openAvatarPicker,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ScreenColorHelper.getPrimaryAction(context),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: _buildProfileAvatar(),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _openAvatarPicker,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.15),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    size: 18,
                                    color: ScreenColorHelper.getPrimaryAction(context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      Center(
                        child: TextButton(
                          onPressed: _openAvatarPicker,
                          child: Text(
                            AppStrings.actionChangePhoto,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ScreenColorHelper.getPrimaryAction(context),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Section 2: Informasi Pribadi
                      Text(
                        AppStrings.labelPersonalInfo,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ScreenColorHelper.getHeadingText(context),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Input Nama Lengkap
                      Text(
                        AppStrings.labelFullName,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ScreenColorHelper.getHeadingText(context)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _fullNameController,
                        style: TextStyle(fontSize: 14, color: ScreenColorHelper.getHeadingText(context)),
                        decoration: _buildInputDecoration(hint: AppStrings.hintNamaLengkap),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Input Tanggal Lahir
                      Text(
                        AppStrings.labelDob,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ScreenColorHelper.getHeadingText(context)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _dobController,
                        readOnly: true,
                        onTap: _selectDateOfBirth,
                        style: TextStyle(fontSize: 14, color: ScreenColorHelper.getHeadingText(context)),
                        decoration: _buildInputDecoration(
                          hint: AppStrings.hintDob,
                          suffixIcon: Icon(Icons.calendar_month_rounded, color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.5)),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Input Nomor Telepon
                      Text(
                        AppStrings.labelPhone,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ScreenColorHelper.getHeadingText(context)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 14, color: ScreenColorHelper.getHeadingText(context)),
                        decoration: _buildInputDecoration(hint: AppStrings.hintPhone),
                      ),

                      const SizedBox(height: 16),

                      // Input Alamat Email
                      Text(
                        AppStrings.labelEmailAddr,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ScreenColorHelper.getHeadingText(context)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        enabled: false,
                        style: TextStyle(fontSize: 14, color: ScreenColorHelper.getBodyText(context)),
                        decoration: _buildInputDecoration(hint: AppStrings.hintEmail),
                      ),

                      const SizedBox(height: 16),

                      // Radio Button Jenis Kelamin
                      Text(
                        AppStrings.labelGender,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ScreenColorHelper.getHeadingText(context)),
                      ),
                      const SizedBox(height: 8),
                      RadioGroup<String>(
                        groupValue: _gender,
                        onChanged: (value) {
                          if (value != null) setState(() => _gender = value);
                        },
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Laki-laki',
                                  activeColor: ScreenColorHelper.getPrimaryAction(context),
                                ),
                                Text(AppStrings.genderMale),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Perempuan',
                                  activeColor: ScreenColorHelper.getPrimaryAction(context),
                                ),
                                Text(AppStrings.genderFemale),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Action Button (Simpan Perubahan)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: AppButton(
                text: AppStrings.actionSaveChanges,
                onPressed: _saveProfile,
                backgroundColor: ScreenColorHelper.getPrimaryAction(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Custom Input Decoration
  InputDecoration _buildInputDecoration({required String hint, Widget? suffixIcon}) {
    return ScreenStyleHelper.modernInputDecoration(
      context: context,
      hintText: hint,
      prefixIcon: Icons.edit_rounded,
      suffixIcon: suffixIcon,
    ).copyWith(
      fillColor: ScreenColorHelper.getSurfaceColor(context).withValues(alpha: 0.8),
    );
  }
}