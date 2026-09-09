import '../widgets/language_option_widget.dart';

class AppStrings {
  /// Helper untuk mengambil string berdasarkan Locale aktif saat ini
  static String _get(Map<String, String> map) {
    try {
      final String langCode = appLocaleNotifier.value.languageCode;
      return map[langCode] ?? map['id'] ?? map['in'] ?? map['en'] ?? '';
    } catch (_) {
      return map['id'] ?? map['in'] ?? map['en'] ?? '';
    }
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
    'es': 'Asistente de IA inteligente Indonesia',
    'zh': '印度尼西亚智能人工智能助手',
    'ja': 'インドネシアのスマートAIアシスタント',
    'ar': 'مساعد ذكاء اصطناعي ذكي إندونيسيا',
    'fr': 'Assistant IA intelligent Indonésie',
    'ru': 'Умный помощник с искусственным интеллектом Индонезия',
    'th': 'ผู้ช่วย AI อัจฉริยะอินโดนีเซีย',
    'it': 'Assistente IA intelligente Indonesia',
    'tr': 'Akıllı yapay zeka asistanı Endonezya',
    'ko': '인도네시아 스마트 AI 비서',
    'hi': 'इंडोनेशियाईスマート एआई सहायक',
    'pt': 'Assistente de IA inteligente Indonésia',
    'vi': 'Trợ lý AI thông minh Indonesia',
    'km': 'ជំនួយការ AI ឆ្លាតវៃឥណ្ឌូនេស៊ី',
    'lo': 'ຜູ້ຊ່ວយ AI ອັດສະລິยະອິນໂດເນເຊຍ',
    'da': 'Smart AI-assistent Indonesien',
    'no': 'Smart AI-assistent Indonesia',
    'sv': 'Smart AI-assistent Indonesien',
    'fi': 'Älykäs tekoälyavustaja Indonesia',
  });

  static String get btnBack => _get({'id': 'Kembali', 'en': 'Back', 'it': 'Indietro', 'fr': 'Retour', 'es': 'Atrás'});
  static String get dividerOr => _get({'id': 'atau masuk dengan', 'en': 'or sign in with', 'es': 'o iniciar sesión con'});

  // ===========================================================================
  // SETTINGS CATEGORIES & ITEMS
  // ===========================================================================
  static String get titlePengaturan => _get({'id': 'Pengaturan', 'en': 'Settings', 'it': 'Impostazioni', 'tr': 'Ayarlar', 'fr': 'Paramètres'});
  static String get headerGeneral => _get({'id': 'PENGATURAN UMUM', 'en': 'GENERAL SETTINGS', 'it': 'IMPOSTAZIONI GENERALI'});
  static String get headerDataStorage => _get({'id': 'DATA & PENYIMPANAAN', 'en': 'DATA & STORAGE', 'it': 'DATI E ARCHIVIAZIONE'});
  static String get headerInfoLegal => _get({'id': 'INFORMASI & LEGAL', 'en': 'INFO & LEGAL'});
  
  static String get menuChangePassword => _get({'id': 'Ubah Kata Sandi', 'en': 'Change Password', 'it': 'Cambia password'});
  static String get menuClearCache => _get({'id': 'Bersihkan Cache', 'en': 'Clear Cache', 'it': 'Svuota cache'});
  static String get menuPrivacyPolicy => _get({'id': 'Kebijakan Privasi', 'en': 'Privacy Policy'});
  static String get menuTerms => _get({'id': 'Syarat & Ketentuan', 'en': 'Terms & Conditions'});
  static String get menuLogout => _get({'id': 'Keluar dari Akun', 'en': 'Logout Account', 'it': 'Esci dall\'account'});
  
  static String get logoutConfirmTitle => _get({'id': 'Konfirmasi Keluar', 'en': 'Confirm Logout'});
  static String get logoutConfirmMessage => _get({'id': 'Apakah Anda yakin ingin keluar dari akun Cerdas AI?', 'en': 'Are you sure you want to log out?'});
  static String get btnCancel => _get({'id': 'Batal', 'en': 'Cancel'});
  static String get btnLogout => _get({'id': 'Keluar', 'en': 'Logout'});
  static String get btnClose => _get({'id': 'Tutup', 'en': 'Close'});
  static String get snackbarLogout => _get({'id': 'Berhasil keluar', 'en': 'Successfully logged out'});
  static String get snackbarCacheCleared => _get({'id': 'Cache berhasil dibersihkan!', 'en': 'Cache cleared successfully!'});
  static String get snackbarCacheFailed => _get({'id': 'Gagal membersihkan cache.', 'en': 'Failed to clear cache.'});

  // ===========================================================================
  // ACTIVITY: LOGIN & REGISTER
  // ===========================================================================
  static String get labelEmail => _get({'id': 'Alamat Email', 'en': 'Email Address'});
  static String get hintEmail => _get({'id': 'Masukkan email', 'en': 'Enter email'});
  static String get labelPassword => _get({'id': 'Kata Sandi', 'en': 'Password'});
  static String get hintPassword => _get({'id': 'Masukkan password', 'en': 'Enter password'});
  static String get actionLupaPassword => _get({'id': 'Lupa Kata Sandi?', 'en': 'Forgot Password?'});
  static String get btnMasuk => _get({
    'id': 'Masuk',
    'en': 'Login',
    'es': 'Acceso',
    'zh': '登录',
    'ja': 'ログイン',
    'ar': 'تسجيل الدخول',
    'fr': 'Connexion',
    'ru': 'Вход',
    'th': 'เข้าสู่ระบบ',
    'it': 'Accesso',
    'tr': 'Giriş yap',
    'ko': '로그인',
    'hi': '로그인',
    'pt': 'Entrar',
    'vi': 'Đăng nhập',
    'km': 'ចូល',
    'lo': 'ເຂົ້າສູ່ລະບົບ',
    'da': 'Log ind',
    'no': 'Logg inn',
    'sv': 'Logga in',
    'fi': 'Kirjaudu sisään',
  });
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
  static String get hintConfirmPassword => _get({'id': 'Ulangi kata sandi Anda', 'en': 'Repeat your password'});
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
  static String get headingPasswordDiubah => _get({'id': 'Kata Sandi Telah Berubah!', 'en': 'Password Changed!'});
  static String get descPasswordDiubah => _get({'id': 'Kata sandi Anda telah berhasil diperbarui.', 'en': 'Your password has been successfully updated.'});
  static String get btnKembaliLogin => _get({'id': 'Kembali ke Halaman Login', 'en': 'Back to Login'});

  // ===========================================================================
  // DASHBOARD & ACTIVITY
  // ===========================================================================
  static String get greetingUser => _get({
    'id': 'Hallo, Pengguna Cerdas AI!',
    'en': 'Hello, Cerdas AI User!',
    'it': 'Ciao, Utente Cerdas AI!',
    'es': '¡Hola, Usuario de Cerdas AI!',
    'fr': 'Bonjour, utilisateur de Cerdas AI !',
  });

  static String get subtitleDashboard => _get({
    'id': 'Apa yang ingin kamu tanyakan hari ini?',
    'en': 'What would you like to ask today?',
    'it': 'Cosa vorresti chiedere oggi?',
    'es': '¿Qué te gustaría preguntar hoy?',
    'fr': 'Que aimeriez-vous demander aujourd\'hui ?',
  });
  static String get hintTypeQuestion => _get({'id': 'Ketik pertanyaan disini...', 'en': 'Type your question here...'});
  static String get btnKamera => _get({'id': 'Kamera', 'en': 'Camera'});
  static String get btnSuara => _get({'id': 'Suara', 'en': 'Voice'});
  static String get btnGaleri => _get({'id': 'Galeri', 'en': 'Gallery'});
  static String get sectionUploadDokumen => _get({'id': 'Upload Dokumen', 'en': 'Upload Documents'});
  static String get descAttachment => _get({'id': 'Lampirkan File', 'en': 'Attach File'});
  static String get titleAktivitas => _get({'id': 'Aktivitas', 'en': 'Activity', 'it': 'Attività', 'fr': 'Activé', 'es': 'Actividad'});
  static String get hintSearchRiwayat => _get({'id': 'Cari riwayat pertanyaan..', 'en': 'Search question history..'});
  static String get filterSemua => _get({'id': 'Semua', 'en': 'All'});
  static String get filterDokumen => _get({'id': 'Dokumen', 'en': 'Documents'});
  static String get filterFoto => _get({'id': 'Foto', 'en': 'Photos'});
  static String get filterTeks => _get({'id': 'Teks', 'en': 'Text'});
  static String get actionHapus => _get({'id': 'Hapus', 'en': 'Delete'});

  static String get aiAnalyzingText => _get({'id': 'Cerdas AI sedang menganalisis foto/dokumen Anda...', 'en': 'Cerdas AI is analyzing your photo/document...'});
  static String get aiThinkingText => _get({'id': 'Cerdas AI sedang berpikir dan menganalisis...', 'en': 'Cerdas AI is thinking and analyzing...'});
  static String get promptEmptyAlert => _get({'id': 'Ketik pertanyaan atau unggah foto/file terlebih dahulu', 'en': 'Please type a question or upload a photo/file first'});
  static String get micFeatureAlert => _get({'id': 'Fitur rekam suara tidak tersedia di perangkat ini.', 'en': 'Voice recording feature is not available on this device.'});
  static String get micErrorPrefix => _get({'id': 'Kesalahan rekam suara', 'en': 'Voice recording error'});
  static String get driveFeatureAlert => _get({'id': 'Membuka Google Drive...', 'en': 'Opening Google Drive...'});
  
  static String get historySearchHint => _get({
    'id': 'Cari percakapan lama...',
    'en': 'Search history...',
    'it': 'Cerca nella cronologia...',
    'es': 'Buscar en el historial...',
    'fr': 'Rechercher dalam l\'historique...',
    'zh': '在历史记录中搜索...',
    'ja': '履歴を検索...',
  });
  
  static String get historyEmptyResult => _get({
    'id': 'Tidak ada riwayat ditemukan',
    'en': 'No history found',
    'it': 'Nessuna cronologia trovata',
    'es': 'No se encontró historial',
    'fr': 'Aucun historique trouvé',
    'zh': '未找到历史记录',
    'ja': '履歴が見つかりません',
  });

  static String get notebookTitle => 'Cerdas AI Notebook';
  static String get notebookMessage => _get({'id': 'Mulai menggunakan Cerdas AI notebook untuk setiap project Anda.', 'en': 'Start using Cerdas AI notebook for each of your projects.'});
  static String get btnHistorySelect => _get({'id': 'PILIH', 'en': 'SELECT', 'it': 'SELEZIONA'});
  static String get chatSavedAlert => _get({'id': 'Percakapan berhasil disimpan ke riwayat', 'en': 'Conversation successfully saved to history'});


  // ===========================================================================
  // SETTINGS & PROFILE
  // ===========================================================================
  static String get titleNotifikasi => _get({'id': 'Notifikasi', 'en': 'Notifications', 'it': 'Notifiche'});
  static String get actionTandaiDibaca => _get({'id': 'Tandai Dibaca', 'en': 'Mark as Read'});
  static String get appVersion => 'Versi 1.0';
  static String get titleTentang => _get({
    'id': 'Tentang Aplikasi',
    'en': 'About Application',
    'es': 'Acerca de la aplikasi',
    'zh': '关于应用',
    'ja': 'アプリについて',
    'ar': 'حول التطبيق',
    'fr': 'À propos de l\'application',
    'ru': 'О приложении',
    'th': 'เกี่ยวกับแอปพลิเคชัน',
    'da': 'Om applikationen',
    'no': 'Om applikasjonen',
    'sv': 'Om applikationen',
    'fi': 'Tietoja sovelluksesta',
  });
  static String get appNameFull => 'Cerdas AI - Asisten Pintar';
  static String get appDescription => _get({'id': 'Cerdas AI adalah aplikasi asisten pintar.', 'en': 'Cerdas AI is a smart assistant application.'});
  static String get appVersionLabel => _get({'id': 'Versi Aplikasi', 'en': 'App Version'});
  static String get developerLabel => _get({'id': 'Dikembangkan Oleh', 'en': 'Developed By'});
  static String get developerName => 'Tim Inovasi Cerdas AI';
  static String get contactUs => _get({'id': 'Hubungi Kami', 'en': 'Contact Us'});
  static String get contactEmail => 'support@aicerdas.com';
  static String get titleEditProfil => _get({'id': 'Edit Profil', 'en': 'Edit Profile', 'it': 'Modifica profilo'});
  static String get actionChangePhoto => _get({'id': 'Ubah Foto', 'en': 'Change Photo'});
  static String get labelPersonalInfo => _get({'id': 'Informasi Pribadi', 'en': 'Personal Information'});
  static String get labelFullName => _get({'id': 'Nama Lengkap', 'en': 'Full Name'});
  static String get labelDob => _get({'id': 'Tanggal Lahir', 'en': 'Date of Birth'});
  static String get hintDob => _get({'id': 'Pilih Tanggal', 'en': 'Select Date'});
  static String get labelPhone => _get({'id': 'Nomor Telepon', 'en': 'Phone Number'});
  static String get hintPhone => _get({'id': 'Masukkan Nomor Telepon', 'en': 'Enter Phone Number'});
  static String get labelGender => _get({'id': 'Jenis Kelamin', 'en': 'Gender'});
  static String get genderMale => _get({'id': 'Laki-laki', 'en': 'Male', 'it': 'Maschio'});
  static String get genderFemale => _get({'id': 'Perempuan', 'en': 'Female', 'it': 'Femmina'});
  static String get actionSaveChanges => _get({'id': 'Simpan Perubahan', 'en': 'Save Changes', 'it': 'Salva modifiche'});
  static String get titleUbahBahasa => _get({
    'id': 'Ubah Bahasa',
    'en': 'Change Language',
    'es': 'Cambiar idioma',
    'zh': '更改语言',
    'ja': '言語を変更',
    'ar': 'تغيير اللغة',
    'fr': 'Changer de langue',
    'ru': 'Изменить bahasa',
    'th': 'เปลี่ยนภาษา',
    'it': 'Cambia lingua',
    'tr': 'Dili değiştir',
    'ko': '언어 변경',
    'hi': 'भाषा बदलें',
    'pt': 'Alterar idioma',
    'vi': 'Thay đổi ngôn ngữ',
    'km': 'ប្តូរភាសា',
    'lo': 'ປ່ຽນພາສາ',
    'da': 'Skift sprog',
    'no': 'Bytt språk',
    'sv': 'Ändra språk',
    'fi': 'Vaihda kieli',
  });
  static String get menuBelajar => _get({'id': 'Belajar', 'en': 'Learn', 'it': 'Imparare', 'es': 'Aprender'});
  static String get menuInformasi => _get({'id': 'Informasi', 'en': 'Information', 'it': 'Informazione', 'es': 'Información'});
  static String get titleUpgradePlus => _get({'id': 'Upgrade ke Cerdas AI Plus', 'en': 'Upgrade to Cerdas AI Plus', 'it': 'Passa a Cerdas AI Plus'});
  static String get btnHistoryChat => _get({
    'id': 'Riwayat Percakapan',
    'en': 'Chat History',
    'es': 'Historial de chat',
    'zh': '聊天记录',
    'ja': 'チャット履歴',
    'ar': 'سجل الدردشة',
    'fr': 'Historique de discussion',
    'ru': 'Historia chat',
    'th': 'ประวัติการแชท',
    'it': 'Cronologia chat',
    'tr': 'Sohbet geçmişi',
    'ko': '채팅 기록',
    'hi': 'चैट इतिहास',
    'pt': 'Histórico de conversas',
    'vi': 'Lịch sử trò chuyện',
    'km': 'ប្រវត្តិជជែក',
    'lo': 'ປະຫວັດການສົນທະນາ',
    'da': 'Chathistorik',
    'no': 'Chatlogg',
    'sv': 'Chatthistorik',
    'fi': 'Keskusteluhistoria',
  });
  static String get subtitleUpgradePlus => _get({'id': 'Dapatkan lebih banyak akses ke Cerdas AI', 'en': 'Get more access to Cerdas AI'});
  static String get labelMonthly => _get({'id': 'Bulanan', 'en': 'Monthly', 'it': 'Mensile'});
  static String get labelYearly => _get({'id': 'Tahunan', 'en': 'Yearly', 'it': 'Annuale'});
  static String get labelBestValue => _get({'id': 'Lebih hemat dengan penagihan tahunan', 'en': 'Save more with yearly billing'});
  static String get labelRecommended => _get({'id': 'DISARANKAN', 'en': 'RECOMMENDED', 'it': 'CONSIGLIATO'});
  
  static String get planPlusTitle => 'Cerdas AI Plus';
  static String get planPlusDesc => _get({'id': 'Tingkatkan produktivitas dan kreativitas Anda', 'en': 'Boost your productivity and creativity'});
  static String get planProTitle => 'Cerdas AI Pro';
  static String get planProDesc => _get({'id': 'Bekerja lebih cerdas dengan manfaat yang diperluas', 'en': 'Work smarter with expanded benefits'});
  static String get planUltraTitle => 'Cerdas AI Ultra';
  static String get planUltraDesc => _get({'id': 'Percepat alur kerja Anda dengan akses tertinggi', 'en': 'Accelerate your workflow with top-tier access'});

  static String get btnGetPlan => _get({'id': 'Dapatkan', 'en': 'Get', 'it': 'Ottieni'});
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

  // ===========================================================================
  // DASHBOARD ATTACHMENT SHEET
  // ===========================================================================
  static String get labelFoto => _get({'id': 'Foto', 'en': 'Photo', 'it': 'Foto'});
  static String get labelKamera => _get({'id': 'Kamera', 'en': 'Camera', 'it': 'Fotocamera'});
  static String get labelFile => _get({'id': 'File', 'en': 'File', 'it': 'File'});
  static String get labelDrive => _get({'id': 'Drive', 'en': 'Drive', 'it': 'Drive'});
  static String get labelThinkHarder => _get({'id': 'Berpikir Lebih Keras', 'en': 'Think Harder'});

  // ===========================================================================
  // SOCIAL LOGIN
  // ===========================================================================
  static String get titleLoginGoogleAlt => _get({'id': 'Login Google', 'en': 'Google Login'});
  static String get titleLoginAppleAlt => _get({'id': 'Login Apple', 'en': 'Apple Login'});
}
