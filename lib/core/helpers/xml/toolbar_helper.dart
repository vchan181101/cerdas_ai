import 'package:flutter/material.dart';

class ToolbarHelper {
  /// Membuat Custom AppBar standar Cerdas AI (Konversi dari ToolbarHelper.java)
  static PreferredSizeWidget buildToolbar({
    required BuildContext context,
    required String title,
    bool showBack = true,
    bool isSearching = false,
    TextEditingController? searchController,
    ValueChanged<bool>? onSearchToggle,
    ValueChanged<String>? onQuerySubmit,
    VoidCallback? onRefresh,
  }) {
    return AppBar(
      backgroundColor: const Color(0xFF6366F1),
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: false,

      // Setup Tombol Back (setara setDisplayHomeAsUpEnabled)
      leading: showBack
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.maybePop(context),
      )
          : null,

      // Title atau SearchView TextField
      title: isSearching && searchController != null
          ? TextField(
        controller: searchController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: 'Cari di Cerdas AI...',
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (query) {
          if (onQuerySubmit != null) onQuerySubmit(query);
        },
      )
          : Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Actions Menu (setara handleOptionsMenu & handleOptionsItemSelected)
      actions: _buildActions(
        context: context,
        isSearching: isSearching,
        searchController: searchController,
        onSearchToggle: onSearchToggle,
        onQuerySubmit: onQuerySubmit,
        onRefresh: onRefresh,
      ),
    );
  }

  static List<Widget> _buildActions({
    required BuildContext context,
    required bool isSearching,
    TextEditingController? searchController,
    ValueChanged<bool>? onSearchToggle,
    ValueChanged<String>? onQuerySubmit,
    VoidCallback? onRefresh,
  }) {
    if (isSearching) {
      return [
        IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Tutup Pencarian',
          onPressed: () {
            if (searchController != null) searchController.clear();
            if (onSearchToggle != null) onSearchToggle(false);
          },
        ),
      ];
    }

    return [
      // Tombol Cari (R.id.action_search)
      if (onSearchToggle != null)
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Cari',
          onPressed: () => onSearchToggle(true),
        ),

      // Tombol Notifikasi (R.id.action_notification)
      IconButton(
        icon: const Icon(Icons.notifications_outlined),
        tooltip: 'Notifikasi',
        onPressed: () => Navigator.pushNamed(context, '/notifikasi'),
      ),

      // Menu Overflow Titik Tiga (Refresh, Settings, About)
      PopupMenuButton<String>(
        tooltip: 'Menu Lainnya',
        onSelected: (value) => _handleMenuClick(context, value, onRefresh),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'refresh',
            child: Row(
              children: [
                Icon(Icons.refresh, color: Colors.black54, size: 20),
                SizedBox(width: 12),
                Text('Muat Ulang'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'settings',
            child: Row(
              children: [
                Icon(Icons.settings_outlined, color: Colors.black54, size: 20),
                SizedBox(width: 12),
                Text('Pengaturan'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'about',
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

  // Penanganan Navigasi & Aksi Menu
  static void _handleMenuClick(
      BuildContext context,
      String value,
      VoidCallback? onRefresh,
      ) {
    switch (value) {
      case 'refresh':
        if (onRefresh != null) {
          onRefresh();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Memuat ulang data...')),
          );
        }
        break;
      case 'settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'about':
        Navigator.pushNamed(context, '/tentang-aplikasi');
        break;
    }
  }
}