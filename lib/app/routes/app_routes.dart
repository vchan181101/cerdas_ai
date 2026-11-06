import 'package:flutter/material.dart';
import 'package:cerdas_ai/presentation/screens/screens.dart';

class AppRoutes {
  // Rute Utama & Autentikasi
  static const String initial = '/splash';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String daftar = '/daftar';
  static const String lupaPassword = '/lupa-password';
  static const String kodeVerifikasi = '/kode-verifikasi';
  static const String passwordBaru = '/password-baru';
  static const String passwordTelahDiubah = '/password-telah-diubah';
  static const String akunTelahDibuat = '/akun-telah-dibuat';
  static const String loginGoogle = '/login-google';
  static const String loginIos = '/login-ios';

  // Fitur Inti Aplikasi
  static const String dashboard = '/dashboard';
  static const String aktivitas = '/aktivitas';
  static const String belajar = '/belajar';
  static const String informasi = '/informasi';
  static const String keterangan = '/keterangan';
  static const String documentView = '/document-view';
  static const String repository = '/repository';
  static const String notifikasi = '/notifikasi';
  static const String notification = '/notification';
  static const String quizz = '/quizz';
  static const String quiz = '/quiz';
  static const String quizDetail = '/quiz-detail';
  static const String quizExam = '/quiz-exam';

  // Pengaturan & Profil
  static const String setting = '/setting';
  static const String settings = '/settings';
  static const String editProfil = '/edit-profil';
  static const String ubahBahasa = '/ubah-bahasa';
  static const String ubahKataSandi = '/ubah-kata-sandi';
  static const String dokumenTersimpan = '/dokumen-tersimpan';
  static const String sampah = '/sampah';
  static const String tentangAplikasi = '/tentang-aplikasi';
  static const String fotoInformasi = '/foto-informasi';
  static const String kamera = '/kamera';
  static const String upgradePlus = '/upgrade-plus';
  static const String geminiModelSelector = '/gemini-model-selector';

  // Rute Demo & Galeri Pengujian
  static const String animationGallery = '/animation-gallery';
  static const String darkModeDemo = '/dark-mode-demo';
  static const String demoHome = '/demo-home';
  static const String demoInputBox = '/demo-input-box';
  static const String demoExampleDocs = '/demo-example-docs';
  static const String demoProfileAvatar = '/demo-profile-avatar';
  static const String demoNotification = '/demo-notification';
  static const String demoNetworkCheck = '/demo-network-check';
  static const String demoGemini = '/demo-gemini';
  static const String geminiChat = '/gemini-chat';

  /// Mendapatkan daftar pemetaan seluruh rute navigasi aplikasi
  static Map<String, WidgetBuilder> getRoutes({
    ThemeMode? currentThemeMode,
    void Function(ThemeMode)? onThemeChanged,
  }) {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      daftar: (context) => const RegisterScreen(),
      lupaPassword: (context) => const ForgotPasswordScreen(),
      kodeVerifikasi: (context) => const OtpVerificationScreen(),
      passwordBaru: (context) => const NewPasswordScreen(),
      passwordTelahDiubah: (context) => const PasswordChangedScreen(),
      akunTelahDibuat: (context) => const AccountCreatedScreen(),
      loginGoogle: (context) => const LoginWithGoogleScreen(),
      loginIos: (context) => const LoginWithIosScreen(),
      dashboard: (context) => const DashboardScreen(),
      aktivitas: (context) => const ActivityScreen(),
      belajar: (context) => const BelajarScreen(),
      informasi: (context) => const InformasiScreen(),
      keterangan: (context) => const KeteranganScreen(),
      documentView: (context) => DocumentViewScreen(),
      repository: (context) => const RepositoryScreen(),
      notifikasi: (context) => const NotificationScreen(),
      notification: (context) => const NotificationScreen(),
      quizz: (context) => const QuizzScreen(),
      quiz: (context) => const QuizzScreen(),
      quizDetail: (context) => const QuizDetailScreen(),
      quizExam: (context) => const QuizExamScreen(),
      setting: (context) => const SettingScreen(),
      settings: (context) => const SettingScreen(),
      editProfil: (context) => const EditProfileScreen(),
      ubahBahasa: (context) => const ChangeLanguageScreen(),
      ubahKataSandi: (context) => const ChangePasswordScreen(),
      dokumenTersimpan: (context) => const KelolaDokumenScreen(),
      sampah: (context) => const SampahScreen(),
      tentangAplikasi: (context) => const AboutScreen(),
      fotoInformasi: (context) => const PhotoInformationScreen(),
      kamera: (context) => const CustomCameraScreen(),
      upgradePlus: (context) => const UpgradePlusScreen(),
      geminiModelSelector: (context) => const GeminiModelSelectorScreen(),

      // Demo & Gallery Routes
      animationGallery: (context) => const AnimationGalleryScreen(),
      darkModeDemo: (context) => DarkModeDemoScreen(
            currentThemeMode: currentThemeMode ?? ThemeMode.system,
            onThemeChanged: onThemeChanged ?? (_) {},
          ),
      demoHome: (context) => const HomeScreenDemo(),
      demoInputBox: (context) => const InputBoxDemoScreen(),
      demoExampleDocs: (context) => const ExampleDocumentListScreen(),
      demoProfileAvatar: (context) => const ProfileAvatarDemoScreen(),
      demoNotification: (context) => const NotificationDemoScreen(),
      demoNetworkCheck: (context) => const NetworkCheckExampleScreen(),
      demoGemini: (context) => const GeminiDemoScreen(),
      geminiChat: (context) => const GeminiChatScreen(),
    };
  }
}
