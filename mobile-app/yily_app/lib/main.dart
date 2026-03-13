import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = AuthProvider();
  await auth.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // dimensione di riferimento (iPhone 14 / 13)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ChangeNotifierProvider(
          create: (_) => AuthProvider()..init(),
          child: MaterialApp(
            title: 'Yily',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            initialRoute: '/',  
            routes: {
              '/': (context) => Consumer<AuthProvider>(
                builder: (context, auth, _) => auth.isAuthenticated
                    ? const HomeScreen()
                    : const OnboardingScreen(),
              ),
              '/home': (context) => const HomeScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
            },
          ),
        );
      },
    );
  }
}