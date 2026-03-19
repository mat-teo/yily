// lib/widgets/complete_home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yily_app/core/widgets/count_widget.dart';
import 'package:yily_app/core/widgets/random_reason_widget.dart';
import 'package:yily_app/widgets/anniversary_widget.dart';
import 'package:yily_app/widgets/heart_names_widget.dart';

class CompleteHomeView extends StatelessWidget {
  const CompleteHomeView({super.key});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),   
      ),
      child: Column(
        children: [
          const HeartNamesWidget(),
          const RandomReasonWidget(),
          const AnniversaryWidget(),
          const CountsWidget(),

          SizedBox(height: 80.h), // spazio finale per non far andare sotto la navbar
        ],
      ),
    );
  }
}