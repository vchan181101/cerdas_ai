import 'package:flutter/material.dart';

/// Enum Id Aksi Menu setara R.id.action_* di Android
enum TopBarAction {
  search,
  notification,
  refresh,
  settings,
  about,
}

class TopAppBarMenu {
  /// Handler Aksi Pilihan Menu (setara onOptionsItemSelected)
  static void handleActionSelected(
      BuildContext context,
      TopBarAction action, {
        VoidCallback? onRefresh,
      }) {
    switch (action) {
      case TopBarAction.search:
      // Aksi pencarian ditangani oleh SearchView widget di AppBar
        break;

      case TopBarAction.notification:
        Navigator.pushNamed(context, '/notifikasi');
        break;

      case TopBarAction.refresh:
        if (onRefresh != null) {
          onRefresh();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Memuat ulang data...')),
          );
        }
        break;

      case TopBarAction.settings:
        Navigator.pushNamed(context, '/settings');
        break;

      case TopBarAction.about:
        showAboutDialog(
          context: context,
          applicationName: 'Cerdas AI',
          applicationVersion: 'v1.2.0',
          applicationIcon: const Icon(Icons.psychology, size: 48, color: Colors.indigo),
          children: const [
            Text('Aplikasi Cerdas AI membantu aktivitas harian Anda dengan fitur berbasis AI.'),
          ],
        );
        break;
    }
  }

  /// Membuat list Widget Action untuk AppBar di Flutter (konversi top_app_bar_menu.xml)
  static List<Widget> buildActions({
    required BuildContext context,
    required bool isSearching,
    required TextEditingController searchController,
    required ValueChanged<bool> onSearchToggle,
    required ValueChanged<String> onQuerySubmit,
    VoidCallback? onRefresh,
  }) {
    if (isSearching) {
      return [
        IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Tutup Pencarian',
          onPressed: () {
            searchController.clear();
            onSearchToggle(false);
          },
        ),
      ];
    }

    return [
      // 1. Tombol Cari (R.id.action_search)
      IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Cari',
        onPressed: () => onSearchToggle(true),
      ),

      // 2. Tombol Notifikasi (R.id.action_notification)
      IconButton(
        icon: const Icon(Icons.notifications_outlined),
        tooltip: 'Notifikasi',
        onPressed: () => handleActionSelected(context, TopBarAction.notification),
      ),

      // 3. Overflow Menu (Titik Tiga: Refresh, Settings, About)
      PopupMenuButton<TopBarAction>(
        tooltip: 'Menu Lainnya',
        onSelected: (action) => handleActionSelected(
          context,
          action,
          onRefresh: onRefresh,
        ),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: TopBarAction.refresh,
            child: Row(
              children: [
                Icon(Icons.refresh, color: Colors.black54, size: 20),
                SizedBox(width: 12),
                Text('Muat Ulang'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: TopBarAction.settings,
            child: Row(
              children: [
                Icon(Icons.settings_outlined, color: Colors.black54, size: 20),
                SizedBox(width: 12),
                Text('Pengaturan'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: TopBarAction.about,
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.black54, size: 20),
                SizedBox(width: 12),
                Text('Tentang Aplikasi'),
              ],
            ),
          ),
        ],
      ),
    ];
  }
}