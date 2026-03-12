import 'package:flutter/material.dart';
import 'package:yily_app/services/api_service.dart';

class AddReasonScreen extends StatefulWidget {
  const AddReasonScreen({super.key});

  @override
  State<AddReasonScreen> createState() => _AddReasonScreenState();
}

class _AddReasonScreenState extends State<AddReasonScreen> {
  final _contentController = TextEditingController();
  int? _toUserId; // Per MVP assumiamo che conosciamo l'ID del partner (da auth o da /me)

  // Per semplicità MVP: chiediamo l'ID del partner (in futuro lo prendiamo da API /me)
  final _toUserIdController = TextEditingController();

  Future<void> _addReason() async {
    if (_contentController.text.isEmpty || _toUserIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compila tutti i campi')),
      );
      return;
    }

    final api = ApiService();
    try {
      await api.addReason(
        _contentController.text,
        int.parse(_toUserIdController.text),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aggiungi motivo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Il motivo...'),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _toUserIdController,
              decoration: const InputDecoration(labelText: 'ID del partner'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addReason,
              child: const Text('Aggiungi'),
            ),
          ],
        ),
      ),
    );
  }
}