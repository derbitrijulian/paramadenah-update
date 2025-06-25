import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sign_in.dart'; // Pastikan path ini sesuai
import 'sign_up.dart'; // Pastikan path ini sesuai

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
      statusBarColor: Color(0xFF075A8E),
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF075A8E),
        body: Container(
          color: const Color(0xFF075A8E),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                child: Image.asset(
                  'png/logoapk2.png',
                  width: 352,
                  height: 99,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Selamat datang di Paramadenah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silahkan lakukan Sign up atau Login untuk mengoperasikan Paramadenah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                indicatorWeight: 2,
                tabs: const [
                  Tab(text: 'SIGN IN'),
                  Tab(text: 'SIGN UP'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SignIn(
                      isPasswordVisible: isPasswordVisible,
                      togglePasswordVisibility: togglePasswordVisibility,
                    ),
                    SignUp(
                      isPasswordVisible: isPasswordVisible,
                      togglePasswordVisibility: togglePasswordVisibility,
                    ),
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