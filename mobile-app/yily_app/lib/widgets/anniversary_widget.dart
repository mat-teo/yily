import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/providers/user_provider.dart';
import 'package:yily_app/services/api_service.dart';
import 'package:yily_app/services/notification_service.dart';
import 'package:yily_app/utils/error_handler.dart';

class AnniversaryWidget extends StatefulWidget {
  const AnniversaryWidget({super.key});

  @override
  State<AnniversaryWidget> createState() => _AnniversaryWidgetState();
}

class _AnniversaryWidgetState extends State<AnniversaryWidget> {
  bool _isLoading = false;

  Future<void> _pickDate() async {
    final userProv = Provider.of<UserProvider>(context, listen: false);

    final picked = await showDatePicker(
      context: context,
      initialDate: userProv.anniversaryDate ?? DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: const Color(0xFFFF9EAA)),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() => _isLoading = true);

    try {
      final api = ApiService();
      await api.setAnniversaryDate(picked, context);
      await NotificationService().scheduleAnniversaryNotification(picked);
      await userProv.loadUserInfo(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anniversary updated')),
        );
      }
    } catch (e) {
      ErrorHandler.showError(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    final anniversary = userProv.anniversaryDate;

    if (anniversary == null) {
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: ListTile(
          contentPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.calendar_today, color: const Color(0xFFFF9EAA), size: 32.w),
          title: Text('Save the date', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
          subtitle: Text('Set your anniversary date', style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
          trailing: _isLoading
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5))
              : const Icon(Icons.arrow_forward_ios),
          onTap: _isLoading ? null : _pickDate,
        ),
      );
    }

    final daysTogether = DateTime.now().difference(anniversary).inDays;
    final formattedDate = DateFormat('dd/MM/yyyy').format(anniversary);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Parte sinistra: icona + testo
                Flexible(  // ← AGGIUNTO Flexible per evitare overflow
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite, color: const Color(0xFFFF6B6B), size: 28.w),
                      SizedBox(width: 12.w),
                      Flexible(  
                        child: Text(
                          'Together since $formattedDate',
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,  // ← troncamento se troppo lungo
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_calendar, size: 24),
                  color: const Color(0xFFFF9EAA),
                  onPressed: _isLoading ? null : _pickDate,
                  tooltip: 'Change anniversary',
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              '$daysTogether days together!',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFFFF9EAA)),
            ),
          ],
        ),
      ),
    );
  }
}