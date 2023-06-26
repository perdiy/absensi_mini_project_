import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:online/homepage.dart';
import 'package:online/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi tanggal dan waktu lokal
  await initializeDateFormatting('id_ID', null);

  // Mendapatkan instance Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  final String userId = prefs.getString('userId') ?? '';

  Widget? home;

  // Mengecek apakah ada pengguna yang terautentikasi
  if (userId.isEmpty) {
    // Jika tidak ada pengguna yang terautentikasi, tampilkan halaman Welcome
    home = Welcome(
      onTap: () {},
    );
  } else {
    // Jika ada pengguna yang terautentikasi, tampilkan halaman HomePage
    home = HomePage();
  }

  // Menjalankan aplikasi Flutter
  runApp(MyApp(home: home));
}

class MyApp extends StatelessWidget {
  final Widget? home;
  const MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: home,
      debugShowCheckedModeBanner: false,
    );
  }
}
