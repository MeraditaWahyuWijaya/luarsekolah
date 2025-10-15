import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'screens/class_screen.dart';
import 'screens/my_class_screen.dart';
import 'screens/coin_ls_screen.dart';
import 'screens/profile_form_screen.dart';

const Color _kGreen = Color.fromRGBO(7, 126, 96, 1);

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _buildIcon(String assetPath, bool isActive) {
    return Image.asset(
      assetPath,
      height: 24,
      width: 24,
      color: isActive ? _kGreen : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemsList = [
      {'label': 'Beranda', 'asset': 'assets/beranda.png'},
      {'label': 'Kelas', 'asset': 'assets/kelas.png'},
      {'label': 'Kelasku', 'asset': 'assets/kelasku.png'},
      // HATI-HATI: Saya balik asset 'koinLS' dan 'Akun' agar sesuai urutan di bawah.
      {'label': 'koinLS', 'asset': 'assets/koinls.png'},
      {'label': 'Akun', 'asset': 'assets/akun.png'},
    ];

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _kGreen,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: GoogleFonts.montserrat(fontSize: 12),
      currentIndex: currentIndex,
      onTap: onTap,
      items: itemsList.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return BottomNavigationBarItem(
          label: item['label'],
          icon: _buildIcon(item['asset']!, index == currentIndex),
          activeIcon: _buildIcon(item['asset']!, true),
        );
      }).toList(),
    );
  }
}

class MainScreenWithNavBar extends StatefulWidget {
  final int initialIndex;

  const MainScreenWithNavBar({
    super.key,
    this.initialIndex = 4,
  });

  @override
  State<MainScreenWithNavBar> createState() => _MainScreenWithNavBarState();
}

class _MainScreenWithNavBarState extends State<MainScreenWithNavBar> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    HomeScreen(),
    NestedScrollTabListPage(),
    MyClassScreen(),
    CoinLSScreen(),
    ProfileFormScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/beranda.png'), context);
    precacheImage(const AssetImage('assets/kelas.png'), context);
    precacheImage(const AssetImage('assets/kelasku.png'), context);
    precacheImage(const AssetImage('assets/akun.png'), context);
    precacheImage(const AssetImage('assets/koinls.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}