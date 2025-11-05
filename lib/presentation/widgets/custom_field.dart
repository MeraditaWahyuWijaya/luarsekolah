import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/presentation/views/home_screen.dart';
import 'package:luarsekolah/presentation/views/class_screen.dart';
import 'package:luarsekolah/presentation/views/my_class_screen.dart';
import 'package:luarsekolah/presentation/views/coin_ls_screen.dart';
import 'package:luarsekolah/presentation/views/profile_form_screen.dart';
import 'package:luarsekolah/presentation/controllers/todo_controllers.dart';
import '../bindings/class_binding.dart';
import '../bindings/todo_binding.dart';
import 'package:luarsekolah/presentation/controllers/class_controllers.dart';

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
      {'label': 'koinLS', 'asset': 'assets/akun.png'},
      {'label': 'Akun', 'asset': 'assets/koinls.png'},
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
    this.initialIndex = 0,
  });

  @override
  State<MainScreenWithNavBar> createState() => _MainScreenWithNavBarState();
}

class _MainScreenWithNavBarState extends State<MainScreenWithNavBar> {
  late int _currentIndex;

  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    KelasPopulerScreenClean(),
    MyClassScreen(),
   TodoDashboardPage(),
    ProfileFormScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    
    if (!Get.isRegistered<ClassController>()) {
      ClassBinding().dependencies();
    }
    
    if (!Get.isRegistered<TodoController>()) {
      TodoBinding().dependencies();
    }
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
        children: _widgetOptions,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
