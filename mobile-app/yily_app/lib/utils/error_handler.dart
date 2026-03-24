// lib/utils/error_handler.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yily_app/screens/onboarding_screen.dart';

class ErrorHandler {
  static void showError(BuildContext context, dynamic error) {
    String message = 'Something went wrong...';

    if (error is DioException) {
      if (error.response != null) {
        final status = error.response!.statusCode;
        final data = error.response!.data;

        if (status == 400) {
          message = data['detail'] ?? 'Invalid data, check and try again';
        } else if (status == 401 || status == 403) {
          message = 'Session expired. Login into your couple again';
        } else if (status == 404) {
          message = 'Not found...';
        } else if (status == 500) {
          message = 'Opss.. Server error. Try again later';
        } else {
          message = 'Error ${status ?? 'unknown'} – ${data['detail'] ?? 'Try again'}';
        }
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        message = 'Connection slow or absent. Check your internet and try again.';
      } else if (error.toString().contains('TypeError') || error.toString().contains('Unexpected null value')) {
      message = 'Ops... something went wrong\nTry again';
    }else if (error.type == DioExceptionType.cancel) {
        message = 'Cancelled request...';
      } else {
        message = 'Network error: ${error.message ?? 'No details'}';
      }
    } else if (error is Exception) {
      message = error.toString().replaceAll('Exception: ', '');
      if (message.isEmpty) message = 'Unknown error...';
    } else if (error is TypeError){
      message="Incorrect information received";
    }else {
      message = "Error";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Expanded(child: Text(message, style: TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: const Color(0xFFFF6B6B),
        duration: const Duration(seconds: 4),          
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: 16,
          right: 16,
        ),
      ),
    );

  }
}