// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/main_navigation.dart';
import 'screens/onboarding_screen.dart';

class YilyApp extends StatelessWidget {
  const YilyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ChangeNotifierProvider(
          create: (_) => AuthProvider()..init(),
          child: MaterialApp(
            title: 'Yily',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            home: Consumer<AuthProvider>(
              builder: (context, auth, _) => auth.isAuthenticated
                  ? const MainNavigation()
                  : const OnboardingScreen(),
            ),
          ),
        );
      },
    );
  }
}