import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/screens/main_navigation.dart';
import 'package:yily_app/core/theme/app_theme.dart';
import 'package:yily_app/providers/auth_provider.dart';
import 'package:yily_app/screens/onboarding_screen.dart';
import 'package:yily_app/providers/user_provider.dart';
import 'package:yily_app/providers/theme_provider.dart';
import 'package:yily_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: Consumer<AuthProvider>(
            builder: (context, auth, _) {
      
              if (auth.isLoading) {
                return const MaterialApp(
                  home: Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              return MaterialApp(
                title: 'Yily',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: Provider.of<ThemeProvider>(context).themeMode,
                home: auth.isAuthenticated 
                    ? const MainNavigation()
                    : const OnboardingScreen(),
              );
            },
          ),
        );
      },
    );
  }
}