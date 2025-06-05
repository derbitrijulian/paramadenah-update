import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF075A8E), // background_secondary
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        '/homescreen': (context) => const HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home Screen Placeholder'),
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF00304D),
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 360), // max-w-sm
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF00304D), // Ubah dari Colors.white ke biru tua
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
              Image.asset(
                'png/logoapk2.png',
                width: 352,
                height: 99,
              ),
              const SizedBox(height: 16),
              // Welcome Text
              const Text(
                'Selamat datang di Paramadenah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Ubah warna teks ke putih
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silahkan lakukan Sign up atau Login untuk mengoperasikan Paramadenah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70, // Ubah warna teks ke putih dengan opacity
                ),
              ),
              const SizedBox(height: 16),
              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: Colors.white, // Ubah warna label aktif ke putih
                unselectedLabelColor: Colors.white70, // Ubah warna label tidak aktif
                indicatorColor: Colors.white, // Ubah warna indikator
                indicatorWeight: 2,
                tabs: const [
                  Tab(text: 'Login'),
                  Tab(text: 'SIGN UP'),
                ],
              ),
              // Tab Bar View
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5, // Define a fixed height
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SignIn(
                      isPasswordVisible: isPasswordVisible,
                      togglePasswordVisibility: togglePasswordVisibility,
                    ),
                    const SignUp(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24),
        color: const Color(0xFF075A8E), // Ubah background ke biru lebih terang
        child: Column(
          children: [
            // Name Field
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
                      'png/kepala.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Nama Anda',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Email Field
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
                      'png/email.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan email Anda',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Password Field
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
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan sandi Anda',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Confirm Password Field
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
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Konfirmasikan sandi Anda',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Terms and Conditions
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                  children: [
                    const TextSpan(text: 'Dengan membuat akun ini, anda menyetujui '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to Terms and Conditions
                        },
                        child: const Text(
                          'Syarat & Ketentuan',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const TextSpan(text: ' yang berlaku'),
                  ],
                ),
              ),
            ),
            // Sign Up Button
            ElevatedButton(
              onPressed: () {
                // Handle sign up logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00304D), // Warna tombol lebih gelap
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignIn extends StatelessWidget {
  final bool isPasswordVisible;
  final VoidCallback togglePasswordVisibility;

  const SignIn({
    super.key,
    required this.isPasswordVisible,
    required this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24),
        color: const Color(0xFF075A8E), // Ubah background ke biru lebih terang
        child: Column(
          children: [
            // Email Field
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
                      'png/email.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan email Anda',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Password Field
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
                      obscureText: !isPasswordVisible,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan sandi Anda',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: togglePasswordVisibility,
                    icon: Image.asset(
                      'png/blind.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
            // Sign In Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/homescreen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00304D), // Warna tombol lebih gelap
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Masuk'),
            ),
            // Divider
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Atau',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            // Apple Sign In
            OutlinedButton(
              onPressed: () {
                // Handle Apple sign in
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: const BorderSide(color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Google Sign In
            OutlinedButton(
              onPressed: () {
                // Handle Google sign in
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: const BorderSide(color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            // Sign Up Link
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                  children: [
                    const TextSpan(text: 'Belum punya akun? '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          // Switch to Sign Up tab
                          DefaultTabController.of(context)?.animateTo(1);
                        },
                        child: const Text(
                          'Buat Akun',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
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