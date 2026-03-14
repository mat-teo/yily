import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yily_app/models/reason.dart';
import 'package:yily_app/services/api_service.dart';
import 'package:yily_app/widgets/reason_card.dart';
import 'add_reason_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class reasonScreen extends StatefulWidget {
  const reasonScreen({super.key});

  @override
  State<reasonScreen> createState() => _reasonScreenState();
}

class _reasonScreenState extends State<reasonScreen> {
  List<Reason> _reasons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadreason();
  }

  Future<void> _loadreason() async {
    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      final reasons = await api.getReceivedReasons(); // o una nuova chiamata per tutti
      setState(() {
        _reasons = reasons;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All reasons'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddReasonScreen()),
              );
              if (result == true) _loadreason();
            },
          ),
        ],
      ),
      body: _isLoading
          ? ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 140.h,
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                );
              },
            )
          : _reasons.isEmpty
              ? Center(child: Text('No reasons yet! Hurry your partner!', style: TextStyle(fontSize: 18.sp)))
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: _reasons.length,
                  itemBuilder: (context, index) {
                    final reason = _reasons[index];
                    return ReasonCard(reason: reason).animate().fadeIn(delay: Duration(milliseconds: index * 80));
                  },
                ),
    );
  }
}