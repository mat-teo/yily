// lib/widgets/invite_partner_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:yily_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class InvitePartnerView extends StatelessWidget {
  const InvitePartnerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProv, child) {
        final token = userProv.coupleToken ?? "CARICAMENTO...";

        return Padding(
          padding: EdgeInsets.only(top: kToolbarHeight + 16.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.heart_broken_outlined, size: 80.w, color: Colors.grey[400]),
                  SizedBox(height: 24.h),
                  Text(
                    'Invita il tuo partner',
                    style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Condividi questo codice per unirvi e iniziare a scrivervi motivi',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        SelectableText(
                          token,
                          style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, letterSpacing: 4),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text('CODICE COPPIA', style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: token));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Codice copiato! Condividilo ora')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copia codice'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                      backgroundColor: const Color(0xFFFF9EAA),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  TextButton(
                    onPressed: () async {
                      // Mostra un caricamento opzionale
                      await userProv.loadUserInfo();
                      // Dopo il refresh, il Consumer ricostruirà automaticamente la UI
                    },
                    child: Text('Ho già inserito il codice', style: TextStyle(fontSize: 16.sp)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}