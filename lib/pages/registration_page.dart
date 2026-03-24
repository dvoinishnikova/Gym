import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final error = await ApiService.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error == null) {
      context.go('/survey');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white70),
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF323232),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFED6E00)),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Реєстрація",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputStyle("Ім’я", Icons.person),
                  validator: (v) =>
                      v!.isEmpty ? "Введіть ім’я" : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputStyle("Email", Icons.email),
                  validator: (v) =>
                      v != null && v.contains('@')
                          ? null
                          : "Некоректний email",
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputStyle("Пароль", Icons.lock),
                  validator: (v) =>
                      v!.length < 6 ? "Мін 6 символів" : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputStyle("Повторіть пароль", Icons.lock),
                  validator: (v) =>
                      v != _passwordController.text
                          ? "Паролі не співпадають"
                          : null,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED6E00),
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white)
                        : const Text("Зареєструватися"),
                  ),
                ),

                const SizedBox(height: 20),

               Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text(
      "Вже є акаунт? ",
      style: TextStyle(color: Colors.white70),
    ),
    TextButton(
      onPressed: () => context.go('/login'),
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFED6E00),
      ),
      child: const Text(
        "Увійти",
        style: TextStyle(
          color: Color(0xFFED6E00),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),
              ],
            ),
          ),
        ),
      ),
    );
  }
}