// lib/widgets/complete_home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/core/widgets/count_widget.dart';
import 'package:yily_app/core/widgets/random_reason_widget.dart';
import 'package:yily_app/providers/user_provider.dart';

class CompleteHomeView extends StatelessWidget {
  const CompleteHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);

    // Aggiungi padding in alto per evitare sovrapposizione con AppBar
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + kToolbarHeight), // Spazio per l'AppBar
      child: Column(
        children: [
          // 1. Cuore con nomi
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 32.w),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userProv.myName ?? "Tu",
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 16.w),
                  Icon(
                    Icons.favorite,
                    color: const Color(0xFFFF6B6B),
                    size: 32.w,
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                        duration: 1800.ms,
                        begin: const Offset(1.0, 1.0),
                        end: const Offset(1.3, 1.3),
                        curve: Curves.easeInOut,
                      ),
                  SizedBox(width: 16.w),
                  Text(
                    userProv.partnerName ?? "Partner",
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          // 2. Conteggi
          const CountsWidget(),

          // 3. Motivo random
          const RandomReasonWidget(),

          const Spacer()
        ],
      ),
    );
  }
}