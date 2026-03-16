// lib/widgets/complete_home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/core/widgets/count_widget.dart';
import 'package:yily_app/core/widgets/random_reason_widget.dart';
import 'package:yily_app/providers/user_provider.dart';
import 'package:yily_app/widgets/anniversary_widget.dart';

class CompleteHomeView extends StatelessWidget {
  const CompleteHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Cuore con nomi
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 32.w),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userProv.myName ?? "Tu",
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  SizedBox(width: 16.w),
                  Icon(
                    Icons.favorite,
                    color: const Color(0xFFFF6B6B),
                    size: 32.w,
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(
                        duration: 1800.ms,
                        begin: 1.0,
                        end: 1.3,
                        curve: Curves.easeInOut,
                      ),
                  SizedBox(width: 16.w),
                  Text(
                    userProv.partnerName ?? "Partner",
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),

          const CountsWidget(),
          const RandomReasonWidget(),
          const AnniversaryWidget(),

          SizedBox(height: 80.h), // spazio finale per non far andare sotto la navbar
        ],
      ),
    );
  }
}