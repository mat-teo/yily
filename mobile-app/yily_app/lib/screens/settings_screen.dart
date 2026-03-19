// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/providers/auth_provider.dart';
import 'package:yily_app/providers/user_provider.dart';
import 'package:yily_app/providers/theme_provider.dart';
import 'package:yily_app/screens/onboarding_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final userProv = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Sezione account
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Account', style: TextStyle(fontSize: 18.sp)),
            subtitle: Text('${userProv.myName ?? "Utente"} • ${userProv.partnerName ?? "Nessun partner"}'),
          ),
          const Divider(),

          // Tema chiaro/scuro
          SwitchListTile(
            secondary: const Icon(Icons.brightness_6),
            title: Text('Tema scuro', style: TextStyle(fontSize: 16.sp)),
            value: Provider.of<ThemeProvider>(context, listen: true).isDarkMode,
            onChanged: (value) {
              final themeProv = Provider.of<ThemeProvider>(context, listen: false);
              themeProv.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(fontSize: 16.sp, color: Colors.red)),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Vuoi davvero uscire?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annulla')),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Esci', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await authProv.logout(); // cancella token + notify
                userProv.clear(); // pulisci nomi
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout effettuato')),
                );
              }
            },
          ),

          // Spazio finale
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}