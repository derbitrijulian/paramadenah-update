import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth.dart';
import '../widgets/custom_text_field.dart';

class SignIn extends StatefulWidget {
  final bool isPasswordVisible;
  final VoidCallback togglePasswordVisibility;

  const SignIn({
    super.key,
    required this.isPasswordVisible,
    required this.togglePasswordVisibility,
  });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _errorMessage;
  bool _isHovered = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        final result = await _authService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        setState(() {
          _errorMessage = result['message'];
        });

        if (result['success']) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', result['userId']);
          Navigator.pushReplacementNamed(context, '/homescreen');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_errorMessage!)),
          );
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'user-not-found') {
            setState(() {
              _errorMessage = 'Email tidak terdaftar, silakan daftar terlebih dahulu';
            });
          } else if (e.code == 'wrong-password') {
            setState(() {
              _errorMessage = 'Kata sandi salah';
            });
          } else {
            setState(() {
              _errorMessage = 'Terjadi kesalahan: ${e.message ?? e.toString()}';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
          });
        }
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
        padding: const EdgeInsets.fromLTRB(24, 75, 24, 170),
        color: const Color(0xFFD4D4D4),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'png/gembok.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !widget.isPasswordVisible,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan sandi Anda',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan sandi Anda';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: widget.togglePasswordVisibility,
                      icon: Image.asset(
                        'png/blind.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _handleSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF075A8E),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Masuk'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Atau',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  // Handle Apple sign in
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'png/apel.png',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Masuk dengan Apple',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  // Handle Google sign in
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'png/google.png',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Masuk dengan Google',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  cursor: SystemMouseCursors.click,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      children: [
                        const TextSpan(text: 'Belum punya akun? '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              DefaultTabController.of(context)?.animateTo(1);
                            },
                            child: Text(
                              'Buat Akun',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueAccent,
                                decoration: _isHovered
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}