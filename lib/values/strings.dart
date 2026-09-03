import 'package:flutter/material.dart';
import '../widgets/language_option_widget.dart';

class AppStrings {
  /// Helper untuk mengambil string berdasarkan Locale aktif saat ini
  static String _get(Map<String, String> map) {
    final String langCode = appLocaleNotifier.value.languageCode;
    return map[langCode] ?? map['id'] ?? map['in'] ?? '';
  }

  // ===========================================================================
  // BRAND & GENERAL
  // ===========================================================================
  static String get appName => 'Cerdas AI';
  static String get brandCerdas => 'Cerdas ';
  static String get brandAi => 'AI';
  
  static String get sloganApp => _get({
    'id': 'Asisten AI Pintar Indonesia',
    'en': 'Smart AI Assistant Indonesia',
  });

  static String get btnBack => _get({'id': 'Kembali', 'en': 'Back'});
  static String get dividerOr => _get({'id': 'atau masuk dengan', 'en': 'or sign in with'});

  // ===========================================================================
  // ACTIVITY: LOGIN & REGISTER
  // ===========================================================================
  static String get labelEmail => _get({'id': 'Alamat Email', 'en': 'Email Address'});
  static String get hintEmail => _get({'id': 'Masukkan email', 'en': 'Enter email'});
  static String get labelPassword => _get({'id': 'Kata Sandi', 'en': 'Password'});
  static String get hintPassword => _get({'id': 'Masukkan password', 'en': 'Enter password'});
  static String get actionLupaPassword => _get({'id': 'Lupa Kata Sandi?', 'en': 'Forgot Password?'});
  static String get btnMasuk => _get({'id': 'Masuk', 'en': 'Login'});
  static String get promptBelumPunyaAkun => _get({'id': 'Belum punya akun? ', 'en': 'Don\'t have an account? '});
  static String get actionDaftar => _get({'id': 'Daftar', 'en': 'Register'});
  static String get titleDaftar => _get({'id': 'Buat Akun Baru', 'en': 'Create New Account'});
  static String get subtitleDaftar => _get({'id': 'Bergabunglah dengan Cerdas AI', 'en': 'Join Cerdas AI'});
  static String get labelNamaLengkap => _get({'id': 'Nama Lengkap', 'en': 'Full Name'});
  static String get hintNamaLengkap => _get({'id': 'Masukkan nama lengkap', 'en': 'Enter full name'});
  static String get labelTempatLahir => _get({'id': 'Tempat Lahir', 'en': 'Place of Birth'});
  static String get labelTanggalLahir => _get({'id': 'Tanggal Lahir', 'en': 'Date of Birth'});
  static String get labelJenisKelamin => _get({'id': 'Jenis Kelamin', 'en': 'Gender'});
  static String get hintJenisKelamin => _get({'id': 'Pilih jenis kelamin', 'en': 'Select gender'});
  static String get labelAlamat => _get({'id': 'Alamat', 'en': 'Address'});
  static String get hintAlamat => _get({'id': 'Masukkan alamat lengkap', 'en': 'Enter full address'});
  static String get labelEmailAddr => _get({'id': 'Alamat Email', 'en': 'Email Address'});
  static String get hintEmailDaftar => 'contoh@gmail.com';
  static String get hintPasswordDaftar => _get({'id': 'Minimal 6 karakter', 'en': 'Min 6 characters'});
  static String get labelKonfirmasiPassword => _get({'id': 'Konfirmasi Kata Sandi', 'en': 'Confirm Password'});
  static String get hintKonfirmasiPassword => _get({'id': 'Ulangi kata sandi Anda', 'en': 'Repeat your password'});
  static String get termsAndConditions => _get({'id': 'Saya menyetujui Syarat & Ketentuan', 'en': 'I agree to the Terms & Conditions'});
  static String get btnDaftar => _get({'id': 'Daftar', 'en': 'Register'});
  static String get promptSudahPunyaAkun => _get({'id': 'Sudah punya akun? ', 'en': 'Already have an account? '});
  static String get actionMasuk => _get({'id': 'Masuk', 'en': 'Login'});

