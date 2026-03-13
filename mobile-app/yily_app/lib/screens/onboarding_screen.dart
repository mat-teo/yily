import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yily_app/providers/auth_provider.dart';
import 'package:yily_app/services/api_service.dart';
import'package:flutter_screenutil/flutter_screenutil.dart';


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
    if (_nameController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    final api = ApiService();
    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      if (_isCreating) {
        await api.createCouple(_nameController.text.trim());
      } else {
        if (_tokenController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inserisci il codice coppia')),
          );
          return;
        }
        await api.joinCouple(_tokenController.text.trim(), _nameController.text.trim());
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo o titolo stilizzato
                Text(
                  'Yily',
                  style: TextStyle(
                    fontSize: 64.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFF9EAA),
                    letterSpacing: -1.5,
                  ),
                ),
                SizedBox(height: 48.h),
                Text(
                  _isCreating ? 'Crea la tua coppia' : 'Unisciti alla coppia',
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 40.h),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                  ),
                ),
                if (!_isCreating) ...[
                  SizedBox(height: 16.h),
                  TextField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      labelText: 'Codice coppia',
                    ),
                  ),
                ],
                SizedBox(height: 40.h),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleAction,
                      child: Text(_isCreating ? 'Crea' : 'Unisciti'),
                    ),
                  ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () => setState(() => _isCreating = !_isCreating),
                  child: Text(
                    _isCreating ? 'Ho già un codice' : 'Crea una nuova coppia',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}