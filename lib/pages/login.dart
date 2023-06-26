import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online/homepage.dart';
import 'package:online/pages/forgot_password.dart';
import 'package:online/pages/register.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required Null Function() onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  bool loading = false;
  String errorText = '';

  handleSubmit() async {
    if (email.isEmpty && password.isEmpty) {
      // Menampilkan SnackBar jika email dan password kosong
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Mohon lengkapi data terlebih dahulu'),
        behavior: SnackBarBehavior.floating,
      ));
    }

    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        // Menyimpan ID pengguna ke Shared Preferences
        final prefs = await SharedPreferences.getInstance();
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .get()
            .then((userData) {
          if (userData.exists) {
            setState(() {
              loading = false;
            });

            prefs.setString('userId', result.user!.uid);
            prefs.setString('userName', userData.data()?['name']);
            prefs.setString('email', userData.data()?['email']);

            if (userData.data()?['is_admin'] != null) {
              prefs.setBool('isAdmin', userData.data()?['is_admin']);
            }

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Berhasil login. Selamat datang!'),
              behavior: SnackBarBehavior.floating,
            ));

            // Pindah ke halaman HomePage setelah login berhasil
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else {
            setState(() {
              loading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Pengguna tidak ditemukan!'),
              behavior: SnackBarBehavior.floating,
            ));
          }
        });
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;

        if (e.code == 'invalid-email') {
          errorText = 'Email tidak valid';
        } else if (e.code == 'user-not-found') {
          errorText = 'Pengguna tidak ditemukan';
        } else if (e.code == 'wrong-password') {
          errorText = 'Password salah';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/image/latar.png"), fit: BoxFit.fill),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 60.0),
                              child: Text(
                                "Welcome to Login",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0, left: 25),
                        child: Container(
                          margin: EdgeInsets.only(right: 50),
                          child: Text(
                            "Please fill Username & password to login your app account",
                            style: TextStyle(
                                fontSize: 16, color: Colors.white, height: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text('Email'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.8),
                                  hintText: 'Email',
                                ),
                                onChanged: (value) {
                                  email = value;
                                },
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Text('Password'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.8),
                                  hintText: 'Password',
                                ),
                                obscureText: true,
                                onChanged: (value) {
                                  password = value;
                                },
                              ),
                              const SizedBox(height: 16),
                              errorText.isNotEmpty
                                  ? Text(
                                      errorText,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    )
                                  : const SizedBox(),
                              TextButton(
                                style: const ButtonStyle(
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassword(
                                        onTap: () {},
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "Forgot password?",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 350,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () => handleSubmit(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    side: BorderSide.none,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: loading
                                      ? const Center(
                                          child: SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : const Text(
                                          'Login Now',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ),
                              ),
                              TextButton(
                                style: const ButtonStyle(
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(
                                        onTap: () {},
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have Account? please ",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
