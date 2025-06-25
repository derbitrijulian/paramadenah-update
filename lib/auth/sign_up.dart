import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth.dart';
import '../widgets/custom_text_field.dart';

class SignUp extends StatefulWidget {
  final bool isPasswordVisible;
  final VoidCallback togglePasswordVisibility;

  const SignUp({
    super.key,
    required this.isPasswordVisible,
    required this.togglePasswordVisibility,
  });

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final result = await _authService.registerUser(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        setState(() {
          _errorMessage = result['message'];
        });

        if (result['success']) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', result['userId']);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Link verifikasi sudah dikirim ke email.')),
          );
          // Opsional: Navigasi ke homescreen setelah registrasi
          // Navigator.pushReplacementNamed(context, '/homescreen');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_errorMessage!)),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 75, 24, 144),
        color: const Color(0xFFD4D4D4),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                iconPath: 'png/kepala.png',
                hintText: 'Nama Anda',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama Anda';
                  }
                  return null;
                },
              ),
              CustomTextField(
                iconPath: 'png/email.png',
                hintText: 'Masukkan email Anda',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan email Anda';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              CustomTextField(
                iconPath: 'png/gembok.png',
                hintText: 'Masukkan sandi Anda',
                controller: _passwordController,
                obscureText: !widget.isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan sandi Anda';
                  }
                  if (value.length < 6) {
                    return 'Sandi harus minimal 6 karakter';
                  }
                  return null;
                },
              ),
              CustomTextField(
                iconPath: 'png/gembok.png',
                hintText: 'Konfirmasikan sandi Anda',
                controller: _confirmPasswordController,
                obscureText: !widget.isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasikan sandi Anda';
                  }
                  if (value != _passwordController.text) {
                    return 'Sandi tidak cocok';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    children: [
                      TextSpan(text: 'Dengan membuat akun ini, anda menyetujui '),
                      TextSpan(
                        text: 'Syarat & Ketentuan',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      TextSpan(text: ' yang berlaku'),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF075A8E),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Sign up'),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    children: [
                      TextSpan(text: 'Sudah punya akun? '),
                      TextSpan(
                        text: 'Masuk',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}