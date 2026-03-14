import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yily_app/models/reason.dart';
import 'package:yily_app/services/api_service.dart';
import 'package:yily_app/widgets/reason_card.dart';

class RandomReasonWidget extends StatefulWidget {
  const RandomReasonWidget({super.key});

  @override
  State<RandomReasonWidget> createState() => _RandomReasonWidgetState();
}

class _RandomReasonWidgetState extends State<RandomReasonWidget> {
  Reason? _randomReason;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRandomReason();
  }

  Future<void> _loadRandomReason() async {
    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      final reason = await api.getRandomReason();
      setState(() {
        _randomReason = reason;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: _isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 280.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
            )
          : _randomReason == null
              ? Container(
                  height: 280.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite_border, size: 64.w, color: Colors.grey[400]),
                        SizedBox(height: 16.h),
                        Text(
                          'Ancora nessun motivo',
                          style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              : ReasonCard(
                  reason: _randomReason!,
                ).animate().fadeIn(duration: 600.ms).scale(begin: Offset(0.94, 0.94), end: Offset(1.0, 1.0)),
    );
  }
}