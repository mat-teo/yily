import 'package:flutter/material.dart';
import 'package:yily_app/services/api_service.dart';
import'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yily_app/utils/error_handler.dart';

class AddReasonScreen extends StatefulWidget {
  const AddReasonScreen({super.key});

  @override
  State<AddReasonScreen> createState() => _AddReasonScreenState();
}

class _AddReasonScreenState extends State<AddReasonScreen> {
  final _contentController = TextEditingController();
  bool _isLoading = false;

  Future<void> _add() async {
    if (_contentController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    final api = ApiService();
    try {
      await api.addReason(_contentController.text.trim()); 
      Navigator.pop(context, true);
    } catch (e) {
      ErrorHandler.showError(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuovo motivo')),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "I love you 'cause...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 32.h),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _add,
                  child: const Text('Aggiungi'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}