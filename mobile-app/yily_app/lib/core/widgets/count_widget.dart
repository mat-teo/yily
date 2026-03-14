import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yily_app/models/counts.dart';
import 'package:yily_app/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

class CountsWidget extends StatefulWidget {
  const CountsWidget({super.key});

  @override
  State<CountsWidget> createState() => _CountsWidgetState();
}

class _CountsWidgetState extends State<CountsWidget> {
  ReasonCounts? _counts;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      final countsMap = await api.getCounts();
      final counts = ReasonCounts.fromJson(countsMap);
      setState(() {
        _counts = counts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: _isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(3, (_) => Container(width: 60.w, height: 40.h, color: Colors.white)),
                ),
              )
            : _counts == null
                ? const Center(child: Text('Conteggi non disponibili'))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCount('Scritti', _counts!.sent),
                      _buildCount('Ricevuti', _counts!.received),
                      _buildCount('Totale', _counts!.total),
                    ],
                  ),
      ),
    );
  }

  Widget _buildCount(String label, int value) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }
}