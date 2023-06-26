import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online/pages/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required Null Function() onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// variabl menyimpan nilai
class _RegisterPageState extends State<RegisterPage> {
  String email = '';
  String password = '';
  String name = '';
  String nik = '';
  String alamat = '';
  bool loading = false;
  String errorText = '';

  handleSubmit() async {
    // Menampilkan SnackBar jika item kosong
    if (email.isEmpty &&
        password.isEmpty &&
        name.isEmpty &&
        nik.isEmpty &&
        alamat.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Mohon lengkapi data terlebih dahulu'),
        behavior: SnackBarBehavior.floating,
      ));
    }

    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance // metod email pass
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        // Menyimpan ID baru
        await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .set({
          "name": name,
          "email": email,
          "nik": nik,
          "alamat": alamat,
          "uid": result.user!.uid,
          "created_at": FieldValue.serverTimestamp(),
        }).then((value) {
          setState(() {
            loading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Berhasil daftar. Silahkan login terlebih dahulu'),
            behavior: SnackBarBehavior.floating,
          ));
          // Pindah ke halaman LogiPage jika berhasil regis
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LoginPage(
                onTap: () {},
              ),
            ),
          );
        });
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;

        if (e.code == 'email-already-in-use') {
          errorText = 'Email sudah digunakan';
        } else if (e.code == 'invalid-email') {
          errorText = 'Email tidak valid';
        } else if (e.code == 'weak-password') {
          errorText = 'Password lemah';
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
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 60.0),
                              child: Text(
                                "Create your account",
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
                            "Please fill Fullname, No. KTP, Ship & Password to register your app",
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
                                  Text('Username'),
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
                                  hintText: 'Username',
                                ),
                                onChanged: (value) {
                                  name = value;
                                },
                              ),
                              SizedBox(height: 25),
                              Row(
                                children: [
                                  Text('No. KTP'),
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
                                  hintText: '3209029320489',
                                ),
                                onChanged: (value) {
                                  nik = value;
                                },
                              ),
                              SizedBox(height: 25),
                              Row(
                                children: [
                                  Text('Alamat'),
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
                                  hintText: 'Alamat',
                                ),
                                onChanged: (value) {
                                  alamat = value;
                                },
                              ),
                              SizedBox(height: 25),
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
                                          'Register',
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
                                      builder: (context) => LoginPage(
                                        onTap: () {},
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already Have Account?",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const Text(
                                      "Login",
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
