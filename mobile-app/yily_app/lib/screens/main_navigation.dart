// lib/screens/main_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:yily_app/screens/home_screen.dart'; 
import 'package:yily_app/screens/reason_screen.dart'; 
import 'package:yily_app/screens/settings_screen.dart';
import 'package:yily_app/services/api_service.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),         
    const ReasonScreenContent(),        
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true, // Utile se vuoi che il body si estenda sotto la navbar
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _currentIndex == 0
                  ? 'Yily'
                  : _currentIndex == 1
                      ? 'Reasons'
                      : 'Settings',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.vpn_key_rounded, size: 24.w, color: Colors.black,),
              tooltip: 'Mostra codice coppia',
              onPressed: () => _showTokenPopup(context),
            ),
          ],
        ),
        body: IndexedStack(  
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: const Color(0xFFFF6B6B),
          unselectedItemColor: Colors.grey[600],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.white,
          elevation: 8,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 28.w), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded, size: 28.w), label: 'Reason'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded, size: 28.w), label: 'Settings'),
          ],
        ),
      ),
    );
  }

  void _showTokenPopup(BuildContext context) {
    final api = ApiService();
    api.getUserInfo().then((response) {
      final token = response["token"];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          title: const Text('Codice della coppia'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(
                token ?? 'ERRORE',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'Condividi questo codice con il tuo partner',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Chiudi'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: token ?? 'ERRORE'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Token copiato negli appunti!')),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Copia'),
            ),
          ],
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Errore'),
          content: const Text('Impossibile recuperare il token.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Chiudi'),
            ),
          ],
        ),
      );
    });
  }
}