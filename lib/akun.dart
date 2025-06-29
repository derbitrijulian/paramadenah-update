import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current user from Firebase
    final User? user = FirebaseAuth.instance.currentUser;

    // Extract username from email (before @) if displayName is null
    final String username = user?.displayName ?? user?.email?.split('@')[0] ?? 'unknown';

    return Scaffold(
      body: Container(
        color: Colors.blue[100], // Equivalent to bg-blue-100
        child: Stack(
          children: [
            // Background Image
            Image.asset(
              'png/bgprofil.png', // Replace with actual asset path
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            // Profile Content Overlay
            Positioned(
              top: 80,
              left: 115, // Adjusted to match the design
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'png/akunprofil.png',
                        width: 180,
                        height: 194.9,
                      ),
                      Positioned(
                        top: 208,
                        right: 32,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'png/edit.png', // Replace with actual asset path
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    user?.email ?? 'jaguarneon@students.paramadina.ac.id',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Additional Profile Info
            Positioned(
              bottom: 96, // Adjusted to bottom-24 (24 * 4 = 96)
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64), // Adjusted to px-16 (16 * 4 = 64)
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80), // Adjusted to mt-20 (20 * 4 = 80)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Show dialog for password change
                            showDialog(
                              context: context,
                              builder: (context) => ChangePasswordDialog(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: Color(0xFF075A8E), // Blue stroke color
                                width: 2.0, // Consistent border width
                              ),
                            ),
                          ),
                          child: const Text(
                            'Ubah Password',
                            style: TextStyle(
                              color: Color(0xFF075A8E), // White text color
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          onPressed: () async {
                            final authService = AuthService();
                            await authService.signOut();
                            Navigator.pushReplacementNamed(context, '/auth');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF075A8E),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Keluar',
                            style: TextStyle(
                              color: Colors.white, // White text color
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// New widget for password change dialog
class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController(); // New field for current password
  String? _errorMessage;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  Future<void> _reAuthenticateAndChangePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.email != null) {
          // Re-authenticate user
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _currentPasswordController.text,
          );
          await user.reauthenticateWithCredential(credential);

          // Update password after successful re-authentication
          await user.updatePassword(_newPasswordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password berhasil diubah')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Gagal mengubah password: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Password Saat Ini',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan password saat ini';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan password baru';
                }
                if (value.length < 6) {
                  return 'Password harus minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan konfirmasi password';
                }
                if (value != _newPasswordController.text) {
                  return 'Password tidak cocok';
                }
                return null;
              },
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _reAuthenticateAndChangePassword,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}