import 'package:flutter/material.dart';
import 'package:yily_app/models/reason.dart';
import 'package:intl/intl.dart';

class ReasonCard extends StatelessWidget {
  final Reason reason;

  const ReasonCard({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,           
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0), // orizzontale = 0
      elevation: 0, // rimuove l'ombra
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // mantieni gli angoli arrotondati
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reason.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Scritto il ${DateFormat('dd MMM yyyy').format(reason.createdAt)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    )));
  }
}