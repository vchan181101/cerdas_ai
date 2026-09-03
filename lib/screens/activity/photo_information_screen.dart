import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../menu/menu.dart';
import '../../values/values.dart';
import '../../widgets/widgets.dart';
import '../../helpers/color/screen_color_helper.dart';

/// Model Data untuk Item Informasi Foto/Produk Katalog
class PhotoInfoItem {
  final String id;
  final String title;
  final num price;
  final num originalPrice;
  final String discountTag;
  final String imageUrl;
  final String brand;
  final String specs;
  final int soldCount;
  bool isSelected;

  PhotoInfoItem({
    required this.id,
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.discountTag,
    required this.imageUrl,
    required this.brand,
    required this.specs,
    required this.soldCount,
    this.isSelected = false,
  });
}

class PhotoInformationScreen extends StatefulWidget {
  const PhotoInformationScreen({super.key});

  @override
  State<PhotoInformationScreen> createState() => _PhotoInformationScreenState();
}

class _PhotoInformationScreenState extends State<PhotoInformationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final int _currentBottomNavIndex = 2; // Indeks menu Informasi

  String _selectedBrand = 'Semua';

  // List Data Foto Katalog Produk (Hasil Scan / Ekstraksi Gambar)
  final List<PhotoInfoItem> _allPhotoItems = [
    PhotoInfoItem(
      id: '1',
      title: 'LENOVO LOQ 15 RTX3050 RYZEN 7',
      price: 14992980,
      originalPrice: 19200000,
      discountTag: 'Gratis ongkir',
      imageUrl: 'assets/images/lenovo_loq.jpg',
      brand: 'Lenovo',
      specs: '15.6" • AMD Ryzen 7 7435HS • 16GB • 512GB',
      soldCount: 232,
    ),
    PhotoInfoItem(
      id: '2',
      title: 'ACER NITRO V 15 RTX5050 CORE i5',
      price: 8559000,
      originalPrice: 16299000,
      discountTag: 'Gratis ongkir',
      imageUrl: 'assets/images/acer_nitro.jpg',
      brand: 'Acer',
      specs: '15.6" • Intel Core i5 13420H • 16GB • 512GB',
      soldCount: 1,
    ),
    PhotoInfoItem(
      id: '3',
      title: 'LENOVO LOQ 15 RTX3050 RYZEN 7',
      price: 15489930,
      originalPrice: 19299000,
      discountTag: 'Cashback bonus 5%',
      imageUrl: 'assets/images/lenovo_loq_2.jpg',
      brand: 'Lenovo',
      specs: '15.6" • AMD Ryzen 7 • 16GB • 512GB',
      soldCount: 950,
    ),
    PhotoInfoItem(
      id: '4',
      title: 'ASUS TUF GAMING F16 RTX3050',
      price: 18879000,
      originalPrice: 25199000,
      discountTag: 'Gratis ongkir',
      imageUrl: 'assets/images/asus_tuf.jpg',
      brand: 'Asus',
      specs: '16.0" • Intel Core i7 • 16GB • 512GB',
      soldCount: 29,
    ),
  ];

  List<PhotoInfoItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allPhotoItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter berdasarkan Pencarian & Merk
  void _applyFilter() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredItems = _allPhotoItems.where((item) {
        final matchesQuery = item.title.toLowerCase().contains(query) ||
            item.specs.toLowerCase().contains(query);
        final matchesBrand =
            _selectedBrand == 'Semua' || item.brand.toLowerCase() == _selectedBrand.toLowerCase();
        return matchesQuery && matchesBrand;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColorHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: ScreenColorHelper.getHeadingText(context), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'EKSTRAKSI FOTO',
          style: TextStyle(
            color: ScreenColorHelper.getHeadingText(context),
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz_rounded, color: ScreenColorHelper.getHeadingText(context)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar Modern (Glassmorphism Style)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: ScreenColorHelper.getSurfaceColor(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ScreenColorHelper.getHeadingText(context).withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.5), size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: ScreenColorHelper.getHeadingText(context), fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Cari hasil ekstraksi produk...',
                          hintStyle: TextStyle(color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.3)),
                          border: InputBorder.none,
                        ),
                        onChanged: (_) => _applyFilter(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filter Chips Dinamis
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: ['Semua', 'Lenovo', 'Acer', 'Asus'].map((brand) {
                  final isSelected = _selectedBrand == brand;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ChoiceChip(
                      label: Text(brand),
                      selected: isSelected,
                      selectedColor: ScreenColorHelper.getPrimaryAction(context),
                      backgroundColor: ScreenColorHelper.getSurfaceColor(context).withValues(alpha: 0.1),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : ScreenColorHelper.getBodyText(context),
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedBrand = brand;
                            _applyFilter();
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Grid View Foto Katalog Laptop 2 Kolom
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported_outlined, color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.2), size: 64),
                          const SizedBox(height: 16),
                          Text('Tidak ada data ekstraksi', style: TextStyle(color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.5))),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return _buildPhotoProductCard(item);
                      },
                    ),
            ),

            // Bar Aksi Mengambang (Proceed)
            _buildBottomActionBar(),
          ],
        ),
      ),

      // Integrated Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationViewWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) => BottomNavMenu.handleNavigation(context, _currentBottomNavIndex, index),
      ),
    );
  }

  // Widget Card Item Foto Produk Premium
  Widget _buildPhotoProductCard(PhotoInfoItem item) {
    return Container(
      decoration: BoxDecoration(
        color: ScreenColorHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isSelected ? AppColors.emeraldSuccess.withValues(alpha: 0.5) : ScreenColorHelper.getHeadingText(context).withValues(alpha: 0.05),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk Section
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Container(
                    width: double.infinity,
                    color: Colors.black12,
                    child: Image.asset(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Icon(Icons.laptop_mac_rounded, size: 48, color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.1)));
                      },
                    ),
                  ),
                ),
                // Checkbox Overlay
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => setState(() => item.isSelected = !item.isSelected),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: item.isSelected ? AppColors.emeraldSuccess : Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.isSelected ? Icons.check_rounded : Icons.add_rounded,
                        size: 18,
                        color: item.isSelected ? Colors.black87 : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Detail Deskripsi Section
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.discountTag.toUpperCase(),
                    style: const TextStyle(color: Colors.orangeAccent, fontSize: 9, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: ScreenColorHelper.getHeadingText(context), fontSize: 12, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const Spacer(),
                  Text(
                    item.price.toRupiah,
                    style: const TextStyle(color: AppColors.emeraldSuccess, fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    item.originalPrice.toRupiah,
                    style: TextStyle(color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.4), fontSize: 10, decoration: TextDecoration.lineThrough),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.bolt_rounded, color: Colors.amber, size: 12),
                      const SizedBox(width: 4),
                      Text('${item.soldCount} terjual', style: TextStyle(color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.6), fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bar Aksi Bawah Premium (Proceed)
  Widget _buildBottomActionBar() {
    final selectedCount = _allPhotoItems.where((e) => e.isSelected).length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: ScreenColorHelper.getSurfaceColor(context),
        border: Border(top: BorderSide(color: ScreenColorHelper.getHeadingText(context).withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$selectedCount Item Terpilih', style: TextStyle(color: ScreenColorHelper.getHeadingText(context), fontWeight: FontWeight.bold)),
                Text('Siap untuk dianalisis lebih lanjut', style: TextStyle(color: ScreenColorHelper.getBodyText(context).withValues(alpha: 0.6), fontSize: 11)),
              ],
            ),
          ),
          AppButton(
            text: 'PROSES',
            icon: Icons.auto_fix_high_rounded,
            height: 48,
            borderRadius: 24,
            backgroundColor: ScreenColorHelper.getPrimaryAction(context),
            onPressed: selectedCount == 0 
                ? null 
                : () => context.showSnackBar('Memproses $selectedCount foto produk...'),
          ).paddingOnly(left: 16).expanded(),
        ],
      ),
    );
  }
}