  // ===========================================================================
  // PASSWORD RECOVERY
  // ===========================================================================
  static String get titleLupaPassword => _get({'id': 'Lupa Kata Sandi', 'en': 'Forgot Password'});
  static String get headingResetPassword => _get({'id': 'Atur Ulang Kata Sandi', 'en': 'Reset Password'});
  static String get headingSandiBaru => _get({'id': 'Sandi Baru', 'en': 'New Password'});
  static String get descSandiBaru => _get({'id': 'Buat kata sandi baru yang kuat.', 'en': 'Create a strong new password.'});
  static String get labelPasswordBaru => _get({'id': 'Kata Sandi Baru', 'en': 'New Password'});
  static String get hintPasswordBaru => _get({'id': 'Masukkan kata sandi baru', 'en': 'Enter new password'});
  static String get labelKonfirmasiPasswordBaru => _get({'id': 'Konfirmasi Kata Sandi Baru', 'en': 'Confirm New Password'});
  static String get hintKonfirmasiPasswordBaru => _get({'id': 'Ulangi kata sandi baru Anda', 'en': 'Repeat new password'});
  static String get btnSimpanPassword => _get({'id': 'Simpan Kata Sandi', 'en': 'Save Password'});
  static String get titlePasswordBaru => _get({'id': 'Buat Password Baru', 'en': 'Create New Password'});
  static String get hintConfirmPassword => _get({'id': 'Ulangi kata sandi Anda', 'en': 'Repeat your password'});
  static String get headingPasswordDiubah => _get({'id': 'Kata Sandi Telah Berubah!', 'en': 'Password Changed!'});
  static String get descPasswordDiubah => _get({'id': 'Kata sandi Anda telah berhasil diperbarui.', 'en': 'Your password has been successfully updated.'});
  static String get btnKembaliLogin => _get({'id': 'Kembali ke Halaman Login', 'en': 'Back to Login'});

  // ===========================================================================
  // DASHBOARD & ACTIVITY
  // ===========================================================================
  static String get greetingUser => _get({'id': 'Halo, Pengguna!', 'en': 'Hello, User!'});
  static String get subtitleDashboard => _get({'id': 'Apa yang ingin kamu tanyakan hari ini?', 'en': 'What would you like to ask today?'});
  static String get hintTypeQuestion => _get({'id': 'Ketik pertanyaan disini...', 'en': 'Type your question here...'});
  static String get btnKamera => _get({'id': 'Kamera', 'en': 'Camera'});
  static String get btnSuara => _get({'id': 'Suara', 'en': 'Voice'});
  static String get btnGaleri => _get({'id': 'Galeri', 'en': 'Gallery'});
  static String get sectionUploadDokumen => _get({'id': 'Upload Dokumen', 'en': 'Upload Documents'});
  static String get descAttachment => _get({'id': 'Lampirkan File', 'en': 'Attach File'});
  static String get titleAktivitas => _get({'id': 'Aktivitas', 'en': 'Activity'});
  static String get hintSearchRiwayat => _get({'id': 'Cari riwayat pertanyaan..', 'en': 'Search question history..'});
  static String get filterSemua => _get({'id': 'Semua', 'en': 'All'});
  static String get filterDokumen => _get({'id': 'Dokumen', 'en': 'Documents'});
  static String get filterFoto => _get({'id': 'Foto', 'en': 'Photos'});
  static String get filterTeks => _get({'id': 'Teks', 'en': 'Text'});
  static String get actionHapus => _get({'id': 'Hapus', 'en': 'Delete'});

