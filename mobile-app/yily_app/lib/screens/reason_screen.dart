// lib/screens/reason_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yily_app/models/reason.dart';
import 'package:yily_app/services/api_service.dart';
import 'package:yily_app/widgets/reason_card.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/providers/user_provider.dart';

class ReasonScreenContent extends StatefulWidget {
  const ReasonScreenContent({super.key});

  @override
  State<ReasonScreenContent> createState() => _ReasonScreenContentState();
}

class _ReasonScreenContentState extends State<ReasonScreenContent> {
  List<Reason> _allReasons = [];
  bool _isLoading = true;
  int _selectedTab = 0; // 0 = Received, 1 = Sent

  @override
  void initState() {
    super.initState();
    _loadReasons();
  }

  Future<void> _loadReasons() async {
    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      final received = await api.getReceivedReasons();
      final sent = await api.getSentReasons(); // assumo tu abbia questo metodo
      setState(() {
        _allReasons = [...received, ...sent];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore caricamento: $e')),
      );
    }
  }

  List<Reason> get _filteredReasons {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final currentUserId = userProv.userId;
    if (_selectedTab == 0) {
      return _allReasons.where((r) => r.toUserId == currentUserId).toList();
    } else {
      return _allReasons.where((r) => r.fromUserId == currentUserId).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context, listen: true);

    return SafeArea( child: RefreshIndicator(
      onRefresh: _loadReasons,
      color: const Color(0xFFFF9EAA),
      child: Column(
        children: [
          // Tab
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('Received', 0),
                SizedBox(width: 12.w),
                _buildTabButton('Sent', 1),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
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
                : _filteredReasons.isEmpty
                    ? Center(
                        child: Text(
                          _selectedTab == 0 ? 'Nessun motivo ricevuto' : 'Non hai inviato motivi',
                          style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: _filteredReasons.length,
                        itemBuilder: (context, index) {
                          final reason = _filteredReasons[index];
                          final isMine = reason.fromUserId == userProv.userId;

                          return Dismissible(
                            key: Key(reason.id.toString()),
                            direction: isMine ? DismissDirection.horizontal : DismissDirection.none,
                            // ... il tuo background + secondaryBackground + confirmDismiss invariato
                            child: ReasonCard(reason: reason),
                          );
                        },
                      ),
          ),
        ],
      ),
    ));
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF9EAA) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}