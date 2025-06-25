import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Register a new user with Firebase Authentication and store data in Realtime Database
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();

      String userId = userCredential.user!.uid;
      await _database.child('users').child(userId).set({
        'name': name,
        'email': email,
        'role': 'user',
        'createdAt': DateTime.now().toIso8601String(),
        'isVerified': false,
      });

      return {
        'success': true,
        'message': 'Registrasi berhasil! Silakan verifikasi email Anda.',
        'userId': userId,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Registrasi gagal: ${e.toString()}',
      };
    }
  }

  // Sign in user with Firebase Authentication
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user!.reload();

    if (userCredential.user!.emailVerified) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);

      await _database.child('users').child(userCredential.user!.uid).update({
        'isVerified': true,
      });

      return {
        'success': true,
        'message': 'Login berhasil!',
        'userId': userCredential.user!.uid,
      };
    } else {
      return {
        'success': false,
        'message': 'Email belum diverifikasi. Silakan verifikasi terlebih dahulu.',
      };
    }
  }

  // Verify user (called after clicking verification link)
  Future<void> verifyUser(String userId) async {
    try {
      await _database.child('users').child(userId).update({'isVerified': true});
    } catch (e) {
      print('Verification failed: $e');
    }
  }

  // Logout user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}