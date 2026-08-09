import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _remember = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                const Icon(Icons.luggage_outlined, size: 64),
                const SizedBox(height: 16),
                const Text('Trip Expense Manager', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
                TextField(controller: _userCtrl, decoration: const InputDecoration(labelText: 'Username / Mobile')),
                const SizedBox(height: 12),
                TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v ?? false)),
                    const Text('Remember login'),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Developed by Faizan Ahmed TK',
                  style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final ok = context.read<AppProvider>().login(_userCtrl.text.trim(), _passCtrl.text.trim());
                      if (ok) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
                      }
                    },
                    child: const Text('Login'),
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
