# Rencana Pembaruan Warna Background Modern & Estetik

Tujuan dari tugas ini adalah untuk memperbarui skema warna aplikasi agar selaras dengan logo baru (Navy Blue, Orange, dan Light Blue) serta memberikan tampilan yang lebih modern dan estetik pada layar Login/Daftar dan Aktivitas.

## Perubahan yang Diusulkan

### 1. [MODIFIKASI] [AppColors](file:///C:/Users/Sandra%20Bagus%20Nugroho/AndroidStudioProjects/cerdas_ai/lib/values/colors.dart)
Menambahkan warna baru yang diekstraksi dari logo:
- `navyPrimary`: Biru tua dari topi/teks logo.
- `orangeAccent`: Oranye dari badan robot/tassel.
- `softBlueBg`: Warna latar belakang biru muda yang sangat lembut dan estetik.

### 2. [MODIFIKASI] [GradientHelper](file:///C:/Users/Sandra%20Bagus%20Nugroho/AndroidStudioProjects/cerdas_ai/lib/helpers/color/gradient_helper.dart)
Menambahkan gradien baru yang modern:
- `aestheticGradient`: Gradien lembut dari Navy ke Navy yang lebih terang untuk mode gelap atau header.
- `modernLightGradient`: Gradien sangat lembut dari Biru Muda ke Putih untuk latar belakang layar utama.

### 3. [MODIFIKASI] Layar Login & Daftar (`lib/screens/login.daftar/`)
Memperbarui `Scaffold` background menggunakan `modernLightGradient` atau warna `softBlueBg` agar terlihat lebih bersih dan premium.
- `login_screen.dart`
- `register_screen.dart`
- `forgot_password_screen.dart`, dll.

### 4. [MODIFIKASI] Layar Aktivitas (`lib/screens/activity/`)
Menyesuaikan warna latar belakang dan header agar konsisten dengan tema logo.
- `dashboard_screen.dart`
- `activity_screen.dart`
- `splash_screen.dart` (Menyesuaikan gradien agar logo lebih menyatu)

## Rencana Verifikasi

### Manual Verification
- Memeriksa setiap layar di emulator untuk memastikan gradien warna terlihat halus dan teks tetap terbaca dengan jelas.
- Memastikan transisi antar layar terasa mulus dengan palet warna yang baru.
