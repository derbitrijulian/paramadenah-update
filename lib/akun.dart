import 'package:flutter/material.dart';
import '../services/auth.dart'; // Impor AuthService
import '../auth/auth_page.dart'; // Impor AuthPage

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              left: 80, // Adjusted to match the design
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
                  const Text(
                    'JAGUAR NEON',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    '1234567890',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Desain Komunikasi Visual',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'jaguarneon@students.paramadina.ac.id',
                    style: TextStyle(
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
                            // Ubah Password logic
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