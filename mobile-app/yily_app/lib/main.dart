import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/providers/auth_provider.dart';
import 'package:yily_app/screens/onboarding_screen.dart';
import 'package:yily_app/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => authProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return MaterialApp(
      title: 'Yily',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: auth.isAuthenticated ? const HomeScreen() : const OnboardingScreen(),
      routes: {
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}