  // ===========================================================================
  // SETTINGS & PROFILE
  // ===========================================================================
  static String get titleNotifikasi => _get({'id': 'Notifikasi', 'en': 'Notifications'});
  static String get actionTandaiDibaca => _get({'id': 'Tandai Dibaca', 'en': 'Mark as Read'});
  static String get appVersion => 'Versi 1.0';
  static String get titleTentang => _get({'id': 'Tentang Aplikasi', 'en': 'About Application'});
  static String get appNameFull => 'Cerdas AI - Asisten Pintar';
  static String get appDescription => _get({'id': 'Cerdas AI adalah aplikasi asisten pintar.', 'en': 'Cerdas AI is a smart assistant application.'});
  static String get appVersionLabel => _get({'id': 'Versi Aplikasi', 'en': 'App Version'});
  static String get developerLabel => _get({'id': 'Dikembangkan Oleh', 'en': 'Developed By'});
  static String get developerName => 'Tim Inovasi Cerdas AI';
  static String get contactUs => _get({'id': 'Hubungi Kami', 'en': 'Contact Us'});
  static String get contactEmail => 'support@aicerdas.com';
  static String get titleEditProfil => _get({'id': 'Edit Profil', 'en': 'Edit Profile'});
  static String get actionChangePhoto => _get({'id': 'Ubah Foto', 'en': 'Change Photo'});
  static String get labelPersonalInfo => _get({'id': 'Informasi Pribadi', 'en': 'Personal Information'});
  static String get labelFullName => _get({'id': 'Nama Lengkap', 'en': 'Full Name'});
  static String get labelDob => _get({'id': 'Tanggal Lahir', 'en': 'Date of Birth'});
  static String get hintDob => _get({'id': 'Pilih Tanggal', 'en': 'Select Date'});
  static String get labelPhone => _get({'id': 'Nomor Telepon', 'en': 'Phone Number'});
  static String get hintPhone => _get({'id': 'Masukkan Nomor Telepon', 'en': 'Enter Phone Number'});
  static String get labelGender => _get({'id': 'Jenis Kelamin', 'en': 'Gender'});
  static String get genderMale => _get({'id': 'Laki-laki', 'en': 'Male'});
  static String get genderFemale => _get({'id': 'Perempuan', 'en': 'Female'});
  static String get actionSaveChanges => _get({'id': 'Simpan Perubahan', 'en': 'Save Changes'});
  static String get titleUbahBahasa => _get({'id': 'Ubah Bahasa', 'en': 'Change Language'});
  static String get menuInformasi => _get({'id': 'Informasi', 'en': 'Information'});
  static String get titleDokumenTersimpan => _get({'id': 'Dokumen Tersimpan', 'en': 'Saved Documents'});

  // ===========================================================================
  // LOGIN WITH GOOGLE & APPLE
  // ===========================================================================
  static String get btnGoogle => 'Google';
  static String get btnApple => 'Apple';

  static String get titleLoginGoogle => _get({
    'id': 'Login dengan Google',
    'en': 'Login with Google',
  });

  static String get headingGoogleCerdas => _get({
    'id': 'Cerdas AI x Google',
    'en': 'Cerdas AI x Google',
  });

  static String get descGoogleLogin => _get({
    'id': 'Masuk dengan akun Google Anda untuk akses cepat dan aman ke Cerdas AI.',
    'en': 'Sign in with your Google account for fast and secure access to Cerdas AI.',
  });

  static String get statusMencariAkun => _get({
    'id': 'Mencari akun Google di perangkat...',
    'en': 'Searching for Google account on device...',
  });

  static String get btnPilihAkun => _get({
    'id': 'Pilih Akun Google',
    'en': 'Choose Google Account',
  });

  static String get titleLoginApple => _get({
    'id': 'Login dengan Apple ID',
    'en': 'Login with Apple ID',
  });

  static String get headingAppleCerdas => _get({
    'id': 'Cerdas AI x Apple',
    'en': 'Cerdas AI x Apple',
  });

  static String get descAppleLogin => _get({
    'id': 'Masuk dengan Apple ID Anda untuk menjaga privasi dan keamanan tingkat tinggi.',
    'en': 'Sign in with your Apple ID to maintain high privacy and security.',
  });

  static String get statusMencariAkunApple => _get({
    'id': 'Menghubungkan ke Apple Web Auth...',
    'en': 'Connecting to Apple Web Auth...',
  });

  static String get btnMasukApple => _get({
    'id': 'Masuk dengan Apple ID',
    'en': 'Sign in with Apple ID',
  });

  // ===========================================================================
  // OTHERS
  // ===========================================================================
  static String get hintPencarian => _get({'id': 'Cari di Cerdas AI...', 'en': 'Search in Cerdas AI...'});
  static String get searchResultPrefix => _get({'id': 'Hasil pencarian untuk: ', 'en': 'Search results for: '});
  static String get hintStartSearch => _get({'id': 'Mulai ketik untuk mencari...', 'en': 'Start typing to search...'});
}
