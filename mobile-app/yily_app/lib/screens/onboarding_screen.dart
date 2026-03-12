import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/providers/auth_provider.dart';
import 'package:yily_app/services/api_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _tokenController = TextEditingController();
  bool _isCreating = true;
  bool _isLoading = false;

  Future<void> _handleAction() async {
    setState(() => _isLoading = true);
    final api = ApiService();
    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      if (_isCreating) {
        await api.createCouple(_nameController.text);
      } else {
        await api.joinCouple(_tokenController.text, _nameController.text);
      }
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isCreating ? 'Crea coppia' : 'Unisciti')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Il tuo nome'),
            ),
            if (!_isCreating) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _tokenController,
                decoration: const InputDecoration(labelText: 'Codice coppia'),
              ),
            ],
            const SizedBox(height: 24),
            if (_isLoading) const CircularProgressIndicator(),
            if (!_isLoading)
              ElevatedButton(
                onPressed: _handleAction,
                child: Text(_isCreating ? 'Crea' : 'Unisciti'),
              ),
            TextButton(
              onPressed: () => setState(() => _isCreating = !_isCreating),
              child: Text(_isCreating ? 'Ho già una coppia' : 'Crea nuova coppia'),
            ),
          ],
        ),
      ),
    );
  }
}