import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/providers/user_provider.dart';
import 'package:yily_app/services/api_service.dart';

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
      initialDate: DateTime.now().subtract(const Duration(days: 365)),
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
      await api.setAnniversaryDate(picked);

      // Ricarichiamo i dati utente
      await userProv.loadUserInfo();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data di fidanzamento salvata ❤️')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore durante il salvataggio: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context, listen: true);
    final anniversary = userProv.anniversaryDate;

    // === MODALITÀ: Data già impostata ===
    if (anniversary != null) {
      final daysTogether = DateTime.now().difference(anniversary).inDays;
      final formattedDate = DateFormat('dd/MM/yyyy').format(anniversary);

      return Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.favorite, color: const Color(0xFFFF6B6B), size: 28.w),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Insieme dal $formattedDate',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                '$daysTogether giorni insieme',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF9EAA),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // === MODALITÀ: Data non ancora impostata ===
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        leading: Icon(Icons.calendar_today, color: const Color(0xFFFF9EAA), size: 32.w),
        title: Text(
          'Quando avete iniziato?',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Imposta la data di fidanzamento',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
        trailing: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : const Icon(Icons.arrow_forward_ios),
        onTap: _isLoading ? null : _pickDate,
      ),
    );
  }
}