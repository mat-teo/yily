// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/providers/user_provider.dart';
import 'package:yily_app/widgets/invite_partner_view.dart';
import 'package:yily_app/widgets/complete_home_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<UserProvider>().loadUserInfo();
  });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProv, child) {
        if (!userProv.hasPartner) {
          return const InvitePartnerView();
        }
        return const CompleteHomeView();
      },
    );
  }
}