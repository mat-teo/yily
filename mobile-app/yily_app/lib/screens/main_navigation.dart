// lib/screens/main_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_screen.dart'; // la tua Home bella
import 'reason_screen.dart'; // la lista completa che faremo dopo
import 'package:yily_app/core/widgets/common_app_bar.dart'; // se la vuoi

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),       // la tua Home attuale (cuore + random + gradient)
    const reasonScreen(),     // da creare
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Yily' : 'Motivi'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.vpn_key_rounded, size: 24.w),
            onPressed: () {
              // Pop-up token (implementalo come prima)
              _showTokenPopup(context);
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFFFF6B6B),
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'Motivi'),
        ],
      ),
    );
  }

  void _showTokenPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        title: const Text('Codice coppia'),
        content: SelectableText('ABC123XYZ'), // da API reale
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Chiudi')),
          ElevatedButton.icon(
            onPressed: () {
              // Clipboard.setData(ClipboardData(text: 'ABC123XYZ'));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copiato!')));
              Navigator.pop(context);
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copia'),
          ),
        ],
      ),
    );
  }
}