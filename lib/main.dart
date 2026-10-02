import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// --- INITIALIZER ---
import 'initialize_date_formatting.dart';

// --- INTEGRASI SEMUA LIBRARY CERDAS AI ---
import 'core/core.dart';           // lib/core
import 'repositories/repositories.dart'; // lib/repositories
import 'security/security.dart';   // lib/security
import 'values/values.dart';       // lib/values
import 'widgets/widgets.dart';     // lib/widgets
import 'screens/screens.dart';     // lib/screens (Orkestrasi semua screen)
import 'package:cerdas_ai/helpers/helpers.dart'; // lib/helpers

// Ambil API key dari environment
const apiKey = String.fromEnvironment('API_KEY');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (.env)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found or failed to load. $e");
  }

  // 1. Inisialisasi format tanggal lokal (Indonesia) melalui helper terpisah
  await initializeAppDateFormatting();

  // 2. Load Tema, Bahasa & Profil Terakhir
  await ThemeHelper.loadSavedTheme();
  await UserProfileHelper.loadSavedProfile();
  await LocaleHelper.loadSavedLocale();

  // 3. Pengujian Security & Database SQLite saat aplikasi pertama kali berjalan
  await _testSecurityAndDatabase();

  // 4. Jalankan Aplikasi
  runApp(const MyApp());
}

Future<void> _testSecurityAndDatabase() async {
  try {
    final securityRepo = SecurityRepository();
    await securityRepo.runExampleUsage();

    final userRepository = UserRepository();
    await userRepository.runExampleUsage();

    LoggerUtil.info("Inisialisasi sistem keamanan dan database berhasil.");
  } catch (e) {
    LoggerUtil.error('Error saat inisialisasi awal:', e);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _updateThemeMode(ThemeMode mode) {
    ThemeHelper.setTheme(mode);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocaleNotifier,
      builder: (context, locale, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: appThemeNotifier,
          builder: (context, themeMode, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppConstants.appName,
              locale: locale,

              // Integrasi Tema Terang & Gelap dari Values
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: themeMode,

              // Halaman Pertama yang Dimuat
              home: const SplashScreen(),

              // Wrapper Global untuk Zoom In/Out di semua layar
              builder: (context, child) {
                return InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: child!,
                );
              },

              // Rute Navigasi Aplikasi (Terintegrasi dari Screens Barrel)
              routes: {
                '/splash': (context) => const SplashScreen(),
                '/login': (context) => const LoginScreen(),
                '/daftar': (context) => const RegisterScreen(),
                '/lupa-password': (context) => const ForgotPasswordScreen(),
                '/kode-verifikasi': (context) => const OtpVerificationScreen(),
                '/password-baru': (context) => const NewPasswordScreen(),
                '/password-telah-diubah': (context) => const PasswordChangedScreen(),
                '/akun-telah-dibuat': (context) => const AccountCreatedScreen(),
                '/login-google': (context) => const LoginWithGoogleScreen(),
                '/login-ios': (context) => const LoginWithIosScreen(),
                '/dashboard': (context) => const DashboardScreen(),
                '/aktivitas': (context) => const ActivityScreen(),
                '/belajar': (context) => const BelajarScreen(),
                '/keterangan': (context) => const KeteranganScreen(),
                '/document-view': (context) => DocumentViewScreen(),
                '/repository': (context) => const RepositoryScreen(),
                '/notifikasi': (context) => const NotificationScreen(),
                '/notification': (context) => const NotificationScreen(),
                '/quizz': (context) => const QuizzScreen(),
                '/quiz': (context) => const QuizzScreen(),
                '/quiz-detail': (context) => const QuizDetailScreen(),
                '/quiz-exam': (context) => const QuizExamScreen(),
                '/setting': (context) => const SettingScreen(),
                '/settings': (context) => const SettingScreen(),
                '/edit-profil': (context) => const EditProfileScreen(),
                '/ubah-bahasa': (context) => const ChangeLanguageScreen(),
                '/ubah-kata-sandi': (context) => const ChangePasswordScreen(),
                '/dokumen-tersimpan': (context) => const KelolaDokumenScreen(),
                '/sampah': (context) => const SampahScreen(),
                '/tentang-aplikasi': (context) => const AboutScreen(),
                '/foto-informasi': (context) => const PhotoInformationScreen(),
                '/kamera': (context) => const CustomCameraScreen(),
                '/upgrade-plus': (context) => const UpgradePlusScreen(),
                '/gemini-model-selector': (context) => const GeminiModelSelectorScreen(),

                // Demo & Gallery Routes
                '/animation-gallery': (context) => const AnimationGalleryScreen(),
                '/dark-mode-demo': (context) => DarkModeDemoScreen(
                  currentThemeMode: themeMode,
                  onThemeChanged: _updateThemeMode,
                ),
                '/demo-home': (context) => const HomeScreenDemo(),
                '/demo-input-box': (context) => const InputBoxDemoScreen(),
                '/demo-example-docs': (context) => const ExampleDocumentListScreen(),
                '/demo-profile-avatar': (context) => const ProfileAvatarDemoScreen(),
                '/demo-notification': (context) => const NotificationDemoScreen(),
                '/demo-network-check': (context) => const NetworkCheckExampleScreen(),
                '/demo-gemini': (context) => const GeminiDemoScreen(),
                '/gemini-chat': (context) => const GeminiChatScreen(),
              },
            );
          },
        );
      },
    );
  }
